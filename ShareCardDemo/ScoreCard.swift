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
        .frame(width: 320, alignment: .leading)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.quaternary, lineWidth: 2))
    }
}

#Preview {
    ScoreCard(date: Date.now, headline: "Score card", score: 1000)
}
