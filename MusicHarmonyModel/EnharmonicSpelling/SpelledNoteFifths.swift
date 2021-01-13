//
//  SpelledNoteFifths.swift
//  MusicHarmonyModel
//
//  Created by Andrew Struck-Marcell on 1/13/21.
//

import Foundation

var noteFifths: [Note] = {
    var notes = [Note]()
    let noteLetters = NoteLetter.allCases
    let numLetters = noteLetters.count
    let numStepsInFifth = 4

    for accidental in Accidental.allCases {
        for n in 1...numLetters {
            let index = (numStepsInFifth * n) % numLetters
            let noteLetter = noteLetters[index]
            let note = Note(noteLetter: noteLetter, accidental: accidental)
            notes.append(note)
        }
    }
    return notes
}()


