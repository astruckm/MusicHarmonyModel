//
//  AllSharpsOrFlats.swift
//  MusicHarmonyModel
//
//  Created by Andrew Struck-Marcell on 1/15/21.
//
//
//


import Foundation

// Implementation that uses all sharps or all flats
// Takes notes as spelled in all flats or all sharps, and finds the number of "suboptimal" pairs (i.e. badly spelled, such as E-Ab when should be E-G#). Whichever has fewer is the best spelling
extension BestEnharmonicSpelling {
    public func allSharpsOrAllFlats(of pitchCollection: [PitchClass]) -> [Note] {
        let allSharps: [Note] = pitchCollection.compactMap { Note(pitchClass: $0,
                                                                  noteLetter: $0.isBlackKey ? $0.possibleLetterAccidentalCombos.first(where: { $0.accidental == .sharp })!.letter : $0.possibleLetterAccidentalCombos.first(where: { $0.accidental == .natural })!.letter,
                                                                  octave: nil) }
        let allFlats: [Note] = pitchCollection.compactMap { Note(pitchClass: $0,
                                                                 noteLetter: $0.isBlackKey ? $0.possibleLetterAccidentalCombos.first(where: { $0.accidental == .flat })!.letter : $0.possibleLetterAccidentalCombos.first(where: { $0.accidental == .natural })!.letter,
                                                                 octave: nil) }
        let shouldUseSharps = pairsWithSuboptimalSpellings(among: allSharps).count <= pairsWithSuboptimalSpellings(among: allFlats).count
        return shouldUseSharps ? allSharps : allFlats
    }
    
    //Compares each possible pair, assumes there are no duplicate notes
    func pairsWithSuboptimalSpellings(among notes: [Note]) -> [(Note, Note)] {
        guard notes.count >= 2 else { return [] }
        var subOptimallySpelledPairs: [(Note, Note)] = []
        for noteIndex in 0..<(notes.count-1) {
            for pairNoteIndex in (noteIndex+1)..<notes.count {
                let note = notes[noteIndex]
                let pairNote = notes[pairNoteIndex]
                if !note.pitchClass.isBlackKey && !pairNote.pitchClass.isBlackKey { continue }
                if pairIsSpelledSuboptimally((note, pairNote)) { subOptimallySpelledPairs.append((note, pairNote)) }
            }
        }
        return subOptimallySpelledPairs
    }
    
    func pairIsSpelledSuboptimally(_ pair: (Note, Note)) -> Bool {
        let rawStepsAway = abs(pair.0.noteLetter.abstractTonalScaleDegree - pair.1.noteLetter.abstractTonalScaleDegree)
        let minimumStepsAway = rawStepsAway <= 3 ? rawStepsAway : 7 - rawStepsAway ///i.e. how close the two notes COULD be
        let semitonesAway = abs(pair.0.pitchClass.rawValue - pair.1.pitchClass.rawValue)
        let intervalClass = semitonesAway <= 6 ? semitonesAway : (12 - semitonesAway)
        
        switch minimumStepsAway {
        case 0: return true
        case 1:
            return intervalClass < 1 || intervalClass > 2 ///2nds should be 1 or 2 semitones
        case 2:
            return intervalClass < 3 || intervalClass > 4 ///3rds, 3 or 4 semitones
        case 3:
            return intervalClass < 5 || intervalClass > 6 ///4ths, 5 or 6 semitones
        default:
            print("Error in calculating steps pair is apart")
            return false
        }
    }

}
