# Store Continuity for Watch App Distribution

The primary distribution product is `HomeIndicator WatchKit App`. The iOS
container target is included in the build scheme so that Xcode Cloud can
produce a valid `app-store` export archive for TestFlight upload.

## Continuity Strategy

- Keep existing watch bundle identifiers unchanged:
  - `com.Shitamori.HomeIndicator.watchkitapp`
  - `com.Shitamori.HomeIndicator.watchkitapp.watchkitextension`
- Keep versioning on the existing watch app target (`MARKETING_VERSION` / `CURRENT_PROJECT_VERSION`).
- Build and upload using the watch app scheme (`HomeIndicator WatchKit App`).

## Why the iOS container is in the scheme

Xcode 26 does not accept the `app-store` export method for pure watchOS
archives (only `release-testing`, `enterprise`, `debugging` are valid).
Xcode Cloud generates an `app-store` export options plist for TestFlight,
and there is no custom script hook that runs between plist generation and
export execution. Including the iOS container makes the archive an iOS
archive, for which `app-store` is valid.

## Operational Check

- Build: `xcodebuild -project "HomeIndicator.xcodeproj" -scheme "HomeIndicator WatchKit App" -destination "generic/platform=watchOS" build`
- Upload path: Xcode Cloud (TestFlight)
