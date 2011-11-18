/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <fcntl.h>
#include <errno.h>
#include <math.h>
#include <poll.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/select.h>
#include <strings.h>
#include <stdlib.h>

#include <cutils/log.h>

//#define DEBUG

#ifdef DEBUG
#   define D(...) LOGD(__VA_ARGS__)
#else
#   define D(...) ((void)0)
#endif

#include "EvdevSensor.h"

/*****************************************************************************/

EvdevSensor::EvdevSensor()
: SensorBase("", "detect"),
      mEnabled(0),
      mPendingMask(0),
      mInputReader(32)
{
    memset(mPendingEvents, 0, sizeof(mPendingEvents));

    mPendingEvents[Accelerometer].version = sizeof(sensors_event_t);
    mPendingEvents[Accelerometer].sensor = ID_A;
    mPendingEvents[Accelerometer].type = SENSOR_TYPE_ACCELEROMETER;
    mPendingEvents[Accelerometer].acceleration.status = SENSOR_STATUS_ACCURACY_HIGH;

    isNewBma150Driver = false;
    data_fd = openInput(data_name);

    for (int i=0 ; i<numSensors ; i++)
        mDelays[i] = 200000000; // 200 ms by default
}

EvdevSensor::~EvdevSensor() {
}

int EvdevSensor::enable(int32_t handle, int en)
{
    D("enable(%d, %d)", handle, en);
    int what = -1;
    switch (handle) {
        case ID_A: what = Accelerometer; break;
    }

    int newState  = en ? 1 : 0;
    int err = 0;

    if ((uint32_t(newState)<<what) != (mEnabled & (1<<what))) {
        char *filename;
        switch (what) {
            case Accelerometer:
            if (isNewBma150Driver) {
                asprintf(&filename, "/sys/devices/virtual/input/%s/mode", physDevName);
            } else {
                asprintf(&filename, "/sys/class/i2c-adapter/i2c-0/%s/enable", physDevName+4);
            }
            break;
        }
        short flags = newState;
        FILE *fd = fopen(filename, "w");

        err =  !fd ? -errno : 0;
        LOGE_IF(err, "enable(): open %s failed (%s)", filename, strerror(-err));
        free(filename);

        if (!err) {
            fprintf(fd, "%d\n", isNewBma150Driver ? (en ? 0 : 2) : newState);
            fclose(fd);
            mEnabled &= ~(1<<what);
            mEnabled |= (uint32_t(flags)<<what);
            update_delay();
        }
    }
    return err;
}

int EvdevSensor::setDelay(int32_t handle, int64_t ns) {
    D("setDelay(%d, %d)", handle, (int)ns);
    int what = -1;
    switch (handle) {
        case ID_A: what = Accelerometer; break;
    }

    if (uint32_t(what) >= numSensors)
        return -EINVAL;

    if (ns < 0)
        return -EINVAL;

    if (ns < 100000000)
        ns = 100000000;
    mDelays[what] = ns;
    return update_delay();
}

int EvdevSensor::update_delay()
{
    D("update_delay()");
    if (mEnabled) {
        uint64_t wanted = -1LLU;
        for (int i=0 ; i<numSensors ; i++) {
            if (mEnabled & (1<<i)) {
                uint64_t ns = mDelays[i];
                wanted = wanted < ns ? wanted : ns;
            }
        }
        short delay = int64_t(wanted) / 1000000;
        char *filename;
        if (isNewBma150Driver) {
            asprintf(&filename, "/sys/devices/virtual/input/%s/delay", physDevName);
        } else {
            asprintf(&filename, "/sys/class/i2c-adapter/i2c-0/%s/rate", physDevName+4);
        }
        FILE *fd=fopen(filename, "w");
        free(filename);
        if(!fd) {
            LOGW("update_delay(): couldn't open %s (%s)\n", filename, strerror(errno));
            return -errno;
        }
        fprintf(fd, "%d\n", delay);
        D("update_delay() set rate to %d", delay);
        fclose(fd);
    }
    return 0;
}

