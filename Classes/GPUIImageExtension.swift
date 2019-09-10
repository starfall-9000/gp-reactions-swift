//
//  UIImage+GPReactions.swift
//  GPReactions
//
//  Created by An Binh on 8/26/19.
//

import UIKit
import ImageIO

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

class GPReactionsBundle {
    class func getBundle() -> Bundle {
        let bundle = Bundle(for: self)
        guard let url = bundle.url(forResource: "GPReactions", withExtension: "bundle") else { return bundle }
        guard let podBundle = Bundle(url: url) else { return bundle }
        return podBundle
    }
    
    class func imageFromBundle(imageName: String, ext: String) -> UIImage! {
        let bundlePath = getBundle().path(forResource: imageName, ofType: ext)
        return UIImage(named: bundlePath!)!
    }
}

extension UIImage {
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let imageData = animatedData(name: name, extension: "gif") else { return nil }
        return imageWithData(imageData, extension: "gif")
    }
    
    public class func apngImageWithName(_ name: String) -> UIImage? {
        guard let imageData = animatedData(name: name, extension: "png") else { return nil }
        return imageWithData(imageData, extension: "apng")
    }
    
    public class func animatedData(name: String, extension ext: String) -> Data? {
        guard let bundleURL = GPReactionsBundle.getBundle().url(forResource: name, withExtension: ext) else {
            print("SwiftGif: This image named \"\(name).\(ext)\" does not exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name).\(ext)\" into NSData")
            return nil
        }
        return imageData
    }
    
    public class func imageWithData(_ data: Data, extension ext: NSString) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        if (ext == "gif") {
            let gifDict = [
                "property": kCGImagePropertyGIFDictionary,
                "unclampedDelay": kCGImagePropertyGIFUnclampedDelayTime,
                "delay": kCGImagePropertyGIFDelayTime
            ]
            return UIImage.animatedImageWithSource(source, props: gifDict)
        }
        if (ext == "apng") {
            let apngDict = [
                "property": kCGImagePropertyPNGDictionary,
                "unclampedDelay": kCGImagePropertyAPNGUnclampedDelayTime,
                "delay": kCGImagePropertyAPNGDelayTime
            ]
            return UIImage.animatedImageWithSource(source, props: apngDict)
        }
        return nil
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        return imageWithData(imageData, extension: "gif")
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!, props: [String: CFString]) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(props["property"]!).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(props["unclampedDelay"]!).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(props["delay"]!).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource, props: [String: CFString]) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source, props: props)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
}
