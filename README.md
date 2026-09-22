# 🖼️ ImageRenderDemo_SwiftUI

Turn any SwiftUI view into a high-resolution PNG the user can save or share — off screen, at a size you choose, with `ImageRenderer` and `ShareLink`.

---

## 🤔 What this is

`ShareCardDemo` is a blank SwiftUI project that builds one feature end to end: a designed "score card" view is rendered off screen with `ImageRenderer`, encoded to PNG, written to a temporary file, and handed to the iOS system share sheet via `ShareLink`. It's the full path — not just `ImageRenderer(content:).uiImage` — including the parts that only break once real users touch it: blurry exports, `nil` images, light cards on a dark screen, and black rounded corners.

## ✅ Why you'd use it

- **`ImageRenderer`, done properly** — the off-screen render, `renderer.scale` for points-vs-pixels, `proposedSize` for a fixed export width on every device, and why the whole thing has to be `@MainActor`.
- **A reusable `CardExporter`** — a small, view-generic helper that does `view → UIImage → Data → file`, so the pattern drops straight into your own app (receipts, quote cards, workout summaries, share-your-score screens).
- **The reliability pass most tutorials skip** — handling the optional `uiImage`, `isOpaque` and the rounded-corner black-wedge bug, and re-injecting `@Environment(\.colorScheme)` so a dark screen exports a dark card.

## 📺 Watch on YouTube

[![Watch on YouTube](https://img.shields.io/badge/YouTube-Watch%20the%20Tutorial-red?style=for-the-badge&logo=youtube)](https://youtube.com/watch?v=PLACEHOLDER)

> This project was built for the [NoahDoesCoding YouTube channel](https://www.youtube.com/@NoahDoesCoding).

---

## 🚀 Getting Started

### 1. Clone

```bash
git clone https://github.com/NDCSwift/ImageRenderDemo_SwiftUI.git
cd ImageRenderDemo_SwiftUI
```

### 2. Open

```bash
open ShareCardDemo.xcodeproj
```

### 3. Team

Select the **ShareCardDemo** target → **Signing & Capabilities** → set your own **Team**. (Not needed if you only run on the simulator.)

### 4. Bundle ID

Change the **Bundle Identifier** to something unique to you, e.g. `com.yourname.ShareCardDemo`.

## 🛠️ Notes

- **Where the pieces live:** `ScoreCard.swift` is the view being exported (self-sized, no environment reads). `CardExporter.swift` is the render → PNG → file pipeline. `ContentView.swift` shows the card and wires the Create → Share flow.
- **`uiImage.size` is in points, not pixels.** The actual bitmap is `size × renderer.scale`. A 320-pt card at scale 3 is a 960-px image, and `.size` still reads 320 — this is why exports look like they "came out too small" when they didn't.
- **Off screen, the view starts from a fresh environment.** `colorScheme` defaults to `.light`, Dynamic Type to `.large`, `displayScale` to `1`. Re-supply anything the card needs with `.environment(...)` on the content you render.
- **`ShareLink` needs no permission strings.** It reaches Photos, Messages, Mail and Files with no `Info.plist` usage-description key — that's why it's the shipping default over `UIImageWriteToSavedPhotosAlbum`.
- **Simulator only.** No device, no packages, no network — `ImageRenderer` draws into memory and `ShareLink` hands a file to the system.

## 📦 Requirements

- Xcode 26 or later
- iOS 26 SDK (`ImageRenderer`, `ShareLink` and `ProposedViewSize` are iOS 16+, so earlier deployment targets work too)
- Swift 6 language mode, strict concurrency: complete

---

📺 [Watch the guide on YouTube](https://youtube.com/watch?v=PLACEHOLDER)
