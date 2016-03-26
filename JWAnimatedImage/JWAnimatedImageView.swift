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
let _cacheModeKey = malloc(4)
public extension UIImageView{
    
    public func AddGifImage(gifImage:UIImage,manager:JWAnimationManager){
        manager.DeleteImageView(self)
        self.gifImage = gifImage
        self.displayOrderIndex = 0
        self.syncFactor = 0
        self.currentImage = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.gifImage.imageSource!,0,nil)!)
        manager.AddImageView(self)
        self.cacheMode = manager.cacheMode
        if(self.cacheMode==1){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),prepareCache)
        }
    
    }
    
    public func changetoNOCacheMode(){
        //TBC
    }
    public func changetoCacheMode(){
        //TBC
    }
    
    public func updateCurrentImage(){
        if(self.cacheMode==0){              //no cache
                self.currentImage = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.gifImage.imageSource!,self.gifImage.displayOrder![self.displayOrderIndex],nil)!)
        }else{
            image = cache.objectForKey(self.displayOrderIndex) as? UIImage
        }
        updateIndex()
    }
    
    public func updateIndex(){
        self.syncFactor = (self.syncFactor+1)%gifImage.displayRefreshFactor!
        if(self.syncFactor==0){
            self.displayOrderIndex = (self.displayOrderIndex+1)%self.gifImage.imageCount!
        }
    }
    
    func prepareCache(){
        for i in 0..<self.gifImage.displayOrder!.count {
            let image = UIImage(CGImage: CGImageSourceCreateImageAtIndex(self.gifImage.imageSource!,self.gifImage.displayOrder![i],nil)!)
            self.cache.setObject(image,forKey:i)
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
    
    var syncFactor:Int{
        get {
            return (objc_getAssociatedObject(self, _syncFactorKey) as! Int)
        }
        set {
            objc_setAssociatedObject(self, _syncFactorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }

    var cacheMode:Int{
        get {
            return (objc_getAssociatedObject(self, _cacheModeKey) as! Int)
        }
        set {
            objc_setAssociatedObject(self, _cacheModeKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
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
}
