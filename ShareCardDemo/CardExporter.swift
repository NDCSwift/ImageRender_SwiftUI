//
    //  Project: ShareCardDemo
    //  File: CardExporter.swift
    //  Created by Noah Carpenter 
    //
    //  📺 YouTube: Noah Does Coding
    //  https://www.youtube.com/@NoahDoesCoding
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Dream Big. Code Bigger 🚀
    //
    

import SwiftUI

/// Turns a SwiftUI view into a PNG on disk that the system share sheet can hand off.
///
/// The pipeline is a straight line: **view → `UIImage` → `Data` → file → `ShareLink`.**
/// `CardExporter` owns the first three hops; `ContentView` does the last one.
///
/// It's a caseless `enum` used purely as a namespace — there's no state to hold,
/// just two `static` functions. Everything here is `@MainActor` because
/// `ImageRenderer` drives the same view machinery SwiftUI does and the compiler
/// requires it to run on the main actor.
enum CardExporter {

    /// Renders `card` off screen and encodes the result as PNG data.
    ///
    /// - Parameters:
    ///   - card: any view to rasterize (generic, so it isn't tied to `ScoreCard`).
    ///   - sourceWidth: the width the view is offered to lay out in (points).
    ///   - exportWidth: the width we want the finished bitmap to be (pixels).
    @MainActor
    static func pngData(from card: some View, sourceWidth: CGFloat = 320, exportWidth: CGFloat = 1080) -> Data? {
        let renderer = ImageRenderer(content: card)

        // The size offered to the view during layout. `height: nil` = "as tall
        // as you need". `ScoreCard` already fixes its own width, but setting this
        // means the render never depends on a guess for views that flex.
        renderer.proposedSize = ProposedViewSize(width: sourceWidth, height: nil)

        // `scale` is the point-to-pixel multiplier. Default is 1 → a blurry,
        // point-sized image. Here we compute it from the widths we want
        // (1080 / 320 = 3.375), so the export is the SAME pixel width on every
        // device — a shareable asset, not a screen-dependent screenshot.
        // (Use `@Environment(\.displayScale)` instead when you want it to match
        //  the current screen rather than a fixed size.)
        renderer.scale = exportWidth / sourceWidth

        // `false` keeps the pixels the rounded `clipShape` cut away transparent.
        // Set it `true` and those corners render solid BLACK. Only use `true` for
        // a full-bleed rectangle, where the smaller (no alpha) file is free.
        renderer.isOpaque = false

        // `uiImage` is where the work happens: lay out with no screen, draw into
        // an off-screen buffer, hand back a `UIImage?`. It's optional for real
        // reasons — nil if `scale` resolves to 0, or the view has no resolvable
        // size — so the caller must handle nil rather than assume a bitmap.
        return renderer.uiImage?.pngData()

    }

    /// Writes `pngData(from:)` to a temporary file and returns its URL, ready to
    /// pass straight to `ShareLink(item:)`.
    @MainActor
    static func pngFile(from card: some View, named name: String = "score-card") -> URL? {
        guard let data = pngData(from: card) else { return nil }

        // `temporaryDirectory` is the right home for this: a real file URL the
        // share sheet can read, and the system cleans it up for us — no clutter
        // in the documents folder.
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(name).png")
        do {
            // `.atomic` so a reader can never catch a half-written file.
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            return nil
        }
    }
}
