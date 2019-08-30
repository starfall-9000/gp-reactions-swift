//
//  GPReactionExtension.swift
//  GPReactions
//
//  Created by An Binh on 8/26/19.
//

import Reactions
import DDMvvm

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
                color = UIColor(r: 111, g: 190, b: 68)
                title = "Thích"
                icon = imageWithName("gapo-like")
                alterIcon = alterImageWithName(type.rawValue)
            case .like:
                color = UIColor(r: 111, g: 190, b: 68)
                title = "Thích"
                alterIcon = alterImageWithName(type.rawValue)
                break
            case .love:
                color = UIColor(r: 227, g: 61, b: 81)
                title = "Yêu"
                break
            case .haha:
                color = UIColor(r: 252, g: 224, b: 57)
                title = "Haha"
                break
            case .sock:
                color = UIColor(r: 218, g: 60, b: 15)
                title = "Woa"
                break
            case .sad:
                color = UIColor(r: 212, g: 142, b: 21)
                title = "Buồn"
                break
            case .angry:
                color = UIColor(r: 167, g: 130, b: 189)
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
            }
            
            return Reaction(id: type.rawValue, title: title, color: color, icon: icon ?? imageWithName(type.rawValue), alternativeIcon: alterIcon)
        }
        
        public static func imageWithName(_ name: String) -> UIImage! {
            let imageName = String(name[name.index(name.startIndex, offsetBy: 5)...])
            let bundlePath = GPBundle.getBundle().path(forResource: imageName, ofType: "png")
            return UIImage(named: bundlePath!)!
        }
        
        public static func alterImageWithName(_ name: String) -> UIImage! {
            let imageName = String(name[name.index(name.startIndex, offsetBy: 5)...]) + "_alter"
            let bundlePath = GPBundle.getBundle().path(forResource: imageName, ofType: "png")
            return UIImage(named: bundlePath!)!
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
        return String(id[id.index(id.startIndex, offsetBy: 5)...])
    }
}
