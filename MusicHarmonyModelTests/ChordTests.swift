//
//  ChordTests.swift
//  MusicHarmonyModelTests
//
//  Created by Andrew Struck-Marcell on 1/2/21.
//

import XCTest
@testable import MusicHarmonyModel

class ChordTests: XCTestCase {
    func testChordFromNotes() {
        guard let note1 = Note(pitchClass: .aSharp, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let note2 = Note(pitchClass: .g, noteLetter: .g, octave: Octave(rawValue: 1)) else { return }
        guard let note3 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 0)) else { return }
        guard let note4 = Note(pitchClass: .d, noteLetter: .d, octave: Octave(rawValue: 1)) else { return }
        guard let note5 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 1)) else { return }
        guard let note6 = Note(pitchClass: .b, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let note7 = Note(pitchClass: .f, noteLetter: .f, octave: nil) else { return }
        guard let note8 = Note(pitchClass: .a, noteLetter: .a, octave: Octave(rawValue: 0)) else { return }
        
        guard let tonalChord1 = TonalChord(root: note2, otherNotes: [note4, note1]) else { return }
        guard let tonalChord2 = TonalChord(root: note1, otherNotes: [note5, note4, note3]) else { return }
        guard let tonalChord3 = TonalChord(root: note2, otherNotes: [note3, note4, note6]) else { return }
        guard let tonalChord4 = TonalChord(root: note6, otherNotes: [note4, note7, note8]) else { return }
        
        XCTAssert(tonalChord1.chordType == .minor && tonalChord1.extensions.isEmpty)
        XCTAssert(tonalChord2.chordType == .augmented && tonalChord2.extensions.isEmpty)
        XCTAssert(tonalChord3.chordType == .majorSeventh && tonalChord3.extensions == [.seven])
        XCTAssert(tonalChord4.chordType == .halfDiminishedSeventh && tonalChord4.extensions == [.seven])
    }

}
