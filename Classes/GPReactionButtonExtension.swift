//
//  GPReactionButtonExtension.swift
//  Action
//
//  Created by An Binh on 8/28/19.
//

import UIKit
import Reactions
import RxCocoa
import RxSwift

public extension Reactive where Base: ReactionButton {
    
    // MARK: reactive function
    
    //    var reaction: Binder<Reaction?> {
    //        return Binder(self.base) { $0.reaction = $1 ?? $0.reaction }
    //    }
    
    var reaction: ControlProperty<Reaction?> {
        return UIControl.toProperty(control: self.base, getter: { (button) in
            button.reaction
        }, setter: { (button, reaction) in
            button.reaction = reaction ?? button.reaction
        })
    }
    
}

public extension ReactionButton {
    // MARK: convenience method
    static func gapo() -> ReactionButton {
        let reactionSelector = ReactionSelector()
        reactionSelector.reactions = Reaction.gapo.all
        let reactionButton = ReactionButton()
        reactionButton.reactionSelector = reactionSelector
        reactionButton.config = ReactionButtonConfig() { $0.alignment = .centerLeft }
        return reactionButton
    }
}

