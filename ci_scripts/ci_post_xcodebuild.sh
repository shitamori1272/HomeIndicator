#!/bin/bash
set -euo pipefail

# Xcode 26 renamed the export method from "app-store" to "release-testing".
# Xcode Cloud may still generate the plist with the old method name.
# Patch it here so the subsequent exportArchive step succeeds.

EXPORT_PLIST="/Volumes/workspace/ci/app-store-exportoptions.plist"

if [[ -f "${EXPORT_PLIST}" ]]; then
  echo "[ci_post_xcodebuild] Patching export options plist for Xcode 26 compatibility"
  current_method=$(/usr/libexec/PlistBuddy -c "Print :method" "${EXPORT_PLIST}" 2>/dev/null || true)
  if [[ "${current_method}" == "app-store" ]]; then
    /usr/libexec/PlistBuddy -c "Set :method release-testing" "${EXPORT_PLIST}"
    echo "[ci_post_xcodebuild] Changed method from 'app-store' to 'release-testing'"
  else
    echo "[ci_post_xcodebuild] method is '${current_method}', no patch needed"
  fi
else
  echo "[ci_post_xcodebuild] Export plist not found at ${EXPORT_PLIST}, skipping"
fi
