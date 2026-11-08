# ADVAN X1 (_6781_) — A16 mt6789-common port
# Recovery device tree (TWRP, PBRP, OrangeFox, SHRP)

Ported from the self-contained A12-era tree onto the A16 Transsion common
(`device/transsion/mt6789-common`):

    ├─ this tree      : device/advan/ADVAN_X1        (branch a16-common)
    └─ a16 common     : device/transsion/mt6789-common
                        (github.com/ramabondanp/
                         twrp-device_transsion_mt6789-common)

## Device specifications

Device                  | ADVAN X1
-----------------------:|:-----------------------------------------
SoC                     | Mediatek Helio G99 (MT6789)
CPU                     | Octa-core (2x2.2 GHz Cortex-A76 & 6x2.0 GHz Cortex-A55)
GPU                     | Mali-G57 MC2
Memory                  | 8 GB RAM
Storage                 | 128 GB (UFS 2.2)
MicroSD                 | microSDXC (dedicated slot)
Battery                 | Non-removable 5000 mAh
Display                 | 1080 x 2460 pixels (~396 ppi density), 6.78 inches, 120hz

## What the port changed

The A16 common owns everything platform-generic; the device tree is now
delta-only:

- inherited (common): architecture, boot header v4 geometry, partition
  filesystem types, GKI-style vendor_boot (platform ramdisk + empty
  RECOVERY fragment, zstd), first-stage/recovery fstabs (erofs-first,
  system_dlkm, metadata first-stage), ueventd/cgroups/twrp.flags,
  `init.recovery.{mt6789,usb}.rc` (A16 service model), plpath utils, and
  the AIDL recovery runtime: prebuilt
  `android.hardware.boot-service.mtk_recovery`, AIDL health recovery HAL,
  Trustonic AIDL gatekeeper/keymint/tee-service binaries + lib64 ndk
  homes + vintf manifests, configfs-owned USB init.
- dropped (superseded): `bootctrl/` (HIDL
  `android.hardware.boot@1.2-mtkimpl` — collides with the common's AIDL
  boot HAL), mtk_plpath_utils, HIDL gatekeeper@1.0/keymint bins + lib64
  homes, boot@1.2/health@2.1 vendor vintf manifests.
- kept (device-unique): `init/` (libinit_ADVAN_X1), ADVAN X1 Trustonic
  TA set (`vendor/app/mcRegistry/*`) with `init.tee.rc` re-merged onto the
  A16 `twrp.storage.ready` trigger model, vibrator service binary +
  `init.vibrator.rc`, st21nfc firmware, MMC/UFS delta makefile bits,
  super-partition group sizing.

## Works

- [X] ADB / Fastboot / Fastbootd
- [X] MTP / Sideload / Flashing
- [X] Display / Vibrator (see TODO 3)
- [ ] Decryption (TODO 1/2)

## Build

```
lunch twrp_ADVAN_X1-eng && mka vendorbootimage
```

(SHRP, OrangeFox: `lunch twrp_ADVAN_X1-eng && mka adbd vendorbootimage`)

## CI

`.github/workflows/` carries the dispatch build pipelines ported from
the INOI A75 devtree (`sysretq0/Inoi_a75_devtree`): TeamWin-TWRP,
OrangeFox, PitchBlack. Each clones this tree (default branch
`a16-common`) plus the A16 common (`ramabondanp/
twrp-device_transsion_mt6789-common`), lunches `twrp_ADVAN_X1-eng`,
builds `vendorbootimage` and publishes the image to a run release.
Manifest defaults: twrp-14.1 / OFRP 14.1 / PBRP android-14.

## TODO

1. **Kernel 6.12 modules**: `recovery/root/lib/modules/*` still carries the
   stock 5.10 vendor_dlkm set (kept verbatim as provenance; the
   `modules.load` list = stock vendor_boot 162-entry list). Swap for the
   6.12 Kleaf ddK artifacts (`mt6789-k612-kernel` kmod lane) once the
   fullmods run is green; regenerate `modules.{load,dep,alias,softdep}`
   alongside. `TW_LOAD_VENDOR_BOOT_MODULES` stays.
2. **dtb**: `prebuilt/dtb.img` is the stock 5.10 dtb; re-point at the
   6.12 Kleaf dtb (dtbo_x builds).
3. **Vibrator auto-start**: the A16 common's `init.recovery.mt6789.rc`
   does not import `init.vibrator.rc`, so the service binary rides in the
   ramdisk without auto-start; TWRP haptics need a kick (either an
   `import` upstream in the common or a small device-side rc hook).
4. **Common gap**: the common's `BoardConfigCommon.mk` references
   `$(COMMON_PATH)/system.prop`, which the common tree does not ship
   (upstream defect — harmless to the device tree since this tree adds
   its own system.prop via `TARGET_SYSTEM_PROP`, but note that a missing
   TARGET_SYSTEM_PROP entry can fail strict builds; patch upstream if hit).
