//
//  JWAnimatedImageViewCore.swift
//  JWAnimatedImage
//
//  Created by 王佳玮 on 16/3/26.
//  Copyright © 2016年 JW. All rights reserved.
//
import ImageIO
import UIKit
import Foundation
public class JWAnimationManager{
    
    //When the program is running,it use a strategy called 'cache or nothing'.When all frames can be put into the cache under the 'memoryLimit' restriction,it will put them all .Otherwise, we will not make any cache.After a lot of comparison,(such as,only cache part of frames,or use 'double swap memory',like the swap buffer when  render layers),I think it is the best way.
    
    private var timer:CADisplayLink?
    private var displayViews:[UIImageView] = []
    private var totalGifSize:Int
    private var memoryLimit:Int
    public var cacheMode:Int    //0:nocache 1:cache
    public func AddImageView(imageView:UIImageView){
        self.totalGifSize+=imageView.gifImage.imageSize!
        if(self.totalGifSize>memoryLimit&&self.cacheMode==1){
            self.cacheMode = 0
            for imageView in self.displayViews{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)){
                    imageView.changetoNOCacheMode()
                }
            }
        }
        self.displayViews.append(imageView)

    }
    
    public func DeleteImageView(imageView:UIImageView){
        if let index = self.displayViews.indexOf(imageView){
            self.totalGifSize-=imageView.gifImage.imageSize!
            if(self.totalGifSize>memoryLimit&&self.cacheMode==0){
                self.cacheMode = 1
                for imageView in self.displayViews{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)){
                        imageView.changetoCacheMode()
                    }
                }
            }
            self.displayViews.removeAtIndex(index)
        }
    }
    
    public func SearchView(imageView:UIImageView) ->Bool{
        return self.displayViews.contains(imageView)
    }
    
    public init(memoryLimit:Int){
        self.memoryLimit = memoryLimit
        self.totalGifSize = 0
        self.cacheMode = 1
        self.timer = CADisplayLink(target: self, selector: #selector(self.updateViews))
        self.timer!.addToRunLoop(.mainRunLoop(), forMode: NSRunLoopCommonModes)
        
    }
    
    @objc func updateViews(){
        for imageView in self.displayViews{
            dispatch_async(dispatch_get_main_queue()){
            imageView.image = imageView.currentImage
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)){
                imageView.updateCurrentImage()
            }
        }
    }
    
}