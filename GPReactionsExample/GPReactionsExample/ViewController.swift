//
//  ViewController.swift
//  GPReactionsExample
//
//  Created by An Binh on 9/9/19.
//  Copyright © 2019 Gapo. All rights reserved.
//

import UIKit
import GPReactions
import Reactions
import RxSwift
import DTMvvm

class ViewController: UIViewController {
    let reactionButton = ReactionButton.darkMode()
    var disposeBag: DisposeBag? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        disposeBag = DisposeBag()
        
        view.addSubview(reactionButton)
        reactionButton.autoPinEdge(toSuperviewEdge: .top, withInset: 200)
        reactionButton.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
        reactionButton.autoSetDimensions(to: .init(width: 40, height: 40))
        reactionButton.config = ReactionButtonConfig {
            $0.alignment = .centerLeft
            $0.hideTitle = true
            $0.safeSelectorMargin = 40
        }
        
        reactionButton.addTarget(self, action: #selector(handleTapButton(_:)), for: .touchUpInside)
        reactionButton.observeReaction() => disposeBag
        reactionButton.didUpdateReaction = { [weak self] reaction in
            guard let self = self else { return }
            NSLog("react-status: %@", self.reactionButton.reaction.getReactStatus())
            NSLog("react-code: %d", reaction?.getRequestCode() ?? -1)
        }
        
        let reactionSummary = ReactionSummary()
        reactionSummary.reactions = Reaction.gapo.main
        reactionSummary.config = ReactionSummaryConfig() {
            $0.iconMarging = 8
            $0.spacing = 4
        }
        view.addSubview(reactionSummary)
        reactionSummary.autoPinEdge(toSuperviewEdge: .top, withInset: 300)
        reactionSummary.autoAlignAxis(toSuperviewAxis: .vertical)
        reactionSummary.autoSetDimensions(to: .init(width: 350, height: 40))
        reactionSummary.text = "150k"
        let listReaction = ["1": true, "2": false, "3": true, "4": false, "6": true]
        reactionSummary.mapListReactions(listReaction)
        reactionSummary.addNewReaction(Reaction.gapo.love, reactCount: 3)
    }
    
    @objc func handleTapButton(_ sender: ReactionButton) {
        if reactionButton.isSelected == false {
            reactionButton.reaction = Reaction.gapo.whiteLike
        } else {
            reactionButton.reaction = Reaction.gapo.like
        }
    }
    
    deinit {
        disposeBag = nil
    }
}
