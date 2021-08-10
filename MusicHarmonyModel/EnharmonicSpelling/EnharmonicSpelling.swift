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
    /// Gives all possible notes in a pitch collection arranged by pitch class
    /// - Parameter pitchCollection: input pitch collection
    /// - Returns: An array of arrays where the outer array consists of the Pitch Classes, and each inner array contains the possible Notes for its pitch class
    func allPossibleNotes(of pitchCollection: [PitchClass]) -> [[Note]] {
        guard !pitchCollection.isEmpty else { return [] }
        let allPossibleLetterAccidentalCombos: [[(letter: NoteLetter, accidental: Accidental)]] =
            pitchCollection.map({ $0.possibleLetterAccidentalCombos })
        let allPossibleNotes = allPossibleLetterAccidentalCombos.map { combo in
            combo.map { spelling in
                Note(noteLetter: spelling.letter, accidental: spelling.accidental)
            }
        }
        return allPossibleNotes
    }
    
    func numOfNoteSpellingCombinations(of pitchCollection: [PitchClass]) -> Int {
        let possibleNotes = allPossibleNotes(of: pitchCollection)
        return possibleNotes
            .map { $0.count }
            .reduce(1, { $0 * $1} )
    }
    
    /// Give all possible chord spellings for a given pitch collection
    /// - Parameter pitchCollection: input pitch collection
    /// - Returns: An array of arrays where the outer array consists of all possible combinations of groups of notes ("chords"), and each inner array contains the Notes of the group
    func generateAllNoteCombinations(from pitchCollection: [PitchClass]) -> [[Note]] {
        guard !pitchCollection.isEmpty else { return [] }
        guard pitchCollection.count > 1 else { return pitchCollection.first?.possibleLetterAccidentalCombos.map { [Note(noteLetter: $0.letter, accidental: $0.accidental) ] } ?? [] }
        let possibleNotes = allPossibleNotes(of: pitchCollection)
        let numNoteSpellingCombos = possibleNotes.map { $0.count }.reduce(1, { $0 * $1} )
        
        var noteCombos: [[Note]] = Array(repeating: [Note](), count: numNoteSpellingCombos)
        var currentWindowSize = numNoteSpellingCombos
        
        //loop through Notes within loop of num repetitions within loop of 2nd through last pc arrays
            //while doing this, keep track of index into which to append Note
        for pcNoteGroup in possibleNotes {
            let numRepetitions = numNoteSpellingCombos / currentWindowSize
            let noteWindowSize = currentWindowSize / pcNoteGroup.count
            for repetitionCounter in 0..<numRepetitions {
                for (pcNoteGroupIdx, note) in pcNoteGroup.enumerated() {
                    let firstIndex = (currentWindowSize * repetitionCounter) + (noteWindowSize * pcNoteGroupIdx)
                    let lastIndex = firstIndex + noteWindowSize - 1
                    for idx in firstIndex...lastIndex {
                        noteCombos[idx].append(note)
                    }
                }
            }
            currentWindowSize /= pcNoteGroup.count
        }
        
        return noteCombos
    }
    
}

struct EnharmonicSpeller: EnharmonicSpelling { } // For testing

public protocol BestEnharmonicSpelling {
    func allSharpsOrAllFlats(of pitchCollection: [PitchClass]) -> [Note]
    func fewestNoteFifths(_ pitchCollection: [PitchClass]) -> [Note]
    //TODO: other implementations: try using number of fifths apart, user input whether ascending or descending context, specify a scale, special cases like harp, etc
}


struct BestEnharmonicSpeller: BestEnharmonicSpelling { } // For testing
