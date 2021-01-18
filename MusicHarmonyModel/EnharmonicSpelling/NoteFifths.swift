//
//  NoteFifths.swift
//  MusicHarmonyModel
//
//  Created by Andrew Struck-Marcell on 1/13/21.
//

import Foundation

//All possible spelled notes arranged in a "spiral of fifths" array where adjacent notes in the array are a perfect fifth apart
struct NoteFifthsContainer {
    var noteFifths: [Note] = {
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

    var noteFifthsLookup: [Note: Int] {
        var lookup = [Note: Int]()
        for (i, note) in noteFifths.enumerated() {
            lookup[note] = i
        }
        return lookup
    }
}

extension BestEnharmonicSpellingDelegate {
    func fewestNoteFifths(_ pitchCollection: [PitchClass]) -> [Note] {
        //Probably use naive solution of going through each possible spelling and compare it to all other possible spellings using it, find min of note fifths
        
        return []
    }
}


