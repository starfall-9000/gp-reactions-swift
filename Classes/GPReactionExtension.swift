//
//  GPReactionExtension.swift
//  GPReactions
//
//  Created by An Binh on 8/26/19.
//

import Reactions
import DDMvvm

public enum GapoReactionType: String {
    case like = "gapo-like"
    case love = "gapo-love"
    case haha = "gapo-haha"
    case wow = "gapo-wow"
    case sad = "gapo-sad"
    case angry = "gapo-angry"
    case pikachu = "sap--pikachu"
    case pinwheel = "sap--pinwheel"
}

extension Reaction {
    public struct gapo {
        public static var like: Reaction {
            return reactionWithId(.like)
        }
        
        public static var love: Reaction {
            return reactionWithId(.love)
        }
        
        public static var haha: Reaction {
            return reactionWithId(.haha)
        }
        
        public static var wow: Reaction {
            return reactionWithId(.wow)
        }
        
        public static var sad: Reaction {
            return reactionWithId(.sad)
        }
        
        public static var angry: Reaction {
            return reactionWithId(.angry)
        }
        
        public static let all: [Reaction] = [gapo.like, gapo.love, gapo.haha, gapo.wow, gapo.sad, gapo.angry]
        
        // MARK: - Convenience Methods
        public static func reactionWithId(_ type: GapoReactionType) -> Reaction {
            var color: UIColor = .black
            var title: String = ""
            var icon: UIImage? = nil
            
            switch type {
            case .like:
                color = UIColor(r: 111, g: 190, b: 68)
                title = "Like"
                break
            case .love:
                color = UIColor(r: 227, g: 61, b: 81)
                title = "Love"
                break
            case .haha:
                color = UIColor(r: 252, g: 224, b: 57)
                title = "Haha"
                break
            case .wow:
                color = UIColor(r: 218, g: 60, b: 15)
                title = "Wow"
                break
            case .sad:
                color = UIColor(r: 212, g: 142, b: 21)
                title = "Sad"
                break
            case .angry:
                color = UIColor(r: 167, g: 130, b: 189)
                title = "Angry"
                break
            case .pikachu:
                color = UIColor(r: 167, g: 130, b: 189)
                title = "Pikachu"
                icon = UIImage.gifImageWithName("pikachu")
                break
            case .pinwheel:
                color = UIColor(r: 167, g: 130, b: 189)
                title = "Pinwheel"
                icon = UIImage.apngImageWithName("pinwheel")
            }
            
            return Reaction(id: type.rawValue, title: title, color: color, icon: icon ?? imageWithName(type.rawValue))
        }
        
        private static func imageWithName(_ name: String) -> UIImage! {
            let imageName = String(name[name.index(name.startIndex, offsetBy: 5)...])
            return UIImage(named: imageName)!
        }
    }
}
