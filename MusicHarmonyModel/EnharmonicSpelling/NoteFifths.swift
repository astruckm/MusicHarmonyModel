//
//  NoteFifths.swift
//  MusicHarmonyModel
//
//  Created by Andrew Struck-Marcell on 1/13/21.
//

import Foundation

/// All possible spelled notes arranged in a "spiral of fifths" array where adjacent notes in the array are a perfect fifth apart
struct NoteFifthsContainer {
    /// All the possible note spellings
    static var noteFifths: [Note] = {
        var notes = [Note]()
        let noteLetters = NoteLetter.allCases
        let accidentals = Accidental.allCases
        let numLetters = noteLetters.count
        let numStepsInFifth = 4
        let numStepsFIsAboveC = 3 //Game the index so it starts on F--each accidental flip needs to occur over B to F (the only 5th letter name that is dimished, not perfect)

        for accidental in accidentals {
            for n in 0..<numLetters {
                let index = (numStepsInFifth * n + numStepsFIsAboveC) % numLetters
                let noteLetter = noteLetters[index]
                let note = Note(noteLetter: noteLetter, accidental: accidental)
                notes.append(note)
            }
        }
        return notes
    }()
    
    /// Get a noteFifths index from the Note
    static var noteFifthsLookup: [Note: Int] {
        var lookup = [Note: Int]()
        for (i, note) in noteFifths.enumerated() {
            lookup[note] = i
        }
        return lookup
    }
}

extension BestEnharmonicSpelling {
    /// Get the best enharmonic spelling of a PitchClass array using the fewest note fifths method. This method finds the Note spelling combination with the smallest total sum of fifths between all of the notes. The sum between each Note pair is the difference of each Note's index in a collection representing a "spiral of fifths" of all possible Note spellings.
    /// - Parameter pitchCollection: The pitch class collection to get best spelling
    /// - Returns: Collection of Notes with best note fifths enharmonic spelling
    func fewestNoteFifths(_ pitchCollection: [PitchClass]) -> [Note] {
        guard !pitchCollection.isEmpty else { return [] }
        guard pitchCollection.count > 1 else {
            let letterAccidental = pitchCollection[0].possibleLetterAccidentalCombos[0]
            let note = Note(noteLetter: letterAccidental.letter,
                            accidental: letterAccidental.accidental)
            return [note]
        }
        let sortedPCs = pitchCollection.sorted()
        let letterAccidentalCombos = generateAllNoteCombinations(from: pitchCollection)
        // NOTE: if 1 semitone above, don't evaluate possibleLetterAccidentalCombos that have less abstractTonalScaleDegree % NoteLetter.allCase.count
        // NOTE: if 2 semitones above, don't evaluate same letter name
        var possibleNotesGroups: [[Note]] = [] /// array of all the possible Note spelling combinations in the pitch collection
        for idx in sortedPCs.indices {
            let pivotPC = sortedPCs[idx]
            // get a pitch from sortedPCs
            for spelling in letterAccidentalCombos[pivotPC.rawValue] {
//                let note = Note(noteLetter: spelling.letter, accidental: spelling.accidental)
                // append to possibleNotesGroups
            }
            
            for variableIdx in (idx+1)...sortedPCs.indices.max()! {
                let pc = sortedPCs[variableIdx]
                for spelling in letterAccidentalCombos[pc.rawValue] {
//                    let note = Note(noteLetter: spelling.letter, accidental: spelling.accidental)
                    // append to possibleNotesGroups
                }
            }
        }
        
        return minNoteFifthsNotes(possibleNotesGroups)
    }
    
    /// Finds the group of Notes with the lowest Note Fifths value. The function is meant to evaluate an input noteCollection each Note group (the inner arrays), respectively, contains the same pitch classes.
    /// - Parameter noteCollections: A group of groups of Notes
    /// - Returns: The group with the minimum Note Fifths value. In the case of ties, it will output the first group.
    func minNoteFifthsNotes(_ noteCollections: [[Note]]) -> [Note] {
        guard noteCollections.count > 1 else { return noteCollections.isEmpty ? [] : noteCollections[0] }
        
        var minFifths = Int.max
        var minFifthsNoteCollection: [Note] = []
        for noteCollection in noteCollections {
            let indicesInLookup = noteCollection.map { NoteFifthsContainer.noteFifthsLookup[$0] ?? 0 }.sorted()
            var numFifths = 0
            for i in 0..<(indicesInLookup.count-1) {
                for j in (i+1)..<indicesInLookup.count {
                    numFifths += indicesInLookup[j] - indicesInLookup[i]
                }
            }
            print("noteCollection: \(noteCollection) with indicesInLookup: \(indicesInLookup)\nhas numFifths: \(numFifths)")
            if numFifths < minFifths {
                minFifths = numFifths
                minFifthsNoteCollection = noteCollection
            } else if numFifths == minFifths {
                let midNoteIdx = NoteFifthsContainer.noteFifths.count / 2
                let noteCollectionMeanIdx: Float = Float(indicesInLookup.reduce(0, { $0 + $1 })) / Float(indicesInLookup.count)
                let indicesInCurrentMin = minFifthsNoteCollection.map { NoteFifthsContainer.noteFifthsLookup[$0] ?? 0 }
                let currentMinMeanIdx: Float = Float(indicesInCurrentMin.reduce(0, { $0 + $1 })) / Float(indicesInCurrentMin.count)
                if (noteCollectionMeanIdx - Float(midNoteIdx)) < (currentMinMeanIdx - Float(midNoteIdx)) {
                    minFifths = numFifths
                    minFifthsNoteCollection = noteCollection
                }
            }
        }
        return minFifthsNoteCollection
    }
}


