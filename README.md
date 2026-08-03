# Adaptive study board

A dependency-free GitHub Pages app for the April–June 2026 UW–Parkside Flex subscription period.

The original page was a hand-authored schedule whose weekday labels were one day out of sync with the actual 2026 calendar. This version generates dates from structured assignment data and recalculates unfinished work whenever progress or the planning date changes.

## Features

- Assignment completion saved in browser `localStorage`
- Automatic reflow into the earliest available weekday study blocks
- One-block capacity on April 17 and no study on Memorial Day
- Earliest-start dates, assignment deadlines, and BABA/BALM same-day separation
- Deadline and capacity warnings
- Responsive, keyboard-accessible course and schedule views

## Run locally

Because the app uses JavaScript modules, serve the directory instead of opening `index.html` directly:

```sh
python3 -m http.server 8000
```

Then open `http://localhost:8000`.

Run the scheduling tests with:

```sh
node --test scheduler.test.mjs
```

## macOS desktop widget

The [`macOS`](macOS/) directory contains a native SwiftUI companion app and interactive WidgetKit extension. It uses the same assignment model and scheduling rules, with progress shared locally between the app and widget through an App Group.

See [`macOS/README.md`](macOS/README.md) for Xcode signing, installation, and desktop-widget setup.
