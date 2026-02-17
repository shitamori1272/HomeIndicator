# Store Continuity for Standalone Watch App

This project now treats `HomeIndicator WatchKit App` as the primary archive and distribution product.

## Continuity Strategy

- Keep existing watch bundle identifiers unchanged:
  - `com.Shitamori.HomeIndicator.watchkitapp`
  - `com.Shitamori.HomeIndicator.watchkitapp.watchkitextension`
- Keep versioning on the existing watch app target (`MARKETING_VERSION` / `CURRENT_PROJECT_VERSION`).
- Build and upload using the watch app scheme (`HomeIndicator WatchKit App`) only.

## Applied Changes

- Removed the iOS container target from the shared watch app scheme build action.
- Aligned fastlane signing identifiers to watch-only bundle IDs.

## Operational Check

- Build: `xcodebuild -project "HomeIndicator.xcodeproj" -scheme "HomeIndicator WatchKit App" -destination "generic/platform=watchOS" build`
- Upload path: `bundle exec fastlane ios beta_ci`
