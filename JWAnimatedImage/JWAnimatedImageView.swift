//
//  JWAnimatedImageView.swift
//  JWAnimatedImageExample
//
//  Created by 王佳玮 on 16/3/14.
//  Copyright © 2016年 JW. All rights reserved.
//

import ImageIO
import UIKit
let _gifImageKey = malloc(4)
let _cacheKey = malloc(4)
let _currentImageKey = malloc(4)
let _displayOrderIndexKey = malloc(4)
let _syncFactorKey = malloc(4)
let _haveCacheKey = malloc(4)
let _loopTimeKey = malloc(4)
public extension UIImageView{
    
    public func AddGifImage(gifImage:UIImage,manager:JWAnimationManager,loopTime:Int){
        self.loopTime = loopTime
        if (manager.SearchImageView(self)==false){
            self.gifImage = gifImage
            self.displayOrderIndex = 0
            self.syncFactor = 0
            self.currentImage = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.gifImage.imageSource!,0,nil)!)
            manager.AddImageView(self)
            self.haveCache = manager.haveCache
            if(self.haveCache==true){
                cache = NSCache()
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),prepareCache)
            }
        }
    }
    
    public func AddGifImage(gifImage:UIImage,manager:JWAnimationManager){
        // -1 means always run
        AddGifImage(gifImage,manager: manager,loopTime: -1);
    }
    
    public func changetoNOCacheMode(){
        self.cache.removeAllObjects()
        self.haveCache = false
    }
    
    public func changetoCacheMode(){
        self.cache = NSCache()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),prepareCache)
        self.haveCache = true
    }
    
    public func updateCurrentImage(){
        if(loopTime != 0){
        if(self.haveCache==false){              
                self.currentImage = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.gifImage.imageSource!,self.gifImage.displayOrder![self.displayOrderIndex],nil)!)
        }else{
            self.currentImage = (cache.objectForKey(self.displayOrderIndex) as? UIImage)!
        }
        updateIndex()
        }
    }
    
    private func updateIndex(){
        self.syncFactor = (self.syncFactor+1)%gifImage.displayRefreshFactor!
        if(self.syncFactor==0){
            self.displayOrderIndex = (self.displayOrderIndex+1)%self.gifImage.imageCount!
            if(displayOrderIndex==0){
                self.loopTime -= 1;
            }
        }
    }
    
    private func prepareCache(){
        for i in 0..<self.gifImage.displayOrder!.count {
            let image = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.gifImage.imageSource!,self.gifImage.displayOrder![i],nil)!)
            self.cache.setObject(image,forKey:i)
        }
    }
    
    public var gifImage:UIImage{
        get {
            return (objc_getAssociatedObject(self, _gifImageKey) as! UIImage)
        }
        set {
            objc_setAssociatedObject(self, _gifImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
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
    
    private var loopTime:Int{
        get {
            return (objc_getAssociatedObject(self, _loopTimeKey) as! Int)
        }
        set {
            objc_setAssociatedObject(self, _loopTimeKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
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
    
    private var cache:NSCache{
        get {
            return (objc_getAssociatedObject(self, _cacheKey) as! NSCache)
        }
        set {
            objc_setAssociatedObject(self, _cacheKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
}
