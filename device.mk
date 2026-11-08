#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# ADVAN X1 product deltas only.
#
# The shared family skeleton (core/base/emulated storage, Virtual A/B,
# AB OTA, fastbootd, AIDL health recovery HAL, keymaster/keystore, MTK
# plpath utils, update engine, security patch placeholders) is owned by
# device/transsion/mt6789-common/common.mk, inherited from twrp_ADVAN_X1.mk.
#
# Dropped with the A16-common port (superseded by the common tree):
#  - bootctrl/ + android.hardware.boot@1.2-mtkimpl(.recovery) - HIDL boot
#    HAL; the common ships the prebuilt AIDL
#    android.hardware.boot-service.mtk_recovery (+ its rc and vintf
#    manifest)
#  - HIDL android.hardware.gatekeeper@1.0-service, keymint-service.trustonic
#    binaries and their vendor/lib64 hw homes; the common runs the AIDL
#    gatekeeper/keymint Trustonic services
#  - device copies of the first-stage fstab, recovery.fstab, twrp.flags,
#    ueventd rc files, init.recovery.{mt6789,usb}.rc and the system-side
#    vintf manifests - the common's A16 variants win by path
#
# Kept (device-unique):
#  - init/ (libinit_ADVAN_X1 vendor_init identity)
#  - recovery/root/init.tee.rc  (ADVAN X1 Trustonic TA load list, wired to
#    the A16 twrp.storage.ready trigger model)
#  - recovery/root/init.vibrator.rc + vibrator-service.mediatek binary
#    (haptics HAL for the A12-era vendor; TODO: vibrator auto-start under
#    the A16 common rc that does not import init.vibrator.rc)
#  - recovery/root/vendor/app/mcRegistry/*  (ADVAN X1 TA set, including
#    widevine/DRM/sensor/isp TAs the common set lacks)
#  - recovery/root/vendor/firmware/st21nfc_fw7.bin and
#  - recovery/root/lib/modules/* (stock 5.10 vendor_dlkm set; TODO: swap
#    for the 6.12 Kleaf ddK artifacts + regenerable modules.load)
#  - prebuilt/dtb.img (stock 5.10; TODO: re-point at the 6.12 Kleaf dtb)

# Device init library (product identity in vendor_init)
TARGET_INIT_VENDOR_LIB := libinit_ADVAN_X1
TARGET_RECOVERY_DEVICE_MODULES := libinit_ADVAN_X1

# Haptics
TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_FQNAME := "IVibrator/default"

# Screen/UI (1080 x 2460 120 Hz panel)
TW_THEME := portrait_hdpi
TW_MAX_BRIGHTNESS := 255
TW_DEVICE_VERSION := ADVAN X1 a16-common
TW_CUSTOM_CPU_TEMP_PATH := /sys/devices/virtual/thermal/thermal_zone31/temp

# StatusBar
TW_STATUS_ICONS_ALIGN := center
TW_CUSTOM_CPU_POS := "300"
TW_CUSTOM_CLOCK_POS := "70"
TW_CUSTOM_BATTERY_POS := "790"

# The stock vendor_dlkm set rides in vendor_boot; recovery loads it
TW_LOAD_VENDOR_BOOT_MODULES := true

# Assert
TARGET_OTA_ASSERT_DEVICE := ADVAN_X1
