//
//  ViewController.swift
//  JWAnimatedImage
//
//  Created by Jiawei Wang on 03/04/2016.
//  Copyright (c) 2016 Jiawei Wang. All rights reserved.
//

import UIKit
import JWAnimatedImage

class ViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inits
        let images = ["img1", "img2", "img3"]
        let nbImages = images.count
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height  - 40
        
        // Manager
        let gifmanager = JWAnimationManager(memoryLimit:20)
        
        for index in 0...nbImages-1 {
            
            if let url = NSBundle.mainBundle().URLForResource(images[index], withExtension: "gif") {
                
                if let imageData = NSData(contentsOfURL:url) {

                    // Create animated image
                    let image = UIImage()
                    image.AddGifFromData(imageData)
                    
                    // Create ImageView and add animated image
                    let imageview = UIImageView()
                    imageview.AddGifImage(image, manager:gifmanager,loopTime: 50)
                    let imageHeight = (screenHeight / CGFloat(nbImages))
                    imageview.frame = CGRect(x: 0.0, y: 40 + CGFloat(index) * imageHeight, width: screenWidth, height: imageHeight)
                    self.view.addSubview(imageview)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
