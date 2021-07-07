//
//  EnharmonicSpellingTests.swift
//  MusicHarmonyModelTests
//
//  Created by Andrew Struck-Marcell on 1/2/21.
//

import XCTest
@testable import MusicHarmonyModel

class EnharmonicSpellingTests: XCTestCase {
    var enharmonicSpeller: EnharmonicSpelling!
    var bestEnharmonicSpeller: BestEnharmonicSpelling!
    var noteFifthsContainer: NoteFifthsContainer!
    
    struct Notes {
        static let cNatural = Note(noteLetter: .c, accidental: .natural)
        static let bDoubleSharp = Note(noteLetter: .b, accidental: .doubleSharp)
        static let cSharp = Note(noteLetter: .c, accidental: .sharp)
        static let dFlat = Note(noteLetter: .d, accidental: .flat)
        static let dNatural = Note(noteLetter: .d, accidental: .natural)
        static let dSharp = Note(noteLetter: .d, accidental: .sharp)
        static let eFlat = Note(noteLetter: .e, accidental: .flat)
        static let eNatural = Note(noteLetter: .e, accidental: .natural)
        static let fNatural = Note(noteLetter: .f, accidental: .natural)
        static let fSharp = Note(noteLetter: .f, accidental: .sharp)
        static let gNatural = Note(noteLetter: .g, accidental: .natural, octave: nil)
        static let gSharp = Note(noteLetter: .g, accidental: .sharp)
        static let aFlat = Note(noteLetter: .a, accidental: .flat)
        static let bFlat = Note(noteLetter: .b, accidental: .flat)
        static let bNatural = Note(noteLetter: .b, accidental: .natural, octave: nil)
    }
    
    override func setUpWithError() throws {
        enharmonicSpeller = EnharmonicSpeller()
        bestEnharmonicSpeller = BestEnharmonicSpeller()
        noteFifthsContainer = NoteFifthsContainer()
    }
    
    override func tearDownWithError() throws {
        enharmonicSpeller = nil
        bestEnharmonicSpeller = nil
        noteFifthsContainer = nil
    }
    
    func testNumPossibleCombinations() {
        let collection1: [PitchClass] = [.gSharp, .c, .dSharp]
        // TODO: more collections with more pitch classes
        
        XCTAssert(enharmonicSpeller.numPossibleSpellingCombinations(in: collection1) == 18)
    }
    
    //Test helper func--lowest abstraction level
    func testPairIsSpelledSuboptimally() {
        XCTAssert(!bestEnharmonicSpeller.pairIsSpelledSuboptimally((Notes.eNatural, Notes.fSharp)))
        XCTAssert(bestEnharmonicSpeller.pairIsSpelledSuboptimally((Notes.eNatural, Notes.dFlat)))
        XCTAssert(bestEnharmonicSpeller.pairIsSpelledSuboptimally((Notes.cSharp, Notes.dFlat)))
        XCTAssert(bestEnharmonicSpeller.pairIsSpelledSuboptimally((Notes.fNatural, Notes.gSharp)))
        XCTAssert(!bestEnharmonicSpeller.pairIsSpelledSuboptimally((Notes.dFlat, Notes.aFlat)))
    }
    
    //Test helper func--mid-level of abstraction
    func testNumSuboptimalSpellings() {
        let wellSpelledNotes: [Note] = [Notes.cSharp, Notes.eNatural, Notes.fSharp]
        let shouldBeSharpsNotes: [Note] = [Notes.dFlat, Notes.eNatural, Notes.aFlat]
        let shouldBeFlatsNotes: [Note] = [Notes.cSharp, Notes.fNatural, Notes.gSharp]
        
        XCTAssert(bestEnharmonicSpeller.pairsWithSuboptimalSpellings(among: wellSpelledNotes).isEmpty)
        XCTAssert(bestEnharmonicSpeller.pairsWithSuboptimalSpellings(among: shouldBeSharpsNotes).count == 2)
        XCTAssert(bestEnharmonicSpeller.pairsWithSuboptimalSpellings(among: shouldBeFlatsNotes).count == 2)
    }
    
    
    func testCorrectAccidentalTypeTriads() {
        let shouldBeSharpsPC: [PitchClass] = [.cSharp, .e, .gSharp]
        let shouldBeFlatsPC: [PitchClass] = [.cSharp, .f, .gSharp]
        
        XCTAssert(bestEnharmonicSpeller.allSharpsOrAllFlats(of: shouldBeSharpsPC).sorted() == [Notes.cSharp, Notes.eNatural, Notes.gSharp])
        XCTAssert(bestEnharmonicSpeller.allSharpsOrAllFlats(of: shouldBeFlatsPC).sorted() == [Notes.dFlat, Notes.fNatural, Notes.aFlat])
    }
    
    func testCorrectAccidentalTypeAtonal() {
        let atonalPC: [PitchClass] = [.e, .f, .aSharp]
        let atonalPCBestSpelling = bestEnharmonicSpeller.allSharpsOrAllFlats(of: atonalPC).sorted()
        
        XCTAssert(atonalPCBestSpelling == [Notes.eNatural, Notes.fNatural, Notes.bFlat])
    }
    
    //It should just default to sharps if equal number of suboptimal spellings
    func testCorrectAccidentalTypeAmbiguous() {
        let ambiguouslySpelledPC: [PitchClass] = [.cSharp, .f, .g, .b]
        let ambiguouslySpelledBestSpelling = bestEnharmonicSpeller.allSharpsOrAllFlats(of: ambiguouslySpelledPC).sorted()
        
        XCTAssert(ambiguouslySpelledBestSpelling == [Notes.cSharp, Notes.fNatural, Notes.gNatural, Notes.bNatural])
    }
    
    func testNoteFifths() {
        let noteFifths = NoteFifthsContainer.noteFifths
        
        XCTAssert(noteFifths[noteFifths.count/2] == Notes.dNatural)
        XCTAssert(noteFifths.firstIndex(of: Notes.cNatural) == 15)
        XCTAssert(noteFifths.firstIndex(of: Notes.bDoubleSharp) == 34)
    }
    
    func testNoteFifthsLookup() {
        let lookup = NoteFifthsContainer.noteFifthsLookup
        
        guard let cNatFifthsVal = lookup[Notes.cNatural] else { return }
        guard let dSharpFifthsVal = lookup[Notes.dSharp] else { return }
        guard let eFlatFifthsVal = lookup[Notes.eFlat] else { return }
        guard let bDoubleSharpFifthsVal = lookup[Notes.bDoubleSharp] else { return }
        
        XCTAssert(cNatFifthsVal == 15)
        XCTAssert(bDoubleSharpFifthsVal == 34)
        XCTAssert(abs(eFlatFifthsVal-cNatFifthsVal) < abs(dSharpFifthsVal-cNatFifthsVal))
    }
    
    func testGenerateAllNoteCombinations() {
        let aFlatPC: [PitchClass] = [.gSharp, .c, .dSharp]
        let aFlatPCSpellings = bestEnharmonicSpeller.generateAllNoteCombinations(from: aFlatPC)
        print(aFlatPCSpellings)
        XCTAssert(aFlatPCSpellings.count == 8)
    }
    
    
    
}
