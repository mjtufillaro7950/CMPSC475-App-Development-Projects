//
//  AllWords.swift
//  Lion Spell
//
//  Created by Alfares, Nader on 12/20/25.
//
import Foundation


struct Words: Codable {
    let englishWords: [String]
    
    enum CodingKeys: String, CodingKey {
        case englishWords
    }
    
    init() {
        guard
            let url = Bundle.main.url(forResource: "Words", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(Words.self, from: data)
        else {
            // Safe fallback (no crash)
            // This shouldn't happen
            self.englishWords = []
            return
        }
        
        self.englishWords = decoded.englishWords
    }
    
    static let allWords = Words()
    
}





