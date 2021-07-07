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
    
    func generateAllNoteCombinations(from pitchCollection: [PitchClass]) -> [[Note]] {
        guard !pitchCollection.isEmpty else { return [] }
        let allPossibleLetterAccidentalCombos: [[(letter: NoteLetter,
                                                  accidental: Accidental)]] =
            pitchCollection.map({ $0.possibleLetterAccidentalCombos })
        var noteCombos: [[Note]] = Array(repeating: [Note](),
                                                 count: allPossibleLetterAccidentalCombos
                                                    .map { $0.count }
                                                    .reduce(1, { $0 * $1 }))
        
        var currentWindowSize = noteCombos.count
        combosLoop: for combo in allPossibleLetterAccidentalCombos {
            let numRepetitions = noteCombos.count / currentWindowSize
            let currentDivisor = combo.count
            currentWindowSize /= currentDivisor

            // This process needs to be repeated numRepetitions times (e.g. for Ab major, 1x, 2x, then 6x)
            for counterIdx in 1...numRepetitions {
                print("repetition: \(String(counterIdx)) for combo: \(combo.first?.letter)\(combo.first?.accidental)")
                pairsLoop: for (pairIdx, pair) in combo.enumerated() {
                    let note = Note(noteLetter: pair.letter, accidental: pair.accidental)
                    let startingIndex = pairIdx * currentWindowSize * (counterIdx)
                    let indexRange = startingIndex...(startingIndex + currentWindowSize - 1)
                    // put note into noteSpellingCombos at indexRange subarrays, at position index in each subarray
                    indexRange.forEach { noteCombos[$0].append(note) }
                }
            }
        }
        
        
        // filter out any double flats or double sharps
//        if (pcVal == 1 || pcVal == 3 || pcVal == 6 || pcVal == 8 || pcVal == 10) && (note.accidental == .doubleFlat || note.accidental == .doubleSharp) {
//            continue combosLoop
//        }

        // filter out combos with duplicate note letters
//        guard chordSpelling.count == Set(chordSpelling).count else { continue }
//        noteCombos.append(chordSpelling)


        return noteCombos
    }
    
    func minNoteFifthsNotes(_ noteCollections: [[Note]]) -> [Note] {
        guard noteCollections.count > 1 else { return noteCollections.isEmpty ? [] : noteCollections[0] }
        
        var minFifths = Int.max
        var minFifthsNoteCollection: [Note] = []
        for noteCollection in noteCollections {
            let numFifths = noteCollection.map({ NoteFifthsContainer.noteFifthsLookup[$0] ?? 0 }).reduce(0, { abs($0 - $1) })
            if numFifths < minFifths {
                minFifths = numFifths
                minFifthsNoteCollection = noteCollection
            }
        }
        return minFifthsNoteCollection
    }
}


