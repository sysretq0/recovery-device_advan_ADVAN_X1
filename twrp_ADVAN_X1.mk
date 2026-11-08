#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from the A16 mt6789 common
$(call inherit-product, device/transsion/mt6789-common/common.mk)

# Inherit from ADVAN X1 device
$(call inherit-product, device/advan/ADVAN_X1/device.mk)

# Product Specifics
PRODUCT_NAME := twrp_ADVAN_X1
PRODUCT_DEVICE := ADVAN_X1
PRODUCT_BRAND := ADVAN
PRODUCT_MODEL := 6781
PRODUCT_MANUFACTURER := ADVAN

PRODUCT_GMS_CLIENTID_BASE := android-advan
