//
//  AImage.swift
//  AImage
//
//  Created by wangjwchn on 16/8/22.
//  Copyright © 2016 JW. All rights reserved.
//

import ImageIO
import UIKit

let DEFAULT_CLARITY:Float = 0.8
let FLOAT_EPS:Float = 1E-6
let CHECK_INTERVAL = [60,30,20,15,12,10,6,5,4,3,2,1]
let GIF_ID = "GIF"
let APNG_ID = "PNG"

let _imageStorageKey = malloc(8)
public extension UIImage
{
    
    public convenience init(AImageData:NSData, Clarity:Float = DEFAULT_CLARITY){
        self.init()
        AddAImage(AImageData,Clarity: Clarity)
    }
    
    public func AddAImage(AImageData:NSData,Clarity:Float = DEFAULT_CLARITY){
        self.m_ = image_storage()
        m_!.imageSource = CGImageSourceCreateWithData(AImageData, nil)
        if(Clarity<=0||Clarity>1){
            print("Warning.Illegal input parameter 'Clarity',request >0&&<=1.Using default clarity.")
            CalculateFrameDelay(CalcuDelayTimes(m_!.imageSource),Clarity: DEFAULT_CLARITY)
        }else{
            CalculateFrameDelay(CalcuDelayTimes(m_!.imageSource),Clarity: Clarity)
        }
        CalculateFrameSize()
    }
    
    public func GetImageSource()->CGImageSource{return m_!.imageSource!}
    
    public func GetRefreshFactor()->Int{return m_!.displayRefreshFactor!}
    
    public func GetImageSize()->Int{return m_!.imageSize!}
    
    public func GetImageNumber()->Int{return m_!.imageCount!}
    
    public func GetDisplayOrder()->[Int]{return m_!.displayOrder!}
    
    
    private func CalcuDelayTimes(imageSource:CGImageSource?)->[Float]{
        
        
        let imageCount = CGImageSourceGetCount(imageSource!)
        
        var imageProperties = [CFDictionary]()
        for i in 0..<imageCount{
            imageProperties.append(CGImageSourceCopyPropertiesAtIndex(imageSource!, i, nil)!)
        }
        
        var frameProperties = [CFDictionary]()
     if(CFDictionaryContainsKey(imageProperties[1],unsafeAddressOf("{GIF}"))){
            frameProperties = imageProperties.map(){
                unsafeBitCast(CFDictionaryGetValue($0,unsafeAddressOf("{GIF}")),CFDictionary.self)
            }//gif
        }
        else if(CFDictionaryContainsKey(imageProperties[1],unsafeAddressOf("{PNG}"))){
            frameProperties = imageProperties.map(){
            unsafeBitCast(CFDictionaryGetValue($0,unsafeAddressOf("{PNG}")),CFDictionary.self)
            }//apng
        }
        else{
            fatalError("Illegal image type.")
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
    
    private func CalculateFrameDelay(delaysArray:[Float],Clarity:Float){
        
        var delays = delaysArray
        
        let maxFramePerSecond = CHECK_INTERVAL.first
        
        //frame numbers per second
        let displayRefreshRates = CHECK_INTERVAL.map{maxFramePerSecond!/$0}
        
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
            
            if(Float(framelosecount) <= Float(displayPosition.count) * (1.0 - Clarity)||i==displayRefreshDelayTime.count-1){
                
                m_!.imageCount = displayPosition.last!
                m_!.displayRefreshFactor = CHECK_INTERVAL[i]
                m_!.displayOrder = [Int]()
                var indexOfold = 0, indexOfnew = 1
                while(indexOfnew<=m_!.imageCount){
                    if(indexOfnew <= displayPosition[indexOfold]){
                        m_!.displayOrder!.append(indexOfold)
                        indexOfnew += 1
                    }else{indexOfold += 1}
                }
                break
            }
        }
    }
    
    private func CalculateFrameSize(){
        let image = UIImage(CGImage: CGImageSourceCreateImageAtIndex(m_!.imageSource!,0,nil)!)
        m_!.imageSize = Int(image.size.height*image.size.width*4)*m_!.imageCount!/(1000*1000)
    }
    
    private var m_:image_storage?{
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
