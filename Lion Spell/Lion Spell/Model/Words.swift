//
//  AllWords.swift
//  Lion Spell
//
//  Created by Alfares, Nader on 12/20/25.
//
import Foundation


//updated this to work with all 4 possible languages
struct Words: Codable {
    let englishWords: [String]
    let frenchWords: [String]
    let germanWords: [String]
    let italianWords: [String]
    
    enum CodingKeys: String, CodingKey {
        case englishWords
        case frenchWords
        case germanWords
        case italianWords
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
            self.frenchWords = []
            self.germanWords = []
            self.italianWords = []
            return
        }
        
        self.englishWords = decoded.englishWords
        self.frenchWords = decoded.frenchWords
        self.germanWords = decoded.germanWords
        self.italianWords = decoded.italianWords
        
    }
    
    static let allWords = Words()
    
}





