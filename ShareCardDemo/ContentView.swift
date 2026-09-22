//
    //  Project: ShareCardDemo
    //  File: ContentView.swift
    //  Created by Noah Carpenter 
    //
    //  📺 YouTube: Noah Does Coding
    //  https://www.youtube.com/@NoahDoesCoding
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Dream Big. Code Bigger 🚀
    //
    

import SwiftUI

/// Shows the card on screen and wires the "make an image, then share it" flow.
///
/// Flow: tap **Create Image** → `exportCard()` renders the card to a temp PNG →
/// the button swaps to a **Share Card** `ShareLink`, which opens the iOS system
/// share sheet (Save to Photos, Messages, Mail, Files…) with no permission prompt.
struct ContentView: View {
    /// One description of the card, computed once, used both on screen and for the
    /// render — so what the user sees is exactly what gets exported.
    private var card: ScoreCard {
        ScoreCard(date: .now, headline: "New Personal Best", score: 48_250)
    }

    // The screen's pixel density (3.0 on a modern iPhone). Read from the
    // environment rather than `UIScreen` so it stays correct on iPad, external
    // displays and Mac Catalyst. Passed to the renderer so the output isn't 1x.
    @Environment(\.displayScale) private var displayScale
    // The screen's current light/dark setting. `ImageRenderer` builds the view
    // from a fresh environment where this defaults to `.light`, so we read it
    // here and inject it back into the view we render (see `exportCard`).
    @Environment(\.colorScheme) private var colorScheme

    @State private var renderFailed = false
    /// Non-nil once a render succeeds — its presence flips the button to a ShareLink.
    @State private var shareURL: URL?

    var body: some View {

        VStack(spacing: 32){
            card


            if let shareURL {
                // A file URL is already `Transferable`, so `ShareLink` needs
                // nothing else to open the system share sheet on this PNG.
                ShareLink(item: shareURL){
                    Label("Share Card", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.borderedProminent)
            }
            else {
                Button{
                    exportCard()
                } label: {
                    Label("Create Image", systemImage: "photo")
                }
                .buttonStyle(.borderedProminent)
            }


            // A nil render should be visible, not silently swallowed.
            if renderFailed {
                Text("Couldn't Create Image")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

        }


    }

    @MainActor
    private func exportCard(){
        // Hand the card back the environment value it would have inherited on
        // screen. Without this, a dark screen exports a light card. The same
        // move works for `\.locale`, `\.dynamicTypeSize`, a custom font, etc.
        let configured = card.environment(\.colorScheme, colorScheme)


        guard let url = CardExporter.pngFile(from: configured) else {
            renderFailed = true
            return
        }
        shareURL = url
        renderFailed = false

    }
}

#Preview {
    ContentView()
}
