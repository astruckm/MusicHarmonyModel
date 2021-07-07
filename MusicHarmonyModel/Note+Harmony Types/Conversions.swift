//
//  Conversions.swift
//  HarmonyCalc
//
//  Created by ASM on 1/16/19.
//  Copyright © 2019 ASM. All rights reserved.
//

import Foundation

/*
 //This should take a parameter for interval above or below
func note(fromNote note1: Note, andIntervalAbove interval: Interval) -> Note {
    let note1KeyValue = keyValue(pitch: (note1.pitchClass, note1.octave ?? .zero))
    let note2KeyValue = note1KeyValue + interval.pitchIntervalClass.rawValue
    let note2PC = putInRange(keyValue: note2KeyValue)
    
    var octave2: Octave? = nil
    if let octave1 = note1.octave {
        let octave2Value = octave1.rawValue + (note2KeyValue/PitchClass.allCases.count - note1KeyValue/PitchClass.allCases.count)
        octave2 = Octave(rawValue: octave2Value)
    }
    
    let possibleLetterNames = note2PC.possibleLetterNames
    
    return Note(pitchClass: note2PC, noteLetter: <#T##NoteLetter#>, octave: octave2)!
}*/

func pitchIntervalClass(between note1: Note, and note2: Note) -> PitchIntervalClass {
    //when you don't know the octave, assume they're in the same octave
    let semitonesDiff = intervalNumberBetweenKeys(keyOne: (note1.pitchClass, note1.octave ?? (note2.octave ?? .zero)), keyTwo: (note2.pitchClass, note2.octave ?? (note1.octave ?? .zero)))
    if let pIClass = PitchIntervalClass(rawValue: semitonesDiff) {
        return pIClass
    }
    print("Error deriving pitch interval class from notes!")
    return .zero
}

func intervalDiatonicSize(between note1: Note, and note2: Note) -> IntervalDiatonicSize {
    let higherNote = note1 >= note2 ? note1 : note2
    let lowerNote = higherNote == note1 ? note2 : note1
    let stepsAway = (higherNote.noteLetter.abstractTonalScaleDegree + NoteLetter.allCases.count - lowerNote.noteLetter.abstractTonalScaleDegree) % NoteLetter.allCases.count
    if stepsAway == 0 {
        return note1.octave == note2.octave ? IntervalDiatonicSize.unison : IntervalDiatonicSize.octave
    }
    if let size = IntervalDiatonicSize.allCases.first(where: { $0.numSteps == stepsAway }) {
        return size
    }
    print("Error deriving interval's within-octave diatonic size")
    return IntervalDiatonicSize.unison
}

func interval(between note1: Note, and note2: Note) -> Interval? {
    let intervalClass = pitchIntervalClass(between: note1, and: note2)
    let diatonicSize = intervalDiatonicSize(between: note1, and: note2)
    if let interval = Interval(intervalClass: intervalClass, size: diatonicSize) {
        return interval
    }
    print("Unable to synthesize an interval between notes. Re-spelling the notes with BestEnharmonicSpellingDelegate and trying again.")
    
    var bestSpellingDelegate: BestEnharmonicSpelling? = nil
    bestSpellingDelegate = BestEnharmonicSpeller()
    guard let notes = bestSpellingDelegate?.allSharpsOrAllFlats(of: [note1.pitchClass, note2.pitchClass]) else { return nil }
    let newIntervalClass = pitchIntervalClass(between: notes[0], and: notes[1])
    let newDiatonicSize = intervalDiatonicSize(between: notes[0], and: notes[1])
    if let interval = Interval(intervalClass: newIntervalClass, size: newDiatonicSize) {
        return interval
    }
    print("Unable to synthesize an interval between notes after re-spelling.")
    return nil
}

