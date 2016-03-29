//
//  JWAnimatedImage.swift
//  JWAnimatedImage
//
//  Created by 王佳玮 on 16/3/14.
//  Copyright © 2016年 JW. All rights reserved.
//

import ImageIO
import UIKit

let _imageSourceKey = malloc(4)
let _displayRefreshFactorKey = malloc(4)
let _imageCountKey = malloc(4)
let _displayOrderKey = malloc(4)
let _imageSizeKey = malloc(4)
public extension UIImage{
    
    //The level of integrity of a gif image,The range is 0%(0)~100%(1).we know that CADisplayLink.frameInterval affact the display frames per second,if it is larger, we will only dispaly fewer frames per second,in the other way,we will never display some of frames all the time.So,the level of integrity gives us a limit that the device should show how many frames at least.If it is 100%(1),that means the device displays frames as much as it can.The default number is 0.8,but you can decrease it for a less cpu usage.Default is 0.8
    public convenience init(gifData:NSData){
        self.init()
        AddGifFromData(gifData,levelOfIntegrity: 0.8)
    }

    public convenience init(gifData:NSData, levelOfIntegrity:Float){
        self.init()
        AddGifFromData(gifData,levelOfIntegrity: levelOfIntegrity)
    }

    public func AddGifFromData(gif:NSData){
        AddGifFromData(gif,levelOfIntegrity: 0.8)
    }
    
    public func AddGifFromData(gif:NSData,levelOfIntegrity:Float){
        imageSource = CGImageSourceCreateWithData(gif, nil)
        CalculateFrameDelay(GetDelayTimes(imageSource),levelOfIntegrity: levelOfIntegrity)
        CalculateFrameSize()
    }
    
    public var imageSource:CGImageSource?{
        get {
            return (objc_getAssociatedObject(self, _imageSourceKey) as! CGImageSource)
        }
        set {
            objc_setAssociatedObject(self, _imageSourceKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    public var displayRefreshFactor:Int?{
        get {
            return (objc_getAssociatedObject(self, _displayRefreshFactorKey) as! Int)
        }
        set {
            objc_setAssociatedObject(self, _displayRefreshFactorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    public var imageSize:Int?{
        get {
            return (objc_getAssociatedObject(self, _imageSizeKey) as! Int)
        }
        set {
            objc_setAssociatedObject(self, _imageSizeKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    public var imageCount:Int?{
        get {
            return (objc_getAssociatedObject(self, _imageCountKey) as! Int)
        }
        set {
            objc_setAssociatedObject(self, _imageCountKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
  
    public var displayOrder:[Int]?{
        get {
            return (objc_getAssociatedObject(self, _displayOrderKey) as! [Int])
        }
        set {
            objc_setAssociatedObject(self, _displayOrderKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    private func GetDelayTimes(imageSource:CGImageSourceRef?)->[Float]{
        
        let imageCount = CGImageSourceGetCount(imageSource!)
        var imageProperties = [CFDictionary]()
        for i in 0..<imageCount{
            imageProperties.append(CGImageSourceCopyPropertiesAtIndex(imageSource!, i, nil)!)
        }
        
        let frameProperties = imageProperties.map(){
            unsafeBitCast(
                CFDictionaryGetValue($0,
                    unsafeAddressOf(kCGImagePropertyGIFDictionary)),CFDictionary.self)
        }
        
        let EPS:Float = 1e-6
        let frameDelays:[Float] = frameProperties.map(){
            var delayObject: AnyObject = unsafeBitCast(
                CFDictionaryGetValue($0,
                    unsafeAddressOf(kCGImagePropertyGIFUnclampedDelayTime)),
                AnyObject.self)
            
            if(delayObject.floatValue<EPS){
                delayObject = unsafeBitCast(CFDictionaryGetValue($0,
                    unsafeAddressOf(kCGImagePropertyGIFDelayTime)), AnyObject.self)
            }
            return delayObject as! Float
        }
        return frameDelays
    }
    
    private func CalculateFrameDelay(delaysArray:[Float],levelOfIntegrity:Float){
        
        var delays = delaysArray
        
        //Factors send to CADisplayLink.frameInterval
        let displayRefreshFactors = [60,30,20,15,12,10,6,5,4,3,2,1]
        
        //maxFramePerSecond,default is 60
        let maxFramePerSecond = displayRefreshFactors.first
        
        //frame numbers per second
        let displayRefreshRates = displayRefreshFactors.map{maxFramePerSecond!/$0}
        
        //time interval per frame
        let displayRefreshDelayTime = displayRefreshRates.map{1.0/Float($0)}
        
        //caclulate the time when eash frame should be displayed at(start at 0)
        for i in 1..<delays.count{ delays[i]+=delays[i-1] }
        
        //find the appropriate Factors then BREAK
        for i in 0..<displayRefreshDelayTime.count{
            
            let displayPosition = delays.map{Int($0/displayRefreshDelayTime[i])}
            
            var framelosecount = 0
            for j in 1..<displayPosition.count{
                if(displayPosition[j] == displayPosition[j-1])
                {framelosecount += 1}
            }
            
            if(Float(framelosecount) <= Float(displayPosition.count) * (1.0 - levelOfIntegrity)||i==displayRefreshDelayTime.count-1){
                
                self.imageCount = displayPosition.last!
                self.displayRefreshFactor = displayRefreshFactors[i]
                self.displayOrder = [Int]()
                var indexOfold = 0, indexOfnew = 1
                while(indexOfnew<=imageCount){
                    if(indexOfnew <= displayPosition[indexOfold]){
                        self.displayOrder!.append(indexOfold)
                        indexOfnew += 1
                    }else{indexOfold += 1}
                }
                break
            }
        }
    }
    private func CalculateFrameSize(){
        let image = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.imageSource!,0,nil)!)
        self.imageSize = Int(image.size.height*image.size.width*4)*self.imageCount!/1000000
    }
}
