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
    static func gapo(selectorBackground: UIColor = .white,
                     selectorList: [Reaction] = Reaction.gapo.all,
                     likeReaction: Reaction = Reaction.gapo.like,
                     unlikeReaction: Reaction = Reaction.gapo.unlike) -> ReactionButton {
        let reactionSelector = ReactionSelector()
        reactionSelector.config = ReactionSelectorConfig {
            $0.iconSize = 40
            $0.backgroundColor = selectorBackground
        }
        reactionSelector.reactions = selectorList
        let reactionButton = ReactionButton()
        reactionButton.reactionSelector = reactionSelector
        reactionButton.config = ReactionButtonConfig() { $0.alignment = .centerLeft }
        reactionButton.likeReaction = likeReaction
        reactionButton.unlikeReaction = unlikeReaction
        return reactionButton
    }
    
    static func darkMode() -> ReactionButton {
        return gapo(selectorBackground: UIColor.init(r: 26, g: 26, b: 26, a: 0.7),
                    selectorList: Reaction.gapo.dark,
                    unlikeReaction: Reaction.gapo.whiteLike)
    }
    
    func observeReaction() -> Disposable {
        return rx.reaction.subscribe(onNext: { [weak self] (reaction) in
            guard let self = self else { return }
            self.handleChangeReaction(reaction)
        })
    }
    
    func handleChangeReaction(_ reaction: Reaction?) {
        if isInitObserve {
            // handle first time goto this action
            isInitObserve = false
            return
        }
        if (reaction?.id == unlikeReaction.id) {
            self.reaction = likeReaction
        }
        didUpdateReaction?(self.reaction)
    }
}

