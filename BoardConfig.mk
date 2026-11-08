#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# ADVAN X1 board deltas only.
#
# Everything platform-generic is owned by
# device/transsion/mt6789-common/BoardConfigCommon.mk in the A16 common:
# architecture, bootloader identity, boot header v4 geometry
# (base/offsets/page size), partition filesystem types, recovery/vendor_boot
# layout (GKI-style platform ramdisk + empty RECOVERY fragment), MTK platform
# properties, crypto flags and TWRP tools.
# Anything this file adds overrides the common (this BoardConfig is read
# after the common's).

DEVICE_PATH := device/advan/ADVAN_X1

# Inherit from the A16 mt6789 common
include device/transsion/mt6789-common/BoardConfigCommon.mk

# The common's BoardConfigCommon lists $(DEVICE_PATH) before this file is
# read (undefined there), so define the pair explicitly, common first.
TARGET_RECOVERY_DEVICE_DIRS := \
    device/transsion/mt6789-common \
    $(DEVICE_PATH)

# Dynamic partitions (device sizing; the common leaves these open)
BOARD_SUPER_PARTITION_SIZE := 9663676416 # TODO: Fix hardcoded value
BOARD_MAIN_SIZE := 9659482112 # (BOARD_SUPER_PARTITION_SIZE - 4194304) 4MiB
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_PARTITION_LIST += \
    odm_dlkm \
    product \
    system \
    system_ext \
    vendor \
    vendor_dlkm

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
