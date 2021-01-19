//
//  NoteFifths.swift
//  MusicHarmonyModel
//
//  Created by Andrew Struck-Marcell on 1/13/21.
//

import Foundation

//All possible spelled notes arranged in a "spiral of fifths" array where adjacent notes in the array are a perfect fifth apart
struct NoteFifthsContainer {
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

    static var noteFifthsLookup: [Note: Int] {
        var lookup = [Note: Int]()
        for (i, note) in noteFifths.enumerated() {
            lookup[note] = i
        }
        return lookup
    }
}

extension BestEnharmonicSpellingDelegate {
    func fewestNoteFifths(_ pitchCollection: [PitchClass]) -> [Note] {
        guard !pitchCollection.isEmpty else { return [] }
        guard pitchCollection.count > 1 else {
            let letterAccidental = pitchCollection[0].possibleLetterAccidentalCombos[0]
            let note = Note(noteLetter: letterAccidental.letter,
                            accidental: letterAccidental.accidental)
            return [note]
        }
        let sortedPCs = pitchCollection.sorted()
        let letterAccidentalCombos = generateLetterAccidentalCombinations()
        // NOTE: if 1 semitone above, don't evaluate possibleLetterAccidentalCombos that have less abstractTonalScaleDegree % NoteLetter.allCase.count
        // NOTE: if 2 semitones above, don't evaluate same letter name
        for i in 0..<pitchCollection.count {
            for pc in sortedPCs {
                for spellings in letterAccidentalCombos {
                    
                }
            }
        }
        return []
    }
    
    // Filter out any black keys with double sharp/flats
    private func generateLetterAccidentalCombinations() -> [[(letter: NoteLetter,
                                                              accidental: Accidental)]] {
        let allPossibleLetterAccidentalCombos: [[(letter: NoteLetter,
                                                  accidental: Accidental)]] =
            PitchClass.allCases.map({ $0.possibleLetterAccidentalCombos })
        var letterAccidentalCombos: [[(letter: NoteLetter,
                                          accidental: Accidental)]] = []
        for (idx, combo) in allPossibleLetterAccidentalCombos.enumerated() {
            if idx == 1 || idx == 3 || idx == 6 || idx == 8 || idx == 10 {
                let newCombo = combo.filter {
                    $0.accidental == .doubleFlat || $0.accidental == .doubleSharp
                }
                letterAccidentalCombos.append(newCombo)
            } else {
                letterAccidentalCombos.append(combo)
            }
        }

        return letterAccidentalCombos
    }
    
    private func minNoteFifthsNotes(_ noteCollections: [[Note]]) -> [Note] {
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


