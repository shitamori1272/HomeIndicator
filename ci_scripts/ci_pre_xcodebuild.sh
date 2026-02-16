#!/bin/bash
set -euo pipefail

echo "[ci_pre_xcodebuild] Preparing watchOS Simulator for test stability"

if ! command -v xcrun >/dev/null 2>&1; then
  echo "[ci_pre_xcodebuild] xcrun is not available. Skipping."
  exit 0
fi

# Reset CoreSimulator service state to reduce launchd_sim boot flakiness.
killall -9 com.apple.CoreSimulator.CoreSimulatorService >/dev/null 2>&1 || true
xcrun simctl shutdown all >/dev/null 2>&1 || true

watch_udid="$(
  xcrun simctl list devices available \
    | grep "Apple Watch" \
    | sed -nE 's/.*\(([0-9A-F-]{36})\).*/\1/p' \
    | head -n 1
)"

if [[ -z "${watch_udid}" ]]; then
  echo "[ci_pre_xcodebuild] No available Apple Watch simulator found. Skipping pre-boot."
  exit 0
fi

echo "[ci_pre_xcodebuild] Selected watch simulator: ${watch_udid}"

attempt=1
max_attempts=3
while [[ "${attempt}" -le "${max_attempts}" ]]; do
  echo "[ci_pre_xcodebuild] Boot attempt ${attempt}/${max_attempts}"

  if xcrun simctl bootstatus "${watch_udid}" -b; then
    echo "[ci_pre_xcodebuild] Simulator booted successfully."
    exit 0
  fi

  echo "[ci_pre_xcodebuild] Boot failed, resetting simulator and retrying."
  xcrun simctl shutdown "${watch_udid}" >/dev/null 2>&1 || true
  xcrun simctl erase "${watch_udid}" >/dev/null 2>&1 || true
  attempt=$((attempt + 1))
done

echo "[ci_pre_xcodebuild] Failed to pre-boot simulator after retries. Continuing to xcodebuild."
exit 0
