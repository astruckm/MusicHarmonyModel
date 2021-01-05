//
//  HarmonyModelTests.swift
//  HarmonyModelTests
//
//  Created by Andrew Struck-Marcell on 12/31/20.
//

import XCTest
@testable import MusicHarmonyModel

class HarmonyModelTests: XCTestCase {

    //Mocks
    var harmonyModel: HarmonyModel!
    
    override func setUpWithError() throws {
        harmonyModel = HarmonyModel(maxNotesInCollection: 6)
    }
    
    override func tearDownWithError() throws {
        harmonyModel = nil
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
        XCTAssert(harmonyModel.getChordInversion(of: keys) == "3rd")
    }
    

}


