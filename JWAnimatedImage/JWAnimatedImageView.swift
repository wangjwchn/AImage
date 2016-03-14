//
//  JWAnimatedImageView.swift
//  JWAnimatedImageExample
//
//  Created by 王佳玮 on 16/3/14.
//  Copyright © 2016年 JW. All rights reserved.
//

import ImageIO
import UIKit

let _timerKey = malloc(4)
let _gifImageKey = malloc(4)
let _cacheKey = malloc(4)
let _currentImageKey = malloc(4)
let _displayOrderIndexKey = malloc(4)
public extension UIImageView{
    
    //When the program is running,it use a strategy called 'cache or nothing'.When all frames can be put into the cache under the 'memoryLimit' restriction,it will put them all .Otherwise, we will not make any cache.After a lot of comparison,(such as,only cache part of frames,or use 'double swap memory',like the swap buffer when  render layers),I think it is the best way.
    public func AddGifImage(gifImage:UIImage){
        AddGifImage(gifImage,memoryLimit: 20)
    }
    
    public func AddGifImage(gifImage:UIImage,memoryLimit:Int){
        self.gifImage = gifImage
        self.displayOrderIndex = 0
        self.currentImage = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.gifImage.imageSource!,0,nil)!)
        if(self.gifImage.imageSize>=memoryLimit){
            self.timer = CADisplayLink(target: self, selector: Selector("updateFrameWithoutCache"))
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),prepareCache)
            self.timer = CADisplayLink(target: self, selector: Selector("updateFrameWithCache"))
        }
        timer!.frameInterval = gifImage.displayRefreshFactor!
        timer!.addToRunLoop(.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }

    var timer:CADisplayLink?{
        get {
            return (objc_getAssociatedObject(self, _timerKey) as! CADisplayLink)
        }
        set {
            objc_setAssociatedObject(self, _timerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    var gifImage:UIImage{
        get {
            return (objc_getAssociatedObject(self, _gifImageKey) as! UIImage)
        }
        set {
            objc_setAssociatedObject(self, _gifImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    var displayOrderIndex:Int{
        get {
            return (objc_getAssociatedObject(self, _displayOrderIndexKey) as! Int)
        }
        set {
            objc_setAssociatedObject(self, _displayOrderIndexKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    var currentImage:UIImage{
        get {
            return (objc_getAssociatedObject(self, _currentImageKey) as! UIImage)
        }
        set {
            objc_setAssociatedObject(self, _currentImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    var cache:NSCache{
        get {
            return (objc_getAssociatedObject(self, _cacheKey) as! NSCache)
        }
        set {
            objc_setAssociatedObject(self, _cacheKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    func prepareCache(){
        for i in 0..<self.gifImage.displayOrder!.count {
            let image = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.gifImage.imageSource!,self.gifImage.displayOrder![i],nil)!)
            self.cache.setObject(image,forKey:i)
        }
    }
    //bound to 'displayLink'
    func updateFrameWithoutCache(){
        dispatch_async(dispatch_get_main_queue()){
            self.image = self.currentImage
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)){
            self.currentImage = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.gifImage.imageSource!,self.gifImage.displayOrder![self.displayOrderIndex],nil)!)
            self.displayOrderIndex = (self.displayOrderIndex+1)%self.gifImage.imageCount!
        }
    }
    
    //bound to 'displayLink'
    func updateFrameWithCache(){
        image = cache.objectForKey(self.displayOrderIndex) as? UIImage
        self.displayOrderIndex = (self.displayOrderIndex+1)%self.gifImage.imageCount!
    }
}