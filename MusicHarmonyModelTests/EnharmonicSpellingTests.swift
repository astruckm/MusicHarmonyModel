//
//  EnharmonicSpellingTests.swift
//  MusicHarmonyModelTests
//
//  Created by Andrew Struck-Marcell on 1/2/21.
//

import XCTest
@testable import MusicHarmonyModel

class EnharmonicSpellingTests: XCTestCase {
    
    struct EnharmonicSpellingObject: BestEnharmonicSpellingDelegate { }
    var bestEnharmonicSpellingDelegate: BestEnharmonicSpellingDelegate!
    var noteFifthsContainer: NoteFifthsContainer!
    
    override func setUpWithError() throws {
        bestEnharmonicSpellingDelegate = EnharmonicSpellingObject()
        noteFifthsContainer = NoteFifthsContainer()
    }
    
    override func tearDownWithError() throws {
        bestEnharmonicSpellingDelegate = nil
        noteFifthsContainer = nil
    }
    
    //Test helper func--lowest abstraction level
    func testPairIsSpelledSuboptimally() {
        guard let cSharp = Note(pitchClass: .cSharp, noteLetter: .c, octave: nil) else { return }
        guard let dFlat = Note(pitchClass: .cSharp, noteLetter: .d, octave: nil) else { return }
        guard let eNatural = Note(pitchClass: .e, noteLetter: .e, octave: nil) else { return }
        guard let fNatural = Note(pitchClass: .f, noteLetter: .f, octave: nil) else { return }
        guard let fSharp = Note(pitchClass: .fSharp, noteLetter: .f, octave: nil) else { return }
        guard let gSharp = Note(pitchClass: .gSharp, noteLetter: .g, octave: nil) else { return }
        guard let aFlat = Note(pitchClass: .gSharp, noteLetter: .a, octave: nil) else { return }
        
        XCTAssert(!bestEnharmonicSpellingDelegate.pairIsSpelledSuboptimally((eNatural, fSharp)))
        XCTAssert(bestEnharmonicSpellingDelegate.pairIsSpelledSuboptimally((eNatural, dFlat)))
        XCTAssert(bestEnharmonicSpellingDelegate.pairIsSpelledSuboptimally((cSharp, dFlat)))
        XCTAssert(bestEnharmonicSpellingDelegate.pairIsSpelledSuboptimally((fNatural, gSharp)))
        XCTAssert(!bestEnharmonicSpellingDelegate.pairIsSpelledSuboptimally((dFlat, aFlat)))
    }
    
    //Test helper func--mid-level of abstraction
    func testNumSuboptimalSpellings() {
        guard let cSharp = Note(pitchClass: .cSharp, noteLetter: .c, octave: nil) else { return }
        guard let dFlat = Note(pitchClass: .cSharp, noteLetter: .d, octave: nil) else { return }
        guard let eNatural = Note(pitchClass: .e, noteLetter: .e, octave: nil) else { return }
        guard let fNatural = Note(pitchClass: .f, noteLetter: .f, octave: nil) else { return }
        guard let fSharp = Note(pitchClass: .fSharp, noteLetter: .f, octave: nil) else { return }
        guard let gSharp = Note(pitchClass: .gSharp, noteLetter: .g, octave: nil) else { return }
        guard let aFlat = Note(pitchClass: .gSharp, noteLetter: .a, octave: nil) else { return }
        
        let wellSpelledNotes: [Note] = [cSharp, eNatural, fSharp]
        let shouldBeSharpsNotes: [Note] = [dFlat, eNatural, aFlat]
        let shouldBeFlatsNotes: [Note] = [cSharp, fNatural, gSharp]
        
        XCTAssert(bestEnharmonicSpellingDelegate.pairsWithSuboptimalSpellings(among: wellSpelledNotes).isEmpty)
        XCTAssert(bestEnharmonicSpellingDelegate.pairsWithSuboptimalSpellings(among: shouldBeSharpsNotes).count == 2)
        XCTAssert(bestEnharmonicSpellingDelegate.pairsWithSuboptimalSpellings(among: shouldBeFlatsNotes).count == 2)
    }
    
    
    func testCorrectAccidentalTypeTriads() {
        let shouldBeSharpsPC: [PitchClass] = [.cSharp, .e, .gSharp]
        let shouldBeFlatsPC: [PitchClass] = [.cSharp, .f, .gSharp]
        
        guard let cSharp = Note(pitchClass: .cSharp, noteLetter: .c, octave: nil) else { return }
        guard let dFlat = Note(pitchClass: .cSharp, noteLetter: .d, octave: nil) else { return }
        guard let eNatural = Note(pitchClass: .e, noteLetter: .e, octave: nil) else { return }
        guard let fNatural = Note(pitchClass: .f, noteLetter: .f, octave: nil) else { return }
        guard let gSharp = Note(pitchClass: .gSharp, noteLetter: .g, octave: nil) else { return }
        guard let aFlat = Note(pitchClass: .gSharp, noteLetter: .a, octave: nil) else { return }

        
        XCTAssert(bestEnharmonicSpellingDelegate.bestSpelling(of: shouldBeSharpsPC).sorted() == [cSharp, eNatural, gSharp])
        XCTAssert(bestEnharmonicSpellingDelegate.bestSpelling(of: shouldBeFlatsPC).sorted() == [dFlat, fNatural, aFlat])
    }
    
    func testCorrectAccidentalTypeAtonal() {
        let atonalPC: [PitchClass] = [.e, .f, .aSharp]
        guard let eNatural = Note(pitchClass: .e, noteLetter: .e, octave: nil) else { return }
        guard let fNatural = Note(pitchClass: .f, noteLetter: .f, octave: nil) else { return }
        let bFlat = Note(noteLetter: .b, accidental: .flat, octave: nil)

        let atonalPCBestSpelling = bestEnharmonicSpellingDelegate.bestSpelling(of: atonalPC).sorted()
        
        XCTAssert(atonalPCBestSpelling == [eNatural, fNatural, bFlat])
    }
    
    //It should just default to sharps if equal number of suboptimal spellings
    func testCorrectAccidentalTypeAmbiguous() {
        let ambiguouslySpelledPC: [PitchClass] = [.cSharp, .f, .g, .b]
        guard let cSharp = Note(pitchClass: .cSharp, noteLetter: .c, octave: nil) else { return }
        guard let fNatural = Note(pitchClass: .f, noteLetter: .f, octave: nil) else { return }
        let gNatural = Note(noteLetter: .g, accidental: .natural, octave: nil)
        let bNatural = Note(noteLetter: .b, accidental: .natural, octave: nil)
        
        let ambiguouslySpelledBestSpelling = bestEnharmonicSpellingDelegate.bestSpelling(of: ambiguouslySpelledPC).sorted()
        
        XCTAssert(ambiguouslySpelledBestSpelling == [cSharp, fNatural, gNatural, bNatural])
//        XCTAssert(bestEnharmonicSpellingDelegate.collectionShouldUseSharps(ambiguouslySpelledPC))
    }
    
    func testNoteFifths() {
        let cNatural = Note(noteLetter: .c, accidental: .natural)
        let dNatural = Note(noteLetter: .d, accidental: .natural)
        let bDoubleSharp = Note(noteLetter: .b, accidental: .doubleSharp)
        let noteFifths = noteFifthsContainer.noteFifths
        
        XCTAssert(noteFifths[noteFifths.count/2] == dNatural)
        XCTAssert(noteFifths.firstIndex(of: cNatural) == 15)
        XCTAssert(noteFifths.firstIndex(of: bDoubleSharp) == 34)
    }
    
    func testNoteFifthsLookup() {
        let cNatural = Note(noteLetter: .c, accidental: .natural)
        let dSharp = Note(noteLetter: .d, accidental: .sharp)
        let eFlat = Note(noteLetter: .e, accidental: .flat)
        let bDoubleSharp = Note(noteLetter: .b, accidental: .doubleSharp)
        let lookup = noteFifthsContainer.noteFifthsLookup
        
        guard let cNatFifthsVal = lookup[cNatural] else { return }
        guard let dSharpFifthsVal = lookup[dSharp] else { return }
        guard let eFlatFifthsVal = lookup[eFlat] else { return }
        guard let bDoubleSharpFifthsVal = lookup[bDoubleSharp] else { return }
        
        XCTAssert(cNatFifthsVal == 15)
        XCTAssert(bDoubleSharpFifthsVal == 34)
        XCTAssert(abs(eFlatFifthsVal-cNatFifthsVal) < abs(dSharpFifthsVal-cNatFifthsVal))
    }
    
    
    
}
