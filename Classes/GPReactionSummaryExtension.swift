//
//  GPReactionSummaryExtension.swift
//  Action
//
//  Created by An Binh on 11/23/19.
//

import UIKit
import Reactions

public extension ReactionSummary {
    func mapListReactions(_ summary: [String : Bool],
                          isAddNewReact: Bool = false) {
        let baseListReactions = Reaction.gapo.main
        var listReactions: [Reaction] = []
        for (type, value) in summary {
            guard var typeIndex = Int(type.suffix(1)) else { continue }
            typeIndex = typeIndex - 1
            if  value &&
                typeIndex >= 0 &&
                typeIndex < baseListReactions.count {
                listReactions.append(baseListReactions[typeIndex])
            }
        }
        if !isAddNewReact && listReactions.count == 0 {
            listReactions = [Reaction.gapo.like]
        }
        reactions = Reaction.sortedReactions(listReactions)
    }
    
    func addNewReaction(_ reaction: Reaction?, reactCount: Int) {
        if (reaction == nil ||
            reaction!.id == Reaction.gapo.like.id ||
            reaction!.id == Reaction.gapo.unlike.id) {
            if (reactions.count == 0) {
                reactions = [Reaction.gapo.like]
            }
            return
        }
        if reactCount == 1 {
            reactions = [reaction!]
            return
        }
        var currentReactions = reactions
        guard let _ = currentReactions.firstIndex(of: reaction!) else {
            currentReactions.append(reaction!)
            reactions = Reaction.sortedReactions(currentReactions)
            return
        }
    }
}
