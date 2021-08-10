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
    
    struct Constants {
        static let bSharp = Note(noteLetter: .b, accidental: .sharp)
        static let cNatural = Note(noteLetter: .c, accidental: .natural)
        static let dDoubleFlat = Note(noteLetter: .d, accidental: .doubleFlat)
        static let cSharp = Note(noteLetter: .c, accidental: .sharp)
        static let dFlat = Note(noteLetter: .d, accidental: .flat)
        static let dNatural = Note(noteLetter: .d, accidental: .natural)
        static let dSharp = Note(noteLetter: .d, accidental: .sharp)
        static let eFlat = Note(noteLetter: .e, accidental: .flat)
        static let fDoubleFlat = Note(noteLetter: .f, accidental: .doubleFlat)
        static let eNatural = Note(noteLetter: .e, accidental: .natural)
        static let fNatural = Note(noteLetter: .f, accidental: .natural)
        static let fSharp = Note(noteLetter: .f, accidental: .sharp)
        static let gNatural = Note(noteLetter: .g, accidental: .natural, octave: nil)
        static let gSharp = Note(noteLetter: .g, accidental: .sharp)
        static let aFlat = Note(noteLetter: .a, accidental: .flat)
        static let bDoubleSharp = Note(noteLetter: .b, accidental: .doubleSharp)
        static let bFlat = Note(noteLetter: .b, accidental: .flat)
        static let bNatural = Note(noteLetter: .b, accidental: .natural, octave: nil)
        
        static let aFlatMaj1 = [gSharp, bSharp, dSharp]
    }
        
    struct PitchCollections {
        static let aFlatMajor: [PitchClass] = [.gSharp, .c, .dSharp]
        static let cDominantSeven: [PitchClass] = [.c, .e, .g, .aSharp]
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
    
    func testAllPossibleNotes() {
        let noteCombos1 = enharmonicSpeller.allPossibleNotes(of: PitchCollections.aFlatMajor)
        let noteCombos1AsSets = noteCombos1.map { Set($0) } // Use a set b/c order doesn't matter in testing equality

        XCTAssert(noteCombos1AsSets == [[Constants.gSharp, Constants.aFlat],
                                        [Constants.bSharp, Constants.cNatural, Constants.dDoubleFlat],
                                        [Constants.dSharp, Constants.eFlat, Constants.fDoubleFlat]])
    }
    
    func testAllNoteCombinations() {
        let noteCombos1 = enharmonicSpeller.generateAllNoteCombinations(from: [.dSharp])
        let noteCombos2 = enharmonicSpeller.generateAllNoteCombinations(from: [.gSharp, .c, .dSharp])
        let noteCombos2Set = Set(noteCombos2)
        
        XCTAssert(enharmonicSpeller.generateAllNoteCombinations(from: []) == [])
        XCTAssert(noteCombos1.contains([Constants.dSharp]) && noteCombos1.contains([Constants.eFlat]) && noteCombos1.contains([Constants.fDoubleFlat]))
        XCTAssert(noteCombos2.flatMap { $0 }.count == 54 && noteCombos2.count == 18)
        noteCombos2.forEach { XCTAssert($0.count == 3) }
        XCTAssert(noteCombos2.count == noteCombos2Set.count)
        XCTAssert(noteCombos2.contains([Constants.gSharp, Constants.bSharp, Constants.dSharp]))
    }
    
    //Test helper func--lowest abstraction level
    func testPairIsSpelledSuboptimally() {
        XCTAssert(!bestEnharmonicSpeller.pairIsSpelledSuboptimally((Constants.eNatural, Constants.fSharp)))
        XCTAssert(bestEnharmonicSpeller.pairIsSpelledSuboptimally((Constants.eNatural, Constants.dFlat)))
        XCTAssert(bestEnharmonicSpeller.pairIsSpelledSuboptimally((Constants.cSharp, Constants.dFlat)))
        XCTAssert(bestEnharmonicSpeller.pairIsSpelledSuboptimally((Constants.fNatural, Constants.gSharp)))
        XCTAssert(!bestEnharmonicSpeller.pairIsSpelledSuboptimally((Constants.dFlat, Constants.aFlat)))
    }
    
    //Test helper func--mid-level of abstraction
    func testNumSuboptimalSpellings() {
        let wellSpelledNotes: [Note] = [Constants.cSharp, Constants.eNatural, Constants.fSharp]
        let shouldBeSharpsNotes: [Note] = [Constants.dFlat, Constants.eNatural, Constants.aFlat]
        let shouldBeFlatsNotes: [Note] = [Constants.cSharp, Constants.fNatural, Constants.gSharp]
        
        XCTAssert(bestEnharmonicSpeller.pairsWithSuboptimalSpellings(among: wellSpelledNotes).isEmpty)
        XCTAssert(bestEnharmonicSpeller.pairsWithSuboptimalSpellings(among: shouldBeSharpsNotes).count == 2)
        XCTAssert(bestEnharmonicSpeller.pairsWithSuboptimalSpellings(among: shouldBeFlatsNotes).count == 2)
    }
    
    
    func testCorrectAccidentalTypeTriads() {
        let shouldBeSharpsPC: [PitchClass] = [.cSharp, .e, .gSharp]
        let shouldBeFlatsPC: [PitchClass] = [.cSharp, .f, .gSharp]
        
        XCTAssert(bestEnharmonicSpeller.allSharpsOrAllFlats(of: shouldBeSharpsPC).sorted() == [Constants.cSharp, Constants.eNatural, Constants.gSharp])
        XCTAssert(bestEnharmonicSpeller.allSharpsOrAllFlats(of: shouldBeFlatsPC).sorted() == [Constants.dFlat, Constants.fNatural, Constants.aFlat])
    }
    
    func testCorrectAccidentalTypeAtonal() {
        let atonalPC: [PitchClass] = [.e, .f, .aSharp]
        let atonalPCBestSpelling = bestEnharmonicSpeller.allSharpsOrAllFlats(of: atonalPC).sorted()
        
        XCTAssert(atonalPCBestSpelling == [Constants.eNatural, Constants.fNatural, Constants.bFlat])
    }
    
    //It should just default to sharps if equal number of suboptimal spellings
    func testCorrectAccidentalTypeAmbiguous() {
        let ambiguouslySpelledPC: [PitchClass] = [.cSharp, .f, .g, .b]
        let ambiguouslySpelledBestSpelling = bestEnharmonicSpeller.allSharpsOrAllFlats(of: ambiguouslySpelledPC).sorted()
        
        XCTAssert(ambiguouslySpelledBestSpelling == [Constants.cSharp, Constants.fNatural, Constants.gNatural, Constants.bNatural])
    }
    
    func testNoteFifths() {
        let noteFifths = NoteFifthsContainer.noteFifths
        
        XCTAssert(noteFifths[noteFifths.count/2] == Constants.dNatural)
        XCTAssert(noteFifths.firstIndex(of: Constants.cNatural) == 15)
        XCTAssert(noteFifths.firstIndex(of: Constants.bDoubleSharp) == 34)
    }
    
    func testNoteFifthsLookup() {
        let lookup = NoteFifthsContainer.noteFifthsLookup
        
        guard let cNatFifthsVal = lookup[Constants.cNatural] else { return }
        guard let dSharpFifthsVal = lookup[Constants.dSharp] else { return }
        guard let eFlatFifthsVal = lookup[Constants.eFlat] else { return }
        guard let bDoubleSharpFifthsVal = lookup[Constants.bDoubleSharp] else { return }
        
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
