//
//  AImage.swift
//  AImage
//
//  Created by wangjwchn on 16/8/22.
//  Copyright © 2016 JW. All rights reserved.
//

/********************* Demo *********************

/* Create AImage with URL */
let image = AImage(url: Bundle.main.url(forResource: "test", withExtension: "gif")!)

/* Create AImageView */
let imageview = AImageView(frame:CGRect(x: 0.0, y: 50.0, width: 380.0, height: 212.0))

/* Add AImage to AImageView */
imageview.add(image: image!)

/* Start displaying animated image */
imageview.play = true
    
    ...
    ...
        
/* Stop displaying animated image */
imageview.play = false

********************* Demo *********************/

import ImageIO
import UIKit

public class AImageView: UIView {
    
    /* Whether the image is displaying or not */
    public var play: Bool = false
    
    /* Add an 'AImage' to 'AImageView' */
    // limit: Memory limit (in MB)
    public func add(image: AImage, limit: Int = 20){
        clear()
        self.aImage = image
        self.nextFrame = AImageView.cover(self.aImage!.imageSource)
        if (AImageView.calculateMemory(self.aImage!.imageSource) <= limit) {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                self.prepareCache()
            }
        }
        self.timer = CADisplayLink(target: self.displayLinkProxy, selector: #selector(myDisplayLinkProxyObject.proxyUpdateAnimation))
        if #available(iOS 10, *) {
            timer?.preferredFramesPerSecond = self.aImage!.framePerSecond
        } else {
            timer?.frameInterval = self.aImage!.framePerSecond
        }
        timer?.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private var aImage:AImage?
    private var indexAt:Int = 0
    private var timer:CADisplayLink?
    private var nextFrame:UIImage?
    private var cache:NSCache<AnyObject, AnyObject> = NSCache()
    private lazy var displayLinkProxy: myDisplayLinkProxyObject = {
        return myDisplayLinkProxyObject(listener: self)
    }()
    
    private class func cover(_ source: CGImageSource) -> UIImage {
        return UIImage(cgImage: CGImageSourceCreateImageAtIndex(source,0,nil)!)
    }
    
    private class func calculateMemory(_ source: CGImageSource) -> Int {
        let imageCount = CGImageSourceGetCount(source)
        let image = cover(source)
        return Int(image.size.height * image.size.width * 4) * imageCount / (1000 * 1000)
    }
    
    private func clear(){
        self.indexAt = 0
        self.cache.removeAllObjects()
        self.play = false
        if self.timer != nil {
            timer?.invalidate()
            self.timer = nil
        }
    }
    
    private func prepareCache() {
        for i in 0..<self.aImage!.displayIndex.count {
            let key = self.aImage!.displayIndex[i]
            if (self.cache.object(forKey: key as NSNumber) == nil) {
                let image = decodeImage(source: self.aImage!.imageSource, index: key)
                self.cache.setObject(image,forKey:key as NSNumber)
            }
        }
    }
    
    private func decodeImage(source: CGImageSource,index: Int) -> UIImage {
        let image = UIImage(cgImage: CGImageSourceCreateImageAtIndex(source,index,nil)!)
        UIGraphicsBeginImageContext(CGSize(width: image.size.width, height: image.size.height))
        image.draw(in: CGRect(x: 0, y: 0,width: image.size.width, height: image.size.height))
        let rawImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rawImage!
    }
    
    internal func timerFired() {
        self.layer.contents = self.nextFrame?.cgImage
        let nextAt = ((self.indexAt)+1)%(self.aImage!.displayIndex.count)
        if (self.aImage!.displayIndex [nextAt] != self.aImage!.displayIndex [(self.indexAt)]) {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                let key = self.aImage!.displayIndex[nextAt]
                self.nextFrame = self.cache.object(forKey: key as AnyObject) as? UIImage
                if (self.nextFrame == nil){
                    self.nextFrame = self.decodeImage(source: self.aImage!.imageSource, index: key)
                }
            }
        }
        if (self.play == true){
            self.indexAt = nextAt
            if (self.indexAt == self.aImage!.displayIndex.count - 1) {
                self.aImage!.loopCount -= 1
                if (self.aImage!.loopCount == 0) {
                    self.play = false
                }
            }
        }
    }
}

