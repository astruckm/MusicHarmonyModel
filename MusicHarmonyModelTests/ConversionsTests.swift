//
//  ConversionsTests.swift
//  MusicHarmonyModelTests
//
//  Created by Andrew Struck-Marcell on 1/2/21.
//

import XCTest
@testable import MusicHarmonyModel


//Test conversions between types
class TestConversions: XCTestCase {
    func testPitchIntervalClassBetweenNotes() {
        guard let note1 = Note(pitchClass: .aSharp, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let note2 = Note(pitchClass: .g, noteLetter: .g, octave: Octave(rawValue: 1)) else { return }
        guard let note3 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 0)) else { return }
        guard let note4 = Note(pitchClass: .dSharp, noteLetter: .e, octave: Octave(rawValue: 2)) else { return }
        
        XCTAssert(pitchIntervalClass(between: note1, and: note2) == .three)
        XCTAssert(pitchIntervalClass(between: note3, and: note4) == .nine)
        XCTAssert(pitchIntervalClass(between: note2, and: note3) == .one)
        XCTAssert(pitchIntervalClass(between: note3, and: note2) == .one)
    }
    
    func testIntervalDiatonicSizeBetweenNotes() {
        guard let note1 = Note(pitchClass: .aSharp, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let note2 = Note(pitchClass: .g, noteLetter: .g, octave: Octave(rawValue: 1)) else { return }
        guard let note3 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 0)) else { return }
        guard let note4 = Note(pitchClass: .f, noteLetter: .e, octave: Octave(rawValue: 2)) else { return }
        guard let note5 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 1)) else { return }
        
        XCTAssert(intervalDiatonicSize(between: note1, and: note2) == .third)
        XCTAssert(intervalDiatonicSize(between: note3, and: note4) == .second)
        XCTAssert(intervalDiatonicSize(between: note1, and: note4) == .fifth)
        XCTAssert(intervalDiatonicSize(between: note3, and: note2) == .second)
        XCTAssert(intervalDiatonicSize(between: note3, and: note5) == .octave)
        XCTAssert(intervalDiatonicSize(between: note1, and: note1) == .unison)
    }
    
    func testIntervalBetweenNotes() {
        guard let note1 = Note(pitchClass: .aSharp, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let note2 = Note(pitchClass: .g, noteLetter: .g, octave: Octave(rawValue: 1)) else { return }
        guard let note3 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 0)) else { return }
        guard let note4 = Note(pitchClass: .b, noteLetter: .c, octave: Octave(rawValue: 2)) else { return }
        
        guard let interval1 = interval(between: note1, and: note2) else { return }
        guard let interval2 = interval(between: note2, and: note3) else { return }
        guard let interval3 = interval(between: note3, and: note4) else { return }
        guard let interval4 = interval(between: note1, and: note3) else { return }
        guard let interval5 = interval(between: note3, and: note3) else { return }
                
        XCTAssert(interval1.pitchIntervalClass == .three && interval1.quality == .minor && interval1.size == .third)
        XCTAssert(interval2.pitchIntervalClass == .one && interval2.quality == .minor && interval2.size == .second)
        XCTAssert(interval3.pitchIntervalClass == .five)
        XCTAssert(interval4.pitchIntervalClass == .four && interval4.quality == .diminished && interval4.size == .fourth)
        XCTAssert(interval5.pitchIntervalClass == .zero && interval5.quality == .perfect && interval5.size == .unison)
    }

    
}
