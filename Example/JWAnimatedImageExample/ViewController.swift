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
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageData = NSData(contentsOfURL:NSBundle.mainBundle().URLForResource("test", withExtension: "gif")!)
        
        
        
        let manager = JWAnimationManager(memoryLimit:20)
        
        for i in 0..<10{
        let image = UIImage()
        image.AddGifFromData(imageData!)
        let imageview = UIImageView()
        imageview.AddGifImage(image,manager:manager)
        imageview.frame = CGRect(x: 0.0, y: 50.0+56.0*Double(i), width: 100.0, height: 56.0)
        view.addSubview(imageview)
        }
        
        for i in 0..<10{
            let image = UIImage()
            image.AddGifFromData(imageData!)
            let imageview = UIImageView()
            imageview.AddGifImage(image,manager:manager)
            imageview.frame = CGRect(x: 100.0, y: 50.0+56.0*Double(i), width: 100.0, height: 56.0)
            view.addSubview(imageview)
        }
        
        for i in 0..<10{
            let image = UIImage()
            image.AddGifFromData(imageData!)
            let imageview = UIImageView()
            imageview.AddGifImage(image,manager:manager)
            imageview.frame = CGRect(x: 200.0, y: 50.0+56.0*Double(i), width: 100.0, height: 56.0)
            view.addSubview(imageview)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