public class AImage {
    
    fileprivate let imageSource: CGImageSource
    fileprivate var framePerSecond:Int
    fileprivate var displayIndex:[Int]
    fileprivate var loopCount:Int
    
    /* Create an 'AImage' from URL */
    //quality: display quality, 1 is best, 0 is worst
    //loop: display time, -1 means forever
    public convenience init?(url: URL, quality: Float = 1.0, loop: Int = -1) {
        guard let src = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }
        self.init(source: src, quality, loop)
    }
    
    /* Create an 'AImage' from Data */
    //quality: display quality, 1 is best, 0 is worst
    //loop: display time, -1 means forever
    public convenience init?(data: Data, quality: Float = 1.0, loop: Int = -1) {
        guard let src = CGImageSourceCreateWithData(data as CFData, nil),
            CGImageSourceGetCount(src) > 0 else {
                return nil
        }
        self.init(source: src, quality, loop)
    }
    
    private init(source: CGImageSource, _ quality: Float, _ loop: Int) {
        self.imageSource = source
        var frameDelays = AImage.calcuDelayTimes(imageSource:source)
        (self.framePerSecond,self.displayIndex) = AImage.calculateFrameDelay(&frameDelays, quality)
        self.loopCount = loop
    }
    
    private class func calcuDelayTimes(imageSource: CGImageSource) -> [Float] {
        
        let frameCount = CGImageSourceGetCount(imageSource)
        var imageProperties = [CFDictionary]()
        for i in 0..<frameCount {
            imageProperties.append(CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil)!)
        }
        
        var frameProperties = [CFDictionary]()
        if (CFDictionaryContainsKey(imageProperties[1],
            Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque())) {
            frameProperties = imageProperties.map() {
                unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
            }//gif
        } else if (CFDictionaryContainsKey(imageProperties[1],
            Unmanaged.passUnretained(kCGImagePropertyPNGDictionary).toOpaque())) {
            frameProperties = imageProperties.map() {
                unsafeBitCast(CFDictionaryGetValue($0,
                   Unmanaged.passUnretained(kCGImagePropertyPNGDictionary).toOpaque()),to: CFDictionary.self)
            }//apng
        } else {
            fatalError("Illegal image type.")
        }

        let frameDelays: [Float] = frameProperties.map() {
            var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
            if (delayObject.floatValue == 0.0){
                delayObject = unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
            }
            return delayObject as! Float
        }
        return frameDelays
    }
    
    private class func calculateFrameDelay(_ delays: inout [Float],_ quality: Float) -> (Int,[Int]) {
        
        let framePerSecondChoices = [1,2,3,4,5,6,10,12,15,20,30,60]
        let displayRefreshDelayTime = framePerSecondChoices.map{ 1.0 / Float($0) }
        for i in 1..<delays.count {
            delays[i] += delays[i-1]
        }
        
        var order: [Int] = [Int]()
        var fps: Int = framePerSecondChoices.last!
        for i in 0..<framePerSecondChoices.count {
            let displayPosition = delays.map{ Int($0 / displayRefreshDelayTime[i]) }
            var framelosecount = 0
            for j in 1..<displayPosition.count {
                if (displayPosition[j] == displayPosition[j-1])
                {framelosecount += 1}
            }
            if (Float(framelosecount) <= Float(displayPosition.count) * (1 - quality) || i == displayRefreshDelayTime.count - 1) {
                fps = framePerSecondChoices[i]
                var indexOfold = 0, indexOfnew = 1
                while (indexOfnew <= displayPosition.last!) {
                    if (indexOfnew <= displayPosition[indexOfold]) {
                        order.append(indexOfold)
                        indexOfnew += 1
                    } else {
                        indexOfold += 1
                    }
                }
                break
            }
        }
        return (fps,order)
    }
}

// Use a proxy object to break the CADisplayLink retain cycle
fileprivate class myDisplayLinkProxyObject {
    weak var myListener: AImageView?
    init(listener: AImageView) {
        myListener = listener
    }
    @objc func proxyUpdateAnimation(link: CADisplayLink) {
        myListener?.timerFired()
    }
}
