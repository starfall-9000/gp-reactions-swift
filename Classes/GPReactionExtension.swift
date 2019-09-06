//
//  GPReactionExtension.swift
//  GPReactions
//
//  Created by An Binh on 8/26/19.
//

import Reactions
import DTMvvm

public enum GapoReactionType: String {
    case unlike = "gapo-unlike"
    case like = "gapo-like"
    case love = "gapo-love"
    case haha = "gapo-haha"
    case sock = "gapo-sock"
    case sad = "gapo-sad"
    case angry = "gapo-angry"
    case pikachu = "sap--pikachu"
    case pinwheel = "sap--pinwheel"
}

extension Reaction {
    public struct gapo {
        public static var unlike: Reaction {
            return reactionWithId(.unlike)
        }
        
        public static var like: Reaction {
            return reactionWithId(.like)
        }
        
        public static var love: Reaction {
            return reactionWithId(.love)
        }
        
        public static var haha: Reaction {
            return reactionWithId(.haha)
        }
        
        public static var sock: Reaction {
            return reactionWithId(.sock)
        }
        
        public static var sad: Reaction {
            return reactionWithId(.sad)
        }
        
        public static var angry: Reaction {
            return reactionWithId(.angry)
        }
        
        public static let all: [Reaction] = [gapo.unlike, gapo.love, gapo.haha, gapo.sock, gapo.sad, gapo.angry]
        public static let main: [Reaction] = [gapo.like, gapo.love, gapo.haha, gapo.sock, gapo.sad, gapo.angry]
        
        public static func reactionWithStatus(status: String) -> Reaction {
            return reactionWithId(GapoReactionType(rawValue: "gapo-" + status) ?? .like)
        }
        
        // MARK: - Convenience Methods
        public static func reactionWithId(_ type: GapoReactionType) -> Reaction {
            var color: UIColor = .black
            var title: String = ""
            var icon: UIImage? = nil
            var alterIcon: UIImage? = nil
            
            switch type {
            case .unlike:
                color = UIColor(hexString: "#6FBE49")!
                title = "Thích"
                icon = imageWithType(.like)
            case .like:
                color = UIColor(hexString: "#6FBE49")!
                title = "Thích"
                break
            case .love:
                color = UIColor(hexString: "#F87376")!
                title = "Yêu"
                break
            case .haha:
                color = UIColor(hexString: "#F7D925")!
                title = "Haha"
                break
            case .sock:
                color = UIColor(hexString: "#DA3C0F")!
                title = "Woa"
                break
            case .sad:
                color = UIColor(hexString: "#D48E15")!
                title = "Buồn"
                break
            case .angry:
                color = UIColor(hexString: "#5168D7")!
                title = "Giận"
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
                alterIcon = UIImage.apngImageWithName("pinwheel")
            }
            
            return Reaction(id: type.rawValue, title: title, color: color, icon: icon ?? imageWithType(type), alternativeIcon: alterIcon ?? alterImageWithType(type))
        }
        
        public static func imageWithType(_ type: GapoReactionType) -> UIImage! {
            let imageName = getReactStatus(type)
            return UIImage.apngImageWithName(imageName)
        }
        
        public static func alterImageWithType(_ type: GapoReactionType) -> UIImage! {
            let imageName = getReactStatus(type) + "_alter"
            let bundlePath = GPBundle.getBundle().path(forResource: imageName, ofType: "png")
            return UIImage(named: bundlePath!)!
        }
        
        public static func getReactStatus(_ type: GapoReactionType) -> String {
            let name = type.rawValue
            let status = String(name[name.index(name.startIndex, offsetBy: 5)...])
            return status
        }
    }
    
    public func getRequestCode() -> Int {
        guard let type = GapoReactionType(rawValue: id) else { return -1 }
        switch type {
        case .unlike:
            return 1
        case .like:
            return 1
        case .love:
            return 2
        case .haha:
            return 3
        case .sock:
            return 4
        case .sad:
            return 5
        case .angry:
            return 6
        default:
            return -1
        }
    }
    
    public static func getReactionType(code: Int) -> GapoReactionType {
        switch code {
        case 1:
            return .like
        case 2:
            return .love
        case 3:
            return .haha
        case 4:
            return .sock
        case 5:
            return .sad
        case 6:
            return .angry
        default:
            return .like
        }
    }

    
    public func getReactStatus() -> String {
        return Reaction.gapo.getReactStatus(GapoReactionType(rawValue: id)!)
    }
    
    public static func sortedReactions(_ reactions: [Reaction]) -> [Reaction] {
        var baseReaction = Reaction.gapo.main
        baseReaction.insert(Reaction.gapo.unlike, at: 0)
        var sorted: [Reaction] = []
        let listAvailabelType = reactions.map { (reaction) -> String in
            return reaction.id
        }
        for reaction in baseReaction {
            if (listAvailabelType.contains(reaction.id)) {
                sorted.append(reaction)
            }
        }
        return sorted
    }
}
