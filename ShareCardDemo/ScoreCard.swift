//
    //  Project: ShareCardDemo
    //  File: ScoreCard.swift
    //  Created by Noah Carpenter 
    //
    //  📺 YouTube: Noah Does Coding
    //  https://www.youtube.com/@NoahDoesCoding
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Dream Big. Code Bigger 🚀
    //
    

import SwiftUI

/// The view we want to turn into a shareable image.
///
/// `ImageRenderer` lays this view out with **nothing around it** — no window, no
/// parent, no screen. So the card has to be completely self-describing:
///
/// - It takes plain values (`date`, `headline`, `score`) instead of reading
///   `@State` or `@Environment`, so it renders identically wherever it is used.
/// - It pins its own width with `.frame(width: 320)`. On screen a parent decides
///   how wide a view is; off screen there is no parent, so without an explicit
///   width `ImageRenderer` has nothing to lay out against and you get a tiny
///   ~10 pt smudge (or a `nil` image).
/// - It draws its own opaque `.background` and clips its own corners, so the
///   exported PNG looks like a finished card and not a floating label.
struct ScoreCard: View {
    let date: Date
    let headline: String
    let score: Int

    var body: some View {

        VStack(alignment: .leading, spacing: 16){
            Text(date, format: .dateTime.weekday(.wide).month().day())
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(headline)
                .font(.headline)
            
            Text("\(score.formatted()) points")
                .font(.title3)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack{
                Image(systemName: "gamecontroller.fill")
                Text("Pixel Dash")
            }
            .font(.caption2)
            .foregroundStyle(.purple)
        }
        .padding(24)
        // The line that lets the card leave the screen: a fixed layout width.
        .frame(width: 320, alignment: .leading)
        // Opaque fill so the card isn't see-through where it isn't clipped.
        .background(.background)
        // Rounded corners are clipped away here — see `isOpaque` in CardExporter
        // for why that matters when the view is rasterized.
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.quaternary, lineWidth: 2))
    }
}

#Preview {
    ScoreCard(date: Date.now, headline: "Score card", score: 1000)
}
