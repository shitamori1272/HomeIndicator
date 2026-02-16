# AGENTS.md

This file explains how coding agents should work in this repository.

## Project Summary

- App type: Apple Watch app (`WatchKit App` + `WatchKit Extension`)
- Main UI technology: `SwiftUI`
- Persistence: `UserDefaults` (JSON-encoded `SpotData` list + selected index)
- CI/CD: `fastlane` + GitHub Actions (`.github/workflows/upload_testflight.yml`)

## Repository Layout

- `HomeIndicator WatchKit Extension/SwiftUI`
  - SwiftUI Views (`ContentView`, `SpotListView`, `SpotRegisterView`, `IndicatorView`)
- `HomeIndicator WatchKit Extension/ViewModel`
  - Presentation logic (`ContentViewModel`, `SpotListViewModel`, `SpotRegisiterViewModel`)
- `HomeIndicator WatchKit Extension/Domain`
  - `Entity`: domain model (`SpotData`)
  - `Repository`: protocols + index repository impl
  - `Usecase`: domain use cases
- `HomeIndicator WatchKit Extension/Infra`
  - infrastructure repository implementation (`SpotRepositoryImpl`)
- `fastlane`
  - release lanes (`beta`, `beta_ci`)

## Build and Verification

Use these commands from repository root.

1. Install Ruby dependencies (if needed):
   - `bundle install`
2. Build watchOS app:
   - `xcodebuild -project "HomeIndicator.xcodeproj" -scheme "HomeIndicator WatchKit App" -destination "generic/platform=watchOS" build`
3. Fastlane lanes (release operations):
   - `bundle exec fastlane ios beta`
   - `bundle exec fastlane ios beta_ci`

Note:
- This project currently has no dedicated test target. If you add tests, include clear run instructions in PR.

## Coding Conventions for This Repo

- Keep existing architecture boundaries:
  - View-only logic in `SwiftUI` views.
  - State and orchestration in ViewModels.
  - Data access behind repository protocols when possible.
- Prefer small, localized changes over broad refactors.
- Keep existing naming unless explicitly fixing across all references.
  - There are historical typos such as `SpotRegisiter*` and `SpoitDataStore.swift`.
- Avoid changing persistence keys unless migration is handled:
  - spot list key in `SpotRepositoryImpl`
  - selected index key in `IndexRepositoryImpl`

## PR Expectations

Before opening a PR:

1. Ensure the app builds with the main scheme.
2. Keep commits scoped to one purpose.
3. In PR description, include:
   - What changed
   - Why it changed
   - How it was verified (exact command)
   - Any manual verification steps (if applicable)

## Out of Scope by Default

- Do not rotate certificates/profiles or change `fastlane match` behavior unless explicitly requested.
- Do not rename schemes/targets or rewrite CI workflow unless the task specifically requires it.
