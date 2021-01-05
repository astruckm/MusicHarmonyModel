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
        guard let bFlat1 = Note(pitchClass: .aSharp, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let gNatural1 = Note(pitchClass: .g, noteLetter: .g, octave: Octave(rawValue: 1)) else { return }
        guard let fSharp0 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 0)) else { return }
        guard let dNatural1 = Note(pitchClass: .d, noteLetter: .d, octave: Octave(rawValue: 1)) else { return }
        guard let fSharp1 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 1)) else { return }
        guard let bNatural1 = Note(pitchClass: .b, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let fNatural = Note(pitchClass: .f, noteLetter: .f, octave: nil) else { return }
        guard let aNatural0 = Note(pitchClass: .a, noteLetter: .a, octave: Octave(rawValue: 0)) else { return }
        
        guard let tonalChord1 = TonalChord(root: gNatural1, otherNotes: [dNatural1, bFlat1]) else { return }
        guard let tonalChord2 = TonalChord(root: bFlat1, otherNotes: [fSharp1, dNatural1, fSharp0]) else { return }
        guard let tonalChord3 = TonalChord(root: gNatural1, otherNotes: [fSharp0, dNatural1, bNatural1]) else { return }
        guard let tonalChord4 = TonalChord(root: bNatural1, otherNotes: [dNatural1, fNatural, aNatural0]) else { return }
        
        XCTAssert(tonalChord1.chordType == .minor && tonalChord1.extensions.isEmpty)
        XCTAssert(tonalChord2.chordType == .augmented && tonalChord2.extensions.isEmpty)
        XCTAssert(tonalChord3.chordType == .majorSeventh && tonalChord3.extensions == [.seven])
        XCTAssert(tonalChord4.chordType == .halfDiminishedSeventh && tonalChord4.extensions == [.seven])
    }

}
