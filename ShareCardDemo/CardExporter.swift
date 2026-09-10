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

enum CardExporter {
    @MainActor
    static func pngData(from card: some View, sourceWidth: CGFloat = 320, exportWidth: CGFloat = 1080) -> Data? {
        let renderer = ImageRenderer(content: card)
        renderer.proposedSize = ProposedViewSize(width: sourceWidth, height: nil)
        renderer.scale = exportWidth / sourceWidth
        renderer.isOpaque = false
        return renderer.uiImage?.pngData()
        
    }
    
    @MainActor
    static func pngFile(from card: some View, named name: String = "score-card") -> URL? {
        guard let data = pngData(from: card) else { return nil }
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(name).png")
        do {
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            return nil
        }
    }
}
