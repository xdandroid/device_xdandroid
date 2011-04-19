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

#include <unistd.h>

#include <cutils/log.h>

#include "LightSensor.h"

#define DEBUG

#ifdef DEBUG
#   define D(...) LOGD("LightSensor::"__VA_ARGS__)
#else
#   define D(...) ((void)0)
#endif

/*****************************************************************************/

LightSensor::LightSensor()
    : SensorBase(NULL, NULL),
      mEnabled(0),
      mHasPendingEvent(false)
{
    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = ID_L;
    mPendingEvent.type = SENSOR_TYPE_LIGHT;
    memset(mPendingEvent.data, 0, sizeof(mPendingEvent.data));
}

LightSensor::~LightSensor()
{
}

int LightSensor::enable(int32_t handle, int enabled)
{
    D("enable(%d, %d)\n", handle, enabled);

    mEnabled = enabled;
    mHasPendingEvent = enabled ? true : false;

    return 0;
}

bool LightSensor::hasPendingEvents() const
{
    return mHasPendingEvent;
}

int LightSensor::readEvents(sensors_event_t* data, int count)
{
    D("readEvents(..., count=%d)\n", count);

    if (count < 1)
        return -EINVAL;

    // we have to deliver one sensor event after being enabled in order
    // for userland to determine the light sensor working;
    // this in turn brings userland to switch to auto brightness mode
    // when requested (signaled to liblights)
    mPendingEvent.timestamp = getTimestamp();
    *data++ = mPendingEvent;

    // no more events to deliver after this read
    mHasPendingEvent = false;

    return 1;
}
