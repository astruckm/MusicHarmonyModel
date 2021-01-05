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
    let bFlat1 = Note(noteLetter: .b, accidental: .flat, octave: Octave(rawValue: 1))
    let gNatural1 = Note(noteLetter: .g, accidental: .natural, octave: Octave(rawValue: 1))
    let fSharp0 = Note(noteLetter: .f, accidental: .sharp, octave: Octave(rawValue: 0))
    let eFlat2 = Note(noteLetter: .e, accidental: .flat, octave: Octave(rawValue: 2))
    let eSharp2 = Note(noteLetter: .e, accidental: .sharp, octave: Octave(rawValue: 2))
    let fSharp1 = Note(noteLetter: .f, accidental: .sharp, octave: Octave(rawValue: 1))
    let cFlat2 = Note(noteLetter: .c, accidental: .flat, octave: Octave(rawValue: 2))

    func testPitchIntervalClassBetweenNotes() {
        XCTAssert(pitchIntervalClass(between: bFlat1, and: gNatural1) == .three)
        XCTAssert(pitchIntervalClass(between: fSharp0, and: eFlat2) == .nine)
        XCTAssert(pitchIntervalClass(between: gNatural1, and: fSharp0) == .one)
        XCTAssert(pitchIntervalClass(between: fSharp0, and: gNatural1) == .one)
    }
    
    func testIntervalDiatonicSizeBetweenNotes() {
        XCTAssert(intervalDiatonicSize(between: bFlat1, and: gNatural1) == .third)
        XCTAssert(intervalDiatonicSize(between: fSharp0, and: eSharp2) == .second)
        XCTAssert(intervalDiatonicSize(between: bFlat1, and: eSharp2) == .fifth)
        XCTAssert(intervalDiatonicSize(between: fSharp0, and: gNatural1) == .second)
        XCTAssert(intervalDiatonicSize(between: fSharp0, and: fSharp1) == .octave)
        XCTAssert(intervalDiatonicSize(between: bFlat1, and: bFlat1) == .unison)
    }
    
    func testIntervalBetweenNotes() {
        guard let interval1 = interval(between: bFlat1, and: gNatural1) else { return }
        guard let interval2 = interval(between: gNatural1, and: fSharp0) else { return }
        guard let interval3 = interval(between: fSharp0, and: cFlat2) else { return }
        guard let interval4 = interval(between: bFlat1, and: fSharp0) else { return }
        guard let interval5 = interval(between: fSharp0, and: fSharp0) else { return }
                
        XCTAssert(interval1.pitchIntervalClass == .three && interval1.quality == .minor && interval1.size == .third)
        XCTAssert(interval2.pitchIntervalClass == .one && interval2.quality == .minor && interval2.size == .second)
        XCTAssert(interval3.pitchIntervalClass == .five)
        XCTAssert(interval4.pitchIntervalClass == .four && interval4.quality == .diminished && interval4.size == .fourth)
        XCTAssert(interval5.pitchIntervalClass == .zero && interval5.quality == .perfect && interval5.size == .unison)
    }

    
}
