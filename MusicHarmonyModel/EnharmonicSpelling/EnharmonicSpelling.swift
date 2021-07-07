//
//  EnharmonicSpelling.swift
//  Chord Calculator
//
//  Created by ASM on 4/24/18.
//  Copyright © 2018 ASM. All rights reserved.
//


import Foundation

protocol EnharmonicSpelling {
    func generateAllNoteCombinations(from pitchCollection: [PitchClass]) -> [[Note]]
}

extension EnharmonicSpelling {
    func numPossibleSpellingCombinations(in pitchCollection: [PitchClass]) -> Int {
        guard !pitchCollection.isEmpty else { return 0 }
        let allPossibleLetterAccidentalCombos: [[(letter: NoteLetter, accidental: Accidental)]] =
            pitchCollection.map({ $0.possibleLetterAccidentalCombos })
        return allPossibleLetterAccidentalCombos.map { $0.count }
                                                .reduce(1, { $0 * $1 })
    }
    
    func generateAllNoteCombinations(from pitchCollection: [PitchClass]) -> [[Note]] { return [] }
}

struct EnharmonicSpeller: EnharmonicSpelling { }

public protocol BestEnharmonicSpelling {
    func allSharpsOrAllFlats(of pitchCollection: [PitchClass]) -> [Note]
    func fewestNoteFifths(_ pitchCollection: [PitchClass]) -> [Note]
    //TODO: other implementations: try using number of fifths apart, user input whether ascending or descending context, specify a scale, special cases like harp, etc
}


struct BestEnharmonicSpeller: BestEnharmonicSpelling { } // For testing
