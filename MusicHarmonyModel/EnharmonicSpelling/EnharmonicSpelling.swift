//
//  EnharmonicSpelling.swift
//  Chord Calculator
//
//  Created by ASM on 4/24/18.
//  Copyright © 2018 ASM. All rights reserved.
//


import Foundation

//Irrespective of scale or chord
protocol BestEnharmonicSpellingDelegate {
    func allSharpsOrAllFlats(of pitchCollection: [PitchClass]) -> [Note]
    //TODO: other implementations: try using number of fifths apart, user input whether ascending or descending context, special cases like harp, etc
}


struct EnharmonicSpeller: BestEnharmonicSpellingDelegate { }
