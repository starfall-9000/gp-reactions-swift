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
    let reactionButton = ReactionButton.gapo()
    var disposeBag: DisposeBag? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        disposeBag = DisposeBag()
        
        view.addSubview(reactionButton)
        reactionButton.autoPinEdge(toSuperviewEdge: .top, withInset: 200)
        reactionButton.autoAlignAxis(toSuperviewAxis: .vertical)
        reactionButton.autoSetDimensions(to: .init(width: 100, height: 40))
        
        reactionButton.addTarget(self, action: #selector(handleTapButton(_:)), for: .touchUpInside)
        reactionButton.rx.reaction.subscribe(onNext: { (reaction) in
            NSLog("react-status: %@", self.reactionButton.reaction.getReactStatus())
            NSLog("react-code: %d", reaction?.getRequestCode() ?? -1)
        }) => disposeBag
        
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
    }
    
    @objc func handleTapButton(_ sender: ReactionButton) {
        if reactionButton.isSelected == false {
            reactionButton.reaction = Reaction.gapo.unlike
        } else {
            reactionButton.reaction = Reaction.gapo.like
        }
    }
    
    deinit {
        disposeBag = nil
    }
}
