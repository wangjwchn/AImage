//
//  AImage.swift
//  AImage
//
//  Created by wangjwchn on 16/8/22.
//  Copyright © 2016 JW. All rights reserved.
//

import ImageIO
import UIKit

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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

let defaultClarity: Float = 0.8
let floatEps: Float = 1E-6
let checkInternal = [60,30,20,15,12,10,6,5,4,3,2,1]

let _imageStorageKey = malloc(8)
public extension UIImage
{
    
    public convenience init(aImageData: Data, clarity: Float = defaultClarity){
        self.init()
        add(aImage: aImageData, with: clarity)
    }
    
    public func add(aImage data:Data, with clarity:Float = defaultClarity){
        self.m_ = image_storage()
        m_!.imageSource = CGImageSourceCreateWithData(data as CFData, nil)
        if (clarity <= 0 || clarity > 1) {
            print("Warning.Illegal input parameter 'clarity',request >0&&<=1.Using default clarity.")
            calculateFrameDelay(calcuDelayTimes(m_!.imageSource), clarity: defaultClarity)
        } else {
            calculateFrameDelay(calcuDelayTimes(m_!.imageSource), clarity: clarity)
        }
        calculateFrameSize()
    }
    
    public func getImageSource() -> CGImageSource { return m_!.imageSource! }
    
    public func getRefreshFactor() -> Int { return m_!.displayRefreshFactor! }
    
    public func getImageSize() -> Int { return m_!.imageSize! }
    
    public func getImageNumber() -> Int { return m_!.imageCount! }
    
    public func getDisplayOrder() -> [Int] { return m_!.displayOrder! }
    
    
    fileprivate func calcuDelayTimes(_ imageSource: CGImageSource?) -> [Float] {
        let imageCount = CGImageSourceGetCount(imageSource!)
        
        var imageProperties = [CFDictionary]()
        for i in 0..<imageCount {
            imageProperties.append(CGImageSourceCopyPropertiesAtIndex(imageSource!, i, nil)!)
        }
        
        var frameProperties = [CFDictionary]()
        
        if (CFDictionaryContainsKey(imageProperties[1], Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque())) {
            frameProperties = imageProperties.map() {
                unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
            }//gif
        } else if (CFDictionaryContainsKey(imageProperties[1],Unmanaged.passUnretained(kCGImagePropertyPNGDictionary).toOpaque())) {
            frameProperties = imageProperties.map() {
                unsafeBitCast(CFDictionaryGetValue($0,Unmanaged.passUnretained(kCGImagePropertyPNGDictionary).toOpaque()),to: CFDictionary.self)
            }//apng
        } else {
            fatalError("Illegal image type.")
        }
        
        let EPS:Float = 1e-6
        let frameDelays: [Float] = frameProperties.map() {
            var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
            
            if (delayObject.floatValue < EPS){
                delayObject = unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
            }
            return delayObject as! Float
        }
        
        return frameDelays
    }
    
    fileprivate func calculateFrameDelay(_ delaysArray: [Float], clarity: Float) {
        
        var delays = delaysArray
        
        let maxFramePerSecond = checkInternal.first
        
        //frame numbers per second
        let displayRefreshRates = checkInternal.map{ maxFramePerSecond! / $0 }
        
        //time interval per frame
        let displayRefreshDelayTime = displayRefreshRates.map{ 1.0 / Float($0) }
        
        //caclulate the time when eash frame should be displayed at(start at 0)
        for i in 1..<delays.count {
            delays[i] += delays[i-1]
        }
        
        //find the appropriate Factors then BREAK
        for i in 0..<displayRefreshDelayTime.count {
            let displayPosition = delays.map{ Int($0 / displayRefreshDelayTime[i]) }
            
            var framelosecount = 0
            for j in 1..<displayPosition.count {
                if (displayPosition[j] == displayPosition[j-1])
                {framelosecount += 1}
            }
            
            if (Float(framelosecount) <= Float(displayPosition.count) * (1.0 - clarity) || i == displayRefreshDelayTime.count - 1) {
                m_!.imageCount = displayPosition.last!
                m_!.displayRefreshFactor = checkInternal[i]
                m_!.displayOrder = [Int]()
                var indexOfold = 0, indexOfnew = 1
                while (indexOfnew <= m_!.imageCount) {
                    if (indexOfnew <= displayPosition[indexOfold]) {
                        m_!.displayOrder!.append(indexOfold)
                        indexOfnew += 1
                    } else {
                        indexOfold += 1
                    }
                }
                break
            }
        }
    }
    
    fileprivate func calculateFrameSize() {
        let image = UIImage(cgImage: CGImageSourceCreateImageAtIndex(m_!.imageSource!, 0, nil)!)
        m_!.imageSize = Int(image.size.height * image.size.width * 4) * m_!.imageCount! / (1000 * 1000)
    }
    
    fileprivate var m_: image_storage? {
        get {
            return (objc_getAssociatedObject(self, _imageStorageKey) as! image_storage)
        }
        set {
            objc_setAssociatedObject(self, _imageStorageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
}

private class image_storage
{
    var imageSource:CGImageSource?
    var displayRefreshFactor:Int?
    var imageSize:Int?
    var imageCount:Int?
    var displayOrder:[Int]?
}
