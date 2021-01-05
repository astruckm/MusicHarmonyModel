//
//  NoteTests.swift
//  MusicHarmonyModelTests
//
//  Created by Andrew Struck-Marcell on 1/2/21.
//

import XCTest
@testable import MusicHarmonyModel

class NoteTests: XCTestCase {
    func testPitchClassSpellings() {
        let pcCSharp = PitchClass.cSharp
        let pcE = PitchClass.e
        let pcF = PitchClass.f
        let pcGSharp = PitchClass.gSharp
        let pcB = PitchClass.b
        
        XCTAssert(pcCSharp.possibleSpellings == ["C♯", "D♭", "B𝄪"])
        XCTAssert(pcE.possibleSpellings == ["E", "F♭", "D𝄪"])
        XCTAssert(pcF.possibleSpellings == ["F", "E♯", "G𝄫"])
        XCTAssert(pcGSharp.possibleSpellings == ["G♯", "A♭"])
        XCTAssert(pcB.possibleSpellings == ["B", "C♭", "A𝄪"])
    }
    
    func testNotesFromPCAndLetter() {
        let a4 = Note(pitchClass: .a, noteLetter: .a, octave: .four)
        let bSharp8 = Note(pitchClass: .c, noteLetter: .b, octave: .eight)
        let impossibleNote = Note(pitchClass: .f, noteLetter: .c, octave: nil)
        
        XCTAssert((a4?.pitchClass == .a && a4?.noteLetter == .a && a4?.accidental == .natural && a4?.octave == .four), "Did not initialize A4 correctly")
        XCTAssert((bSharp8?.pitchClass == .c && bSharp8?.noteLetter == .b && bSharp8?.accidental == .sharp && bSharp8?.octave == .eight), "Did not initialize Bsharp8 correctly")
        XCTAssert(impossibleNote == nil, "Note improperly initialized with PC 5, note letter C")
    }
    
    func testNotesFromSpelling() {
        let a4 = Note(noteLetter: .a, accidental: .natural, octave: .four)
        let bSharp8 = Note(noteLetter: .b, accidental: .sharp, octave: .eight)
        let fDoubleFlat = Note(noteLetter: .f, accidental: .doubleFlat, octave: nil)
        
        XCTAssert((a4.pitchClass == .a && a4.noteLetter == .a && a4.accidental == .natural && a4.octave == .four), "Did not initialize A4 correctly")
        XCTAssert((bSharp8.pitchClass == .c && bSharp8.noteLetter == .b && bSharp8.accidental == .sharp && bSharp8.octave == .eight), "Did not initialize Bsharp8 correctly")
        XCTAssert((fDoubleFlat.pitchClass == .dSharp && fDoubleFlat.noteLetter == .f && fDoubleFlat.accidental == .doubleFlat && fDoubleFlat.octave == nil), "fDoubleFlat initialized with wrong values")
    }



}
