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

