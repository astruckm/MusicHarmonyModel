//
//  MusicHarmonyModelTests.swift
//  MusicHarmonyModelTests
//
//  Created by Andrew Struck-Marcell on 12/31/20.
//

import XCTest
@testable import MusicHarmonyModel

class MusicHarmonyModelTests: XCTestCase {

    //Mocks
    var harmonyModel = HarmonyModel(maxNotesInCollection: 6)
    let bestHarmonicSpelling = BestEnharmonicSpelling()
    let bestEnharmonicSpellingDelegate: BestEnharmonicSpellingDelegate? = nil
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoteSpellings() {
        let pcCSharp = PitchClass.c
        let pcE = PitchClass.e
        let pcF = PitchClass.f
        let pcGSharp = PitchClass.gSharp
        let pcB = PitchClass.b
        
        print(pcCSharp.possibleSpellings)
        XCTAssert(pcCSharp.possibleSpellings == ["C♯", "D♭", "B𝄪"])
        XCTAssert(pcE.possibleSpellings == ["E", "F♭", "D𝄪"])
        XCTAssert(pcF.possibleSpellings == ["F", "E♯", "G𝄫"])
        XCTAssert(pcGSharp.possibleSpellings == ["G♯", "A♭"])
        XCTAssert(pcB.possibleSpellings == ["B", "C♭", "A𝄪"])
    }
    
    func testNontonal() {
        let pitchCollection: [PitchClass] = [.c, .gSharp, .d]
        let normalFormPC: [PitchClass] = harmonyModel.normalForm(of: pitchCollection)
        
        XCTAssert(normalFormPC == [.gSharp, .c, .d])
        XCTAssert(harmonyModel.primeForm(ofCollectionInNormalForm: normalFormPC) == [0,2,6])
        XCTAssert(harmonyModel.getChordIdentity(of: pitchCollection) == nil)
        let keys = pitchCollection.map{($0, Octave.zero)}
        XCTAssert(harmonyModel.getChordInversion(of: keys) == nil)
    }
    
    func testTonal() {
        let pitchCollection: [PitchClass] = [.fSharp, .dSharp, .aSharp, .cSharp]
        let normalFormPC: [PitchClass] = harmonyModel.normalForm(of: pitchCollection)
        
        XCTAssert(normalFormPC == [.aSharp, .cSharp, .dSharp, .fSharp])
        XCTAssert(harmonyModel.primeForm(ofCollectionInNormalForm: normalFormPC) == [0,3,5,8])
        XCTAssert(harmonyModel.getChordIdentity(of: pitchCollection)! == (.dSharp, .minorSeventh))
        let keys = pitchCollection.map{($0, Octave.zero)}
        XCTAssert(harmonyModel.getChordInversion(of: keys)! == "3rd")
    }
    

}

//Test enharmonic spelling detection
extension MusicHarmonyModelTests {
    //Test helper func--lowest abstraction level
    func testPairIsSpelledSuboptimally() {
        guard let cSharp = Note(pitchClass: .cSharp, noteLetter: .c, octave: nil) else { return }
        guard let dFlat = Note(pitchClass: .cSharp, noteLetter: .d, octave: nil) else { return }
        guard let eNatural = Note(pitchClass: .e, noteLetter: .e, octave: nil) else { return }
        guard let fNatural = Note(pitchClass: .f, noteLetter: .f, octave: nil) else { return }
        guard let fSharp = Note(pitchClass: .fSharp, noteLetter: .f, octave: nil) else { return }
        guard let gSharp = Note(pitchClass: .gSharp, noteLetter: .g, octave: nil) else { return }
        guard let aFlat = Note(pitchClass: .gSharp, noteLetter: .a, octave: nil) else { return }
        
        XCTAssert(!bestHarmonicSpelling.pairIsSpelledSuboptimally((eNatural, fSharp)))
        XCTAssert(bestHarmonicSpelling.pairIsSpelledSuboptimally((eNatural, dFlat)))
        XCTAssert(bestHarmonicSpelling.pairIsSpelledSuboptimally((cSharp, dFlat)))
        XCTAssert(bestHarmonicSpelling.pairIsSpelledSuboptimally((fNatural, gSharp)))
        XCTAssert(!bestHarmonicSpelling.pairIsSpelledSuboptimally((dFlat, aFlat)))
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
        
        XCTAssert(bestHarmonicSpelling.pairsWithSuboptimalSpellings(among: wellSpelledNotes).isEmpty)
        XCTAssert(bestHarmonicSpelling.pairsWithSuboptimalSpellings(among: shouldBeSharpsNotes).count == 2)
        XCTAssert(bestHarmonicSpelling.pairsWithSuboptimalSpellings(among: shouldBeFlatsNotes).count == 2)
    }
    
    
    func testCorrectAccidentalTypeTriads() {
        let shouldBeSharpsPC: [PitchClass] = [.cSharp, .e, .gSharp]
        let shouldBeFlatsPC: [PitchClass] = [.cSharp, .f, .gSharp]
        
        XCTAssert(bestHarmonicSpelling.collectionShouldUseSharps(shouldBeSharpsPC))
        XCTAssert(!(bestHarmonicSpelling.collectionShouldUseSharps(shouldBeFlatsPC)))
    }
    
    func testCorrectAccidentalTypeAtonal() {
        let atonalPC: [PitchClass] = [.e, .f, .aSharp]
        XCTAssert(!bestHarmonicSpelling.collectionShouldUseSharps(atonalPC))
    }
    
    //It should just default to sharps if equal number of suboptimal spellings
    func testCorrectAccidentalTypeAmbiguous() {
        let ambiguouslySpelledPC: [PitchClass] = [.cSharp, .f, .g, .b]
        XCTAssert(bestHarmonicSpelling.collectionShouldUseSharps(ambiguouslySpelledPC))
    }
}

//Test harmony types
extension MusicHarmonyModelTests {
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
    
    func testChordFromNotes() {
        guard harmonyModel.maxNotes < 0 else { return }
        guard let note1 = Note(pitchClass: .aSharp, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let note2 = Note(pitchClass: .g, noteLetter: .g, octave: Octave(rawValue: 1)) else { return }
        guard let note3 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 0)) else { return }
        guard let note4 = Note(pitchClass: .d, noteLetter: .d, octave: Octave(rawValue: 1)) else { return } ///note4 should have octave beyond range
        guard let note5 = Note(pitchClass: .fSharp, noteLetter: .f, octave: Octave(rawValue: 1)) else { return }
        guard let note6 = Note(pitchClass: .b, noteLetter: .b, octave: Octave(rawValue: 1)) else { return }
        guard let note7 = Note(pitchClass: .f, noteLetter: .f, octave: nil) else { return }
        guard let note8 = Note(pitchClass: .a, noteLetter: .a, octave: Octave(rawValue: 0)) else { return }
        //TODO: some note that is outside of octave range
        
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

//Test conversions between types
extension MusicHarmonyModelTests {
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
        guard let note4 = Note(pitchClass: .f, noteLetter: .e, octave: Octave(rawValue: 2)) else { return } ///note4 should have octave beyond range
        
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
}
