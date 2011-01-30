#
# Product-specific compile-time definitions.
#

TARGET_BOARD_PLATFORM := msm7k
TARGET_CPU_ABI := armeabi
TARGET_ARCH_VARIANT := armv5te

TARGET_NO_BOOTLOADER := true

# Let's get some speed by default now.
WITH_JIT := true
ENABLE_JSC_JIT := true

# Wifi related defines
BOARD_WPA_SUPPLICANT_DRIVER := CUSTOM
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := libWifiApi
BOARD_WLAN_TI_STA_DK_ROOT   := system/wlan/ti/sta_dk_4_0_4_32
WIFI_DRIVER_MODULE_PATH     := "/system/lib/modules/wlan.ko"
WIFI_DRIVER_MODULE_ARG      := ""
WIFI_DRIVER_MODULE_NAME     := "wlan"
WIFI_DRIVER_FW_AP_PATH      := "/etc/firmware/BCM4325_apsta.bin"
WIFI_FIRMWARE_LOADER        := "wlan_loader"

TARGET_BOOTLOADER_BOARD_NAME := msm

BOARD_KERNEL_CMDLINE := no_console_suspend=1

BOARD_HAVE_BLUETOOTH := true

# Rhodium has Broadcom bluetooth
BOARD_HAVE_BLUETOOTH_BCM := true

BOARD_VENDOR_USE_AKMD := true

USE_PV_WINDOWS_MEDIA := false

BUILD_WITH_FULL_STAGEFRIGHT := true

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# IMPORTANT TODO: Update libsensors
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
TARGET_USES_OLD_LIBSENSORS_HAL := true

BOARD_BOOTIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x00280000)
BOARD_RECOVERYIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x00500000)
BOARD_SYSTEMIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x04380000)
BOARD_USERDATAIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x04ac0000)
# The size of a block that can be marked bad.
BOARD_FLASH_BLOCK_SIZE := 131072

# Remove when we have camera support.
USE_CAMERA_STUB := false

# Our hardware is not OpenGLES-2 capable
BOARD_NO_GL2 := true
BOARD_GL_TEX_POW2_DIMENSION_REQUIRED := true
BOARD_HAS_LIMITED_EGL := true

# OpenGL drivers config file path
BOARD_EGL_CFG := device/xdandroid/msm/egl.cfg

-include vendor/xdandroid/msm/BoardConfigVendor.mk