int EvdevSensor::openInput(const char* inputName)
{
    int fd = -1;
    const char *dirname = "/dev/input";
    char devname[PATH_MAX];
    char *filename;
    DIR *dir;
    struct dirent *de;
    dir = opendir(dirname);
    if(dir == NULL)
        return -1;
    strcpy(devname, dirname);
    filename = devname + strlen(devname);
    *filename++ = '/';
    while((de = readdir(dir))) {
        if(de->d_name[0] == '.' &&
                (de->d_name[1] == '\0' ||
                        (de->d_name[1] == '.' && de->d_name[2] == '\0')))
            continue;
        strcpy(filename, de->d_name);
        fd = open(devname, O_RDONLY);
        if (fd>=0) {
            char name[80];
            if (ioctl(fd, EVIOCGNAME(sizeof(name) - 1), &name) < 1) {
                name[0] = '\0';
            }
            D("openInput: inputName=%s name=%s\n", inputName, name);
            if (!strcmp(inputName, "detect"))
            {
                if (!strcmp(name, "kionix-kxsd9"))
                {
                    bzero(physDevName, 20);
                    ioctl(fd, EVIOCGPHYS(sizeof(physDevName)-1), &physDevName);
                    if(strcmp(physDevName, "i2c/0-0019")==0) {
                        axisOrder[0]=-2;
                        axisOrder[1]=-1;
                        axisOrder[2]=3;
                    } else {
                        axisOrder[0]=2;
                        axisOrder[1]=-1;
                        axisOrder[2]=3;
                    }
                    parse_axis_order();
                    
                    D("using %s (name=%s,physDevName=%s)", devname, name, physDevName);
                    break;
                }
                else if (!strcmp(name, "bma150"))
                {
                    bzero(physDevName, 20);
                    ioctl(fd, EVIOCGPHYS(sizeof(physDevName)-1), &physDevName);
                    if (0 == strlen(physDevName)) {
                        isNewBma150Driver = true;
                        // eventX > inputX
                        snprintf(physDevName, 20, "input%s", de->d_name + 5);
                    }
                    axisOrder[0]=-1;
                    axisOrder[1]=2;
                    axisOrder[2]=-3;

                    parse_axis_order();

                    D("using %s (name=%s,physDevName=%s,driver=%s)", devname,
                        name, physDevName, isNewBma150Driver ? "new" : "old");
                    break;
                } else {
                    close(fd);
                    fd = -1;
                }
            }
            else
            {
                if (!strcmp(name, inputName)) {
                    break;
                } else {
                    close(fd);
                    fd = -1;
                }
            }
        }
    }
    closedir(dir);
    LOGE_IF(fd<0, "couldn't find '%s' input device", inputName);
    return fd;
}

int EvdevSensor::readEvents(sensors_event_t* data, int count)
{
    if (count < 1)
        return -EINVAL;

    ssize_t n = mInputReader.fill(data_fd);
    if (n < 0)
        return n;

    int numEventReceived = 0;
    input_event const* event;

    while (count && mInputReader.readEvent(&event)) {
        int type = event->type;
        if (type == EV_ABS) {
            processEvent(event->code, event->value);
            mInputReader.next();
        } else if (type == EV_SYN) {
            int64_t time = timevalToNano(event->time);
            for (int j=0 ; count && mPendingMask && j<numSensors ; j++) {
                if (mPendingMask & (1<<j)) {
                    mPendingMask &= ~(1<<j);
                    mPendingEvents[j].timestamp = time;
                    if (mEnabled & (1<<j)) {
                        *data++ = mPendingEvents[j];
                        count--;
                        numEventReceived++;
                    }
                }
            }
            if (!mPendingMask) {
                mInputReader.next();
            }
        } else {
            LOGE("EvdevSensor: unknown event (type=%d, code=%d)",
                    type, event->code);
            mInputReader.next();
        }
    }

    return numEventReceived;
}

void EvdevSensor::processEvent(int code, int value)
{
    float convertedValue = value * GRAVITY_EARTH * 2.0f / 512.0f;
    switch (code) {
        case ABS_X:
        case ABS_Y:
        case ABS_Z:
            float *axes[3];
            axes[0] = &mPendingEvents[Accelerometer].acceleration.x;
            axes[1] = &mPendingEvents[Accelerometer].acceleration.y;
            axes[2] = &mPendingEvents[Accelerometer].acceleration.z;
            mPendingMask |= 1<<Accelerometer;
            D("processEvent: code=%d value=%d convertedValue=%f", code, value, convertedValue);
            *axes[abs(axisOrder[code])-1] = axisOrder[code] > 0 ? convertedValue : -convertedValue;
            break;
        default:
            D("processEvent: unknown event code=%d value=%d", code, value);
    }
}

void EvdevSensor::parse_axis_order()
{
    int fd=open("/proc/cmdline", O_RDONLY);
    char buf[1024];
    char *ptr,*ptr2;
    int i;
    buf[1023]=0;
    if(fd<0)
        return;
    if(read(fd, buf, 1023)<0) {
        close(fd);
        return;
    }
    ptr=strstr(buf, "gsensor_axis=");
    if(!ptr) {
        return;
    }
    if(ptr!=buf)
        if(ptr[-1]!=' ')
            return;
    ptr+=strlen("gsensor_axis=");

    for(i=0;i<3;++i) {
        ptr2=index(ptr, ',');
        if(!ptr2)
            ptr2=index(ptr, ' ');
        if(ptr2)
            *ptr2=0;
        axisOrder[i]=atoi(ptr);
        ptr=ptr2+1;
    }
}
