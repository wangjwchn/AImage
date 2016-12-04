//
//  AImageView.swift
//  AImage
//
//  Created by wangjwchn on 16/3/14.
//  Copyright © 2016 JW. All rights reserved.
//

import ImageIO
import UIKit
let _imageviewStorageKey = malloc(8)
let defaultMemoryLimit = 20
let shouldCacheImmediatelyOptions = [kCGImageSourceShouldCacheImmediately as String : true as NSNumber] as CFDictionary

public extension UIImageView{
    
    public convenience init(AImage:UIImage, MemoryLimit_MB:Int = defaultMemoryLimit) {
        self.init()
        setAImage(AImage,MemoryLimit_MB: MemoryLimit_MB)
    }
    
    
    public func setAImage(_ AImage:UIImage, MemoryLimit_MB:Int = defaultMemoryLimit) {
        self.m_ = imageview_storage()
        self.m_!.aImage = AImage
        self.m_!.displayOrderIndex = 0
        self.m_!.needToPlay = false;
        self.m_!.timer = nil;
        self.m_!.currentImage = UIImage(cgImage: CGImageSourceCreateImageAtIndex(self.getAImage().getImageSource(),0,nil)!)
        if (self.getAImage().getImageSize()>=MemoryLimit_MB) {
            self.m_!.timer = CADisplayLink(target: self, selector: #selector(UIImageView.updateFrameWithoutCache))
        } else {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                self.prepareCache()
            }
            self.m_!.timer = CADisplayLink(target: self, selector: #selector(UIImageView.updateFrameWithCache))
        }
        
        self.m_!.timer!.frameInterval = self.getAImage().getRefreshFactor()
        self.m_!.timer!.add(to: .main, forMode: RunLoopMode.commonModes)
    }
    
    
    public func APlay() {
        self.m_!.needToPlay = true;
    }
    
    public func AStop() {
        self.m_!.needToPlay = false;
    }
    
    public func getPlayJudge() -> Bool { return m_!.needToPlay! }
    public func getTimer() -> CADisplayLink { return m_!.timer! }
    public func getAImage() -> UIImage { return m_!.aImage! }
    public func getDisplayOrderIndex() -> Int{ return m_!.displayOrderIndex! }
    public func getCurrentImage() -> UIImage{ return m_!.currentImage! }
    public func getImageCache() -> NSCache<AnyObject, AnyObject> { return m_!.cache! }
    
    func prepareCache() {
        self.m_!.cache = NSCache()
        for i in 0..<self.getAImage().getDisplayOrder().count {
            let image = UIImage(cgImage: CGImageSourceCreateImageAtIndex(self.getAImage().getImageSource(),self.getAImage().getDisplayOrder()[i],shouldCacheImmediatelyOptions)!)
            self.getImageCache().setObject(image,forKey:i as NSNumber)
        }
    }
    
    //bound to 'displayLink'
    func updateFrameWithoutCache() {
        if(self.getPlayJudge() == true){
            self.image = self.getCurrentImage()
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                self.m_!.currentImage = UIImage(cgImage: CGImageSourceCreateImageAtIndex(self.getAImage().getImageSource(),self.getAImage().getDisplayOrder()[self.getDisplayOrderIndex()],shouldCacheImmediatelyOptions)!)
                self.m_!.displayOrderIndex = (self.getDisplayOrderIndex()+1)%self.getAImage().getImageNumber()
            }
        }
    }
    
    //bound to 'displayLink'
    func updateFrameWithCache() {
        if(self.getPlayJudge() == true){
            self.image = self.getImageCache().object(forKey: self.getDisplayOrderIndex() as AnyObject) as? UIImage
            self.m_!.displayOrderIndex = (self.getDisplayOrderIndex()+1)%self.getAImage().getImageNumber()
        }
    }
    
    private var m_:imageview_storage? {
        get {
            return (objc_getAssociatedObject(self, _imageviewStorageKey) as! imageview_storage)
        }
        set {
            objc_setAssociatedObject(self, _imageviewStorageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
}

fileprivate class imageview_storage {
    var needToPlay:Bool?
    var timer:CADisplayLink?
    var aImage:UIImage?
    var displayOrderIndex:Int?
    var currentImage:UIImage?
    var cache:NSCache<AnyObject, AnyObject>?
}

