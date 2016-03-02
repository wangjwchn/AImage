//
//  JWAnimatedImageView
//
//  Created by wangjwchn(王佳玮) on 16/2/21.
//  Copyright © 2016年 jw. All rights reserved.
//

import ImageIO
import UIKit

public class JWAnimatedImageView:UIImageView
{

    /*levelOfIntegrity and memoryLimit be modified before call 'addGifImage'*/

    public var levelOfIntegrity:Float = 0.8
    /*
    The level of integrity of a gif image,The range is 0%(0)~100%(1).we know that CADisplayLink.frameInterval affact the display frames per second,if it is larger, we will only dispaly fewer frames per second,in the other way,we will never display some of frames all the time.So,the level of integrity gives us a limit that the device should show how many frames at least.If it is 100%(1),that means the device displays frames as much as it can.The default number is 0.8,but you can decrease it for a less cpu usage.Default is 0.8
    */
    
    public var memoryLimit:Int = 20     //default(MB)
    /*
    When the program is running,it use a strategy called 'cache or nothing'.When all frames can be put into the cache under the 'memoryLimit' restriction,it will put them all .Otherwise, we will not make any cache.After a lot of comparison,(such as,only cache part of frames,or use 'double swap memory',like the swap buffer when  render layers),I think it is the best way.
    */
    
    
    //The main function
    public func addGifImage(data:NSData){
        
        self.imageSource = CGImageSourceCreateWithData(data, nil)
        
        CalculateFrameDelay(GetDelayTimes())
        CalculateFrameSize()
        
        if(self.totalFrameSize>=memoryLimit){
            self.displayLink = CADisplayLink(target: self, selector: Selector("updateFrameWithoutCache"))
        }else{
            dispatch_async(queue,prepareCache)
            self.displayLink = CADisplayLink(target: self, selector: Selector("updateFrameWithCache"))
        }
        self.displayLink!.frameInterval = self.displayRefreshFactors
        self.displayLink!.addToRunLoop(.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    //obtained from NSData
    private var imageSource: CGImageSourceRef?
    private var totalFrameSize = 0                   //(MB)
    
    //bound to functions 'updateFrame'
    private var displayLink: CADisplayLink?
    
    //has connecttion with CADisplayLink.frameInterval
    private var displayRefreshFactors = 1           //initial
    
    //indexs of frames choosed from imageSource and
    private var displayOrder = [Int]()
    
    //total number of processed frames
    private var imageCount = 0                      //initial

    //dispatch queue
    private let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)
    
    
    
    //the current index of frames when display the processed frames
    private var displayOrderIndex = 0               //initial

    //image that will be displayed next,used by no-cache mode
    private var currentImage:UIImage?
    
    //used by cache mode
    private lazy var cache = NSCache()
    
    //bound to 'displayLink'
    func updateFrameWithoutCache(){
        image = self.currentImage
        dispatch_async(queue){
            self.currentImage = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.imageSource!,self.displayOrder[self.displayOrderIndex],nil)!)
            self.displayOrderIndex = (self.displayOrderIndex+1)%self.imageCount
        }
    }
    
    //bound to 'displayLink'
    func updateFrameWithCache(){
        image = cache.objectForKey(self.displayOrderIndex) as? UIImage
        self.displayOrderIndex = (self.displayOrderIndex+1)%self.imageCount
    }
    
    //load frames to cache
    private func prepareCache(){
        for i in 0..<self.displayOrder.count {
            let image = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.imageSource!,self.displayOrder[i],nil)!)
            self.cache.setObject(image,forKey:i)
        }
    }
    
    //estimate size of all processed frames
    private func CalculateFrameSize(){
        let image = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.imageSource!,0,nil)!)
        self.totalFrameSize = Int(image.size.height*image.size.width*4)*self.imageCount/1000000
    }
    
    private func GetDelayTimes()->[Float]{
        
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
    
    private func CalculateFrameDelay(var delays:[Float])
    {
        
        //Factors send to CADisplayLink.frameInterval
        let displayRefreshFactors = [60,30,20,15,12,10,6,5,4,3,2,1,]
        
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
                {++framelosecount}
            }
            
            if(Float(framelosecount) <= Float(displayPosition.count) * (1.0 - self.levelOfIntegrity)||i==displayRefreshDelayTime.count-1){
                
                self.imageCount = displayPosition.last!
                self.displayRefreshFactors = displayRefreshFactors[i]
                
                var indexOfold = 0, indexOfnew = 1
                while(indexOfnew<=self.imageCount){
                    if(indexOfnew <= displayPosition[indexOfold]){
                        self.displayOrder.append(indexOfold)
                        ++indexOfnew
                    }else{++indexOfold}
                }
                break;
            }
        }
    }
}