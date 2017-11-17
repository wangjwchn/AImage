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

public class AImageView: UIImageView {
    
    /* Whether the image is displaying or not */
    public var play:Bool = false
    
    /* Add an 'AImage' to 'AImageView' */
    // limit: Memory limit (in MB)
    public func add(image: AImage, limit: Int = 20){
        clear()
        self.clipsToBounds = true
        self.aImage = image
        self.nextFrame = AImageView.image(from: image.imageSource)
        if (AImageView.calculateMemory(image.imageSource) <= limit) {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                self.prepareCache()
                self.isMemoryLimit = true
            }
        }
        self.timer = CADisplayLink(target: self.displayLinkProxy, selector: #selector(myDisplayLinkProxyObject.proxyUpdateAnimation))
        if #available(iOS 10, *) {
            timer?.preferredFramesPerSecond = image.framePerSecond
        } else {
            timer?.frameInterval = image.framePerSecond
        }
        timer?.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    public func clear(){
        self.image = nil
        self.aImage = nil
        self.indexAt = 0
        timer?.invalidate()
        self.timer = nil
        self.nextFrame = nil
        self.cache.removeAllObjects()
        self.isMemoryLimit = false
        self.play = false
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private var aImage:AImage?
    private var indexAt:Int = 0
    private var timer:CADisplayLink?
    private var nextFrame:UIImage?
    private var cache:NSCache<NSNumber, UIImage> = NSCache()
    private var isMemoryLimit:Bool = false
    private lazy var displayLinkProxy: myDisplayLinkProxyObject = {
        return myDisplayLinkProxyObject(listener: self)
    }()
    
    private class func image(from source: CGImageSource, at index: Int = 0) -> UIImage? {
        if let cgImage: CGImage = CGImageSourceCreateImageAtIndex(source, index, nil) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    private class func calculateMemory(_ source: CGImageSource) -> Int {
        let imageCount:Int = CGImageSourceGetCount(source)
        let image:UIImage = self.image(from: source)!
        return Int(image.size.height * image.size.width * 4) * imageCount / (1000 * 1000)
    }
    
    private func prepareCache() {
        guard let aImage:AImage = self.aImage else { return }
        for i in 0..<aImage.displayIndex.count {
            let index:Int = aImage.displayIndex[i]
            if (self.cache.object(forKey: index as NSNumber) == nil) {
                if let image:UIImage = image(source: aImage.imageSource, index: index) {
                    self.cache.setObject(image,forKey: index as NSNumber)
                }
            }
        }
    }
    
    internal func timerFired() {
        self.image = self.nextFrame
        let aImage:AImage = self.aImage!
        let nextAt:Int = ((self.indexAt) + 1) % (aImage.displayIndex.count)
        let index:Int = aImage.displayIndex[nextAt]
        if (index != aImage.displayIndex[self.indexAt]) {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
                if self.isMemoryLimit == true {
                    let image:UIImage? = self.cache.object(forKey: index as NSNumber)
                    self.nextFrame = image
                } else {
                    self.nextFrame = AImageView.image(from: aImage.imageSource, at: index)
                }
            }
        }
        if (self.play == true) {
            self.indexAt = nextAt
            if (self.indexAt == aImage.displayIndex.count - 1) {
                aImage.loopCount -= 1
                if (aImage.loopCount == 0) {
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
        guard let src = CGImageSourceCreateWithURL(url as CFURL, nil),
            CGImageSourceGetCount(src) > 0 else {
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
        var frameDelays:[Float] = AImage.calcuDelayTimes(imageSource:source)
        (self.framePerSecond,self.displayIndex) = AImage.calculateFrameDelay(&frameDelays, quality)
        self.loopCount = loop
    }
    
    private class func calcuDelayTimes(imageSource: CGImageSource) -> [Float] {
        let frameCount:Int = CGImageSourceGetCount(imageSource)
        var imageProperties:[CFDictionary] = [CFDictionary]()
        for i in 0..<frameCount {
            imageProperties.append(CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil)!)
        }
        
        var frameProperties:[CFDictionary] = [CFDictionary]()
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
        
        let frameDelays:[Float] = frameProperties.map() {
            var delayObject:AnyObject = unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
            if (delayObject.floatValue == 0.0){
                delayObject = unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
            }
            return delayObject as! Float
        }
        return frameDelays
    }
    
    private class func calculateFrameDelay(_ delays: inout [Float],_ quality: Float) -> (Int,[Int]) {
        let framePerSecondChoices:[Int] = [1,2,3,4,5,6,10,12,15,20,30,60]
        let displayRefreshDelayTime:[Float] = framePerSecondChoices.map{ 1.0 / Float($0) }
        for i in 1..<delays.count {
            delays[i] += delays[i-1]
        }
        
        var order:[Int] = [Int]()
        var fps:Int = framePerSecondChoices.last!
        for i in 0..<framePerSecondChoices.count {
            let displayPosition:[Int] = delays.map{ Int($0 / displayRefreshDelayTime[i]) }
            var framelosecount:Int = 0
            for j in 1..<displayPosition.count {
                if (displayPosition[j] == displayPosition[j-1]) {
                    framelosecount += 1
                }
            }
            if (Float(framelosecount) <= Float(displayPosition.count) * (1 - quality) || i == displayRefreshDelayTime.count - 1) {
                fps = framePerSecondChoices[i]
                var indexOfold:Int = 0, indexOfnew:Int = 1
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
        return (fps, order)
    }
}

// Use a proxy object to break the CADisplayLink retain cycle
fileprivate class myDisplayLinkProxyObject {
    weak var myListener:AImageView?
    init(listener: AImageView) {
        myListener = listener
    }
    @objc func proxyUpdateAnimation(link: CADisplayLink) {
        myListener?.timerFired()
    }
}
