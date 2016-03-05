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
        
        //one GIF image
        let imageView = JWAnimatedImageView()
        imageView.addGifImage(imageData!)
        imageView.frame = CGRect(x: 7.0, y: 50.0, width: 400.0, height: 224.0)
        view.addSubview(imageView)
        
        //30 GIF images
        /*
        for i in 0..<3 {
            for j in 0..<10 {
                let imageView = JWAnimatedImageView()
                imageView.addGifImage(imageData!)
                imageView.frame = CGRect(x: 0.0+Double(100*i), y:50.0+Double(56*j), width: 100.0, height: 56.0)
                view.addSubview(imageView)
            }
        }
    */
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
