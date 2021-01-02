//
//  IntervalTests.swift
//  MusicHarmonyModelTests
//
//  Created by Andrew Struck-Marcell on 1/2/21.
//

import XCTest
@testable import MusicHarmonyModel

class IntervalTests: XCTestCase {
    func testPitchIntervalClassBetweenNotes() {
        guard let note1 = Note(pitchClass: .aSharp, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let note2 = Note(pitchClass: .g, noteLetter: .g, octave: Octave(rawValue: 1)) else { return }
        guard let note3 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 0)) else { return }
        guard let note4 = Note(pitchClass: .dSharp, noteLetter: .e, octave: Octave(rawValue: 2)) else { return }
        
        XCTAssert(pitchIntervalClass(between: note1, and: note2) == .three)
        XCTAssert(pitchIntervalClass(between: note3, and: note4) == .three)
        XCTAssert(pitchIntervalClass(between: note2, and: note3) == .one)
        XCTAssert(pitchIntervalClass(between: note3, and: note2) == .one)
    }
    
    func testIntervalDiatonicSizeBetweenNotes() {
        guard let note1 = Note(pitchClass: .aSharp, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let note2 = Note(pitchClass: .g, noteLetter: .g, octave: Octave(rawValue: 1)) else { return }
        guard let note3 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 0)) else { return }
        guard let note4 = Note(pitchClass: .f, noteLetter: .e, octave: Octave(rawValue: 2)) else { return } ///note4 should have octave beyond range
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
        guard let note4 = Note(pitchClass: .f, noteLetter: .e, octave: Octave(rawValue: 2)) else { return }
        
        guard let interval1 = interval(between: note1, and: note2) else { return }
        guard let interval2 = interval(between: note2, and: note3) else { return }
        guard let interval3 = interval(between: note3, and: note4) else { return }
        guard let interval4 = interval(between: note1, and: note3) else { return }
        guard let interval5 = interval(between: note3, and: note3) else { return }
        
        XCTAssert(interval1.pitchIntervalClass == .three && interval1.quality == .minor && interval1.size == .third)
        XCTAssert(interval2.pitchIntervalClass == .one && interval2.quality == .minor && interval2.size == .second)
        XCTAssert(interval3.pitchIntervalClass == .one && interval3.quality == .minor && interval3.size == .second)
        XCTAssert(interval4.pitchIntervalClass == .four && interval4.quality == .diminished && interval4.size == .fourth)
        XCTAssert(interval5.pitchIntervalClass == .zero && interval5.quality == .perfect && interval5.size == .unison)
    }
    func testIntervalFromQualityAndSize() {
        let diminishedFourth = Interval(quality: .diminished, size: .fourth)
        let minorSeventh = Interval(quality: .minor, size: .seventh)
        let undefinedInterval = Interval(quality: .perfect, size: .second)
        
        XCTAssert(diminishedFourth?.pitchIntervalClass == .four)
        XCTAssert(minorSeventh?.pitchIntervalClass == .ten)
        XCTAssert(undefinedInterval == nil)
    }
    
    func testIntervalFromPIClassAndSize() {
        let tritone1 = Interval(intervalClass: .six, size: .fifth)
        let tritone2 = Interval(intervalClass: .six, size: .fourth)
        let undefinedInterval = Interval(intervalClass: .seven, size: .fourth)
        
        XCTAssert(tritone1?.quality == .diminished)
        XCTAssert(tritone2?.quality == .augmented)
        XCTAssert(undefinedInterval == nil)
    }


}
