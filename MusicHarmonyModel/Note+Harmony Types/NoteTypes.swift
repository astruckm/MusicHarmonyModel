//
//  NoteTypes.swift
//  Chord Calculator
//
//  Created by ASM on 3/20/18.
//  Copyright © 2018 ASM. All rights reserved.
//

import Foundation


typealias PianoKey = (pitchClass: PitchClass, octave: Octave) ///i.e. a key on the piano

public enum PitchClass: Int, Comparable, Hashable, CaseIterable {
    case c = 0, cSharp, d, dSharp, e, f, fSharp, g, gSharp, a, aSharp, b
    
    var isBlackKey: Bool {
        return String(describing: self).contains("Sharp")
    }
    
    var possibleLetterAccidentalCombos: [(letter: NoteLetter, accidental: Accidental)] {
        switch self {
        case .c: return [(.c, .natural), (.b, .sharp), (.d, .doubleFlat)]
        case .cSharp: return [(.c, .sharp), (.d, .flat), (.b, .doubleSharp)]
        case .d: return [(.d, .natural), (.c, .doubleSharp), (.e, .doubleFlat)]
        case .dSharp: return [(.d, .sharp), (.e, .flat), (.f, .doubleFlat)]
        case .e: return [(.e, .natural), (.f, .flat), (.d, .doubleSharp)]
        case .f: return [(.f, .natural), (.e, .sharp), (.g, .doubleFlat)]
        case .fSharp: return [(.f, .sharp), (.g, .flat), (.e, .doubleSharp)]
        case .g: return [(.g, .natural), (.f, .doubleSharp), (.a, .doubleFlat)]
        case .gSharp: return [(.g, .sharp), (.a, .flat)]
        case .a: return [(.a, .natural), (.g, .doubleSharp), (.b, .doubleFlat)]
        case .aSharp: return [(.a, .sharp), (.b, .flat), (.c, .doubleFlat)]
        case .b: return [(.b, .natural), (.c, .flat), (.a, .doubleSharp)]
        }
    }

    var possibleSpellings: [String] {
        return self.possibleLetterAccidentalCombos.map { $0.letter.rawValue + (($0.accidental == .natural) ? "" : $0.accidental.rawValue) }
    }
        
    public static func <(lhs: PitchClass, rhs: PitchClass) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

public enum NoteLetter: String, Equatable, CaseIterable, Hashable {
    case c = "C", d = "D", e = "E", f = "F", g = "G", a = "A", b = "B"
    
    //To compare scale degrees in a diatonic scale
    var abstractTonalScaleDegree: Int {
        switch self {
        case .c: return 1
        case .d: return 2
        case .e: return 3
        case .f: return 4
        case .g: return 5
        case .a: return 6
        case .b: return 7
        }
    }
}

public enum Accidental: String, Equatable, CaseIterable {
    case doubleFlat = "𝄫"
    case flat = "♭"
    case natural = "♮"
    case sharp = "♯"
    case doubleSharp = "𝄪"
    
    var semitonesAltered: Int {
        switch self {
        case .doubleFlat: return -2
        case .flat: return -1
        case .natural: return 0
        case .sharp: return 1
        case .doubleSharp: return 2
        }
    }
}

//C4 is middle C, A4 is A 440, A0 lowest note on 88 key piano, etc.
public enum Octave: Int, Equatable, CaseIterable, Hashable {
    case zero = 0, one, two, three, four, five, six, seven, eight
}

public struct Note: Hashable, Equatable {
    let pitchClass: PitchClass
    let noteLetter: NoteLetter
    let accidental: Accidental
    let octave: Octave?
            
    init?(pitchClass: PitchClass, noteLetter: NoteLetter, octave: Octave?) {
        guard let spelling = pitchClass.possibleLetterAccidentalCombos.first(where: { $0.letter == noteLetter}) else {
            print("Note is not possible: pitch class and note letter do not match")
            return nil
        }
                
        self.pitchClass = pitchClass
        self.noteLetter = noteLetter
        self.accidental = spelling.accidental
        self.octave = octave
    }
    
    //This init will guarantee you get a Note
    init(noteLetter: NoteLetter, accidental: Accidental, octave: Octave? = nil) {
        let spelling = noteLetter.rawValue + accidental.rawValue
        let pitchClass = PitchClass.allCases.first(where: { $0.possibleSpellings.contains(spelling) })
        if let pitchClass = pitchClass {
            self.pitchClass = pitchClass
        } else {
            let noteLetterDefaultPCNum: Int = (noteLetter.abstractTonalScaleDegree) > 3 ? ((noteLetter.abstractTonalScaleDegree - 1) * 2) - 1 : ((noteLetter.abstractTonalScaleDegree - 1) * 2)
            let spellingPCValue = (noteLetterDefaultPCNum + accidental.semitonesAltered) % PitchClass.allCases.count
            self.pitchClass = PitchClass(rawValue: spellingPCValue) ?? .c
        }
        
        self.noteLetter = noteLetter
        self.accidental = accidental
        self.octave = octave
    }
        

}

extension Note: CustomStringConvertible {
    public var description: String {
        return noteLetter.rawValue + accidental.rawValue
    }
}

extension Note: Comparable {
    //Higher pitched note is greater
    public static func <(lhs: Note, rhs: Note) -> Bool {
        guard let lhsOctave = lhs.octave, let rhsOctave = rhs.octave else {
            //If octave is nil (i.e. unknown), have to assume they are in the same octave
            return lhs.pitchClass.rawValue < rhs.pitchClass.rawValue
        }
        return keyValue(pitch: (lhs.pitchClass, lhsOctave)) < keyValue(pitch: (rhs.pitchClass, rhsOctave))
    }
}

