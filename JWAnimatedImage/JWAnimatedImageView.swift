//
//  JWAnimatedImageView.swift
//  JWAnimatedImageExample
//
//  Created by 王佳玮 on 16/3/14.
//  Copyright © 2016年 JW. All rights reserved.
//

import ImageIO
import UIKit
let _animatedImageKey = malloc(4)
let _cacheKey = malloc(4)
let _currentImageKey = malloc(4)
let _displayOrderIndexKey = malloc(4)
let _syncFactorKey = malloc(4)
let _haveCacheKey = malloc(4)
let _loopTimeKey = malloc(4)
let _displayingKey = malloc(4)
let _animationManagerKey = malloc(4)

let _sameFrameCheckKey = malloc(4)//

public extension UIImageView{
    
    public convenience init(animatedImage:UIImage,manager:JWAnimationManager){
        self.init()
        SetAnimatedImage(animatedImage,manager: manager,loopTime: -1);
    }
    
    public convenience init(animatedImage:UIImage,manager:JWAnimationManager,loopTime:Int){
        self.init()
        SetAnimatedImage(animatedImage,manager: manager,loopTime: loopTime);
    }
    
    public func SetAnimatedImage(animatedImage:UIImage,manager:JWAnimationManager){
        // -1 means always run
        SetAnimatedImage(animatedImage,manager: manager,loopTime: -1);
    }
    
    public func SetAnimatedImage(animatedImage:UIImage,manager:JWAnimationManager,loopTime:Int){
        self.loopTime = loopTime
        self.animatedImage = animatedImage
        self.animationManager = manager
        self.syncFactor = 0
        self.displayOrderIndex = 0
        self.cache = NSCache()
        self.sameFrameCheck = false
        self.haveCache = false
        self.currentImage = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.animatedImage.imageSource!,0,[(kCGImageSourceShouldCacheImmediately as String): true])!)
        
        if !manager.SearchImageView(self){
            manager.AddImageView(self)
            StartDisplay()
        }
    }
    
    public func StartDisplay(){
        self.displaying = true
        CheckCache()
    }
    
    public func StopDisplay(){
        self.displaying = false
        CheckCache()
    }
    
    public func CheckCache(){
        if(self.animationManager.CheckForCache(self)==true && self.haveCache==false){
            prepareCache()
            self.haveCache = true
        }
        else if(self.animationManager.CheckForCache(self)==false && self.haveCache==true){
            self.cache.removeAllObjects()
            self.haveCache = false
        }
    }
    
    public func updateCurrentImage(){
        if(self.displaying == true){
            if(self.sameFrameCheck == false){
            updateFrame()
            }
            updateIndex()
            if(loopTime == 0 || isDisplayedInScreen(self)==false){
                StopDisplay()
            }
        }else{
            if(isDisplayedInScreen(self) == true){
                StartDisplay()
            }
            if(isDiscarded(self)==true){
                self.animationManager.DeleteImageView(self)
            }
        }
    }
    
    public func updateFrame(){
        if(self.haveCache==false){
            self.currentImage = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.animatedImage.imageSource!,self.animatedImage.displayOrder![self.displayOrderIndex],[(kCGImageSourceShouldCacheImmediately as String): true])!)
        }else{
            if let image = (cache.objectForKey(self.displayOrderIndex) as? UIImage){
                self.currentImage = image
            }else{
                self.currentImage = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.animatedImage.imageSource!,self.animatedImage.displayOrder![self.displayOrderIndex],[(kCGImageSourceShouldCache as String): false])!)
            }//prevent case that cache is not ready
        }
    }
    
    public func isDiscarded(imageView:UIView?) -> Bool{
        if(imageView == nil || imageView!.superview == nil){
            return true
        }
        return false
    }
    
    
    public func isDisplayedInScreen(imageView:UIView?) ->Bool{
        if (self.hidden) {
            return false
        }
        
        let screenRect = UIScreen.mainScreen().bounds
        let viewRect = imageView!.convertRect(self.frame,toView:UIApplication.sharedApplication().keyWindow)
        
        let intersectionRect = CGRectIntersection(viewRect, screenRect);
        if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
            return false
        }
        return true
    }
    
    private func updateIndex(){
        self.syncFactor = (self.syncFactor+1)%self.animatedImage.displayRefreshFactor!
        if(self.syncFactor==0){
            let displayOrderIndexNext = (self.displayOrderIndex+1)%self.animatedImage.imageCount!
             if(self.animatedImage.displayOrder![displayOrderIndexNext] == self.animatedImage.displayOrder![self.displayOrderIndex]){
             self.sameFrameCheck = true
             }else{
             self.sameFrameCheck = false
             }
            self.displayOrderIndex = displayOrderIndexNext
            if(displayOrderIndex==0){
                self.loopTime -= 1;
            }
        }
    }
    
    private func prepareCache(){
        self.cache.removeAllObjects()
        for i in 0..<self.animatedImage.displayOrder!.count {
            let image = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.animatedImage.imageSource!,self.animatedImage.displayOrder![i],[(kCGImageSourceShouldCacheImmediately as String): true])!)
            self.cache.setObject(image,forKey:i)
        }
    }
    
    public var animatedImage:UIImage{
        get {
            return (objc_getAssociatedObject(self, _animatedImageKey) as! UIImage)
        }
        set {
            objc_setAssociatedObject(self, _animatedImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    public var currentImage:UIImage{
        get {
            return (objc_getAssociatedObject(self, _currentImageKey) as! UIImage)
        }
        set {
            objc_setAssociatedObject(self, _currentImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    private var displayOrderIndex:Int{
        get {
            return (objc_getAssociatedObject(self, _displayOrderIndexKey) as! Int)
        }
        set {
            objc_setAssociatedObject(self, _displayOrderIndexKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    private var syncFactor:Int{
        get {
            return (objc_getAssociatedObject(self, _syncFactorKey) as! Int)
        }
        set {
            objc_setAssociatedObject(self, _syncFactorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    public var loopTime:Int{
        get {
            return (objc_getAssociatedObject(self, _loopTimeKey) as! Int)
        }
        set {
            objc_setAssociatedObject(self, _loopTimeKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    public var animationManager:JWAnimationManager{
        get {
            return (objc_getAssociatedObject(self, _animationManagerKey) as! JWAnimationManager)
        }
        set {
            objc_setAssociatedObject(self, _animationManagerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    private var haveCache:Bool{
        get {
            return (objc_getAssociatedObject(self, _haveCacheKey) as! Bool)
        }
        set {
            objc_setAssociatedObject(self, _haveCacheKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    public var displaying:Bool{
        get {
            return (objc_getAssociatedObject(self, _displayingKey) as! Bool)
        }
        set {
            objc_setAssociatedObject(self, _displayingKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    private var cache:NSCache{
        get {
            return (objc_getAssociatedObject(self, _cacheKey) as! NSCache)
        }
        set {
            objc_setAssociatedObject(self, _cacheKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    private var sameFrameCheck:Bool{
        get {
            return (objc_getAssociatedObject(self, _sameFrameCheckKey) as! Bool)
        }
        set {
            objc_setAssociatedObject(self, _sameFrameCheckKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }

}
