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

struct ContentView: View {
    private var card: ScoreCard {
        ScoreCard(date: .now, headline: "New Personal Best", score: 48_250)
    }
    
    @Environment(\.displayScale) private var displayScale
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var renderFailed = false
    @State private var shareURL: URL?
    
    var body: some View {

        VStack(spacing: 32){
            card
            
            
            if let shareURL {
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
                
                
            if renderFailed {
                Text("Couldn't Create Image")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
            
        }
        
        
    }
    
    @MainActor
    private func exportCard(){
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
