#!/bin/bash
set -euo pipefail

# Xcode 26 renamed the export method from "app-store" to "release-testing".
# Xcode Cloud may still generate the plist with the old method name.
# Patch it here so the subsequent exportArchive step succeeds.

log() {
  echo "[ci_post_xcodebuild] $*"
}

WORKSPACE_ROOT="${WORKSPACE_ROOT:-/Volumes/workspace}"
PLIST_BUDDY="/usr/libexec/PlistBuddy"

known_paths=(
  "${WORKSPACE_ROOT}/ci/app-store-exportoptions.plist"
  "${WORKSPACE_ROOT}/ci/release-testing-exportoptions.plist"
)

export_plists=()

contains_path() {
  local path="$1"
  local existing
  for existing in "${export_plists[@]:-}"; do
    if [[ "${existing}" == "${path}" ]]; then
      return 0
    fi
  done
  return 1
}

add_candidate() {
  local path="$1"
  if [[ -f "${path}" ]] && ! contains_path "${path}"; then
    export_plists+=("${path}")
  fi
}

log "Looking for export options plists under ${WORKSPACE_ROOT}"

for known_path in "${known_paths[@]}"; do
  if [[ -f "${known_path}" ]]; then
    add_candidate "${known_path}"
    log "Found known export plist: ${known_path}"
  fi
done

if [[ -d "${WORKSPACE_ROOT}" ]]; then
  while IFS= read -r -d '' plist_path; do
    add_candidate "${plist_path}"
  done < <(
    find "${WORKSPACE_ROOT}" -maxdepth 4 -type f -iname "*exportoptions*.plist" -print0 2>/dev/null || true
  )
else
  log "Workspace root not found: ${WORKSPACE_ROOT}"
fi

if [[ ! -x "${PLIST_BUDDY}" ]]; then
  log "PlistBuddy is unavailable at ${PLIST_BUDDY}; skipping patch."
  exit 0
fi

candidate_count="${#export_plists[@]}"
if [[ "${candidate_count}" -eq 0 ]]; then
  log "No export options plist found. Skipping patch."
  exit 0
fi

log "Found ${candidate_count} export plist candidate(s)"

patched_count=0
skipped_count=0
error_count=0

for export_plist in "${export_plists[@]}"; do
  current_method="$("${PLIST_BUDDY}" -c "Print :method" "${export_plist}" 2>/dev/null || true)"

  if [[ -z "${current_method}" ]]; then
    log "Skipping ${export_plist}: ':method' key is missing"
    skipped_count=$((skipped_count + 1))
    continue
  fi

  if [[ "${current_method}" == "app-store" ]]; then
    if "${PLIST_BUDDY}" -c "Set :method release-testing" "${export_plist}" >/dev/null 2>&1; then
      log "Patched ${export_plist}: app-store -> release-testing"
      patched_count=$((patched_count + 1))
    else
      log "Failed to patch ${export_plist}"
      error_count=$((error_count + 1))
    fi
  else
    log "No change for ${export_plist}: method is '${current_method}'"
    skipped_count=$((skipped_count + 1))
  fi
done

log "Done. patched=${patched_count}, skipped=${skipped_count}, errors=${error_count}"
exit 0
