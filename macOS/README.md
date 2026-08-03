# Adaptive Study Board for macOS

This directory contains a native SwiftUI companion app and an interactive WidgetKit extension for macOS 14 or later.

## What is included

- `AdaptiveStudyBoard.xcodeproj` — app and embedded widget-extension targets
- `MacApp/` — the full native study board
- `Widget/` — small and medium interactive desktop widgets
- `Shared/` — assignment catalog, scheduler, and app-group progress store shared by both targets
- `Package.swift` and `Tests/CoreChecks.swift` — command-line verification for the shared core

The widget displays the next one or two scheduled blocks. Its completion button writes to the shared app-group store, recalculates the remaining schedule, and reloads every widget timeline. Clicking the widget opens the companion app.

## Install

1. Install the current full version of Xcode from Apple and open it once so it can finish installing components.
2. Open `AdaptiveStudyBoard.xcodeproj`.
3. Select the **AdaptiveStudyBoard** project, then select each target:
   - `AdaptiveStudyBoard`
   - `AdaptiveStudyWidget`
4. Under **Signing & Capabilities**, choose the same Apple development team for both targets. Leave **Automatically manage signing** enabled.
5. Confirm that both targets list this App Group:

   ```text
   group.io.github.27manryan.AdaptiveStudyBoard
   ```

   If Xcode shows the group in red, remove and re-add the App Groups capability on both targets, create that identifier when prompted, and select it for both.
6. Choose the **AdaptiveStudyBoard** scheme and **My Mac**, then press Run once.
7. For a durable installation, choose **Product → Show Build Folder in Finder** and copy `AdaptiveStudyBoard.app` from the products folder into `/Applications`.
8. Control-click the desktop, choose **Edit Widgets**, search for **Adaptive Study Board**, and drag the small or medium widget onto the desktop.

## Verify the shared engine without Xcode

The command-line Swift toolchain can compile and exercise the calendar, completion reflow, deadline, conflict, exclusion, and persistence behavior:

```sh
swift run --package-path macOS CoreChecks
```

## Data and privacy

Progress remains local in the app-group preferences container. The app and widget make no network requests and do not require an account. The GitHub Pages version still uses browser-local storage; it does not automatically share progress with the native app.
