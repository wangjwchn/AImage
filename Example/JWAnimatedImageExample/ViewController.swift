//
//  ViewController.swift
//  JWAnimatedImage
//
//  Created by Jiawei Wang on 03/04/2016.
//  Copyright (c) 2016 Jiawei Wang. All rights reserved.
//
import ImageIO
import UIKit
import JWAnimatedImage

class ViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* gif test */
        //Demo1()
        
        /* apng test */
        Demo2()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Demo1(){
        let manager = JWAnimationManager(memoryLimit:20)
        
        let imageData = NSData(contentsOfURL:NSBundle.mainBundle().URLForResource("test", withExtension: "gif")!)
        
        let image = UIImage(animatedImage:imageData!)
        let imageview = UIImageView(animatedImage: image, manager:manager,loopTime: -1)
        imageview.frame = CGRect(x: 7.0, y: 50.0, width: 400.0, height: 224.0)
        view.addSubview(imageview)
    }
    func Demo2(){
        let manager = JWAnimationManager(memoryLimit:2000)
        
        let imageData = NSData(contentsOfURL:NSBundle.mainBundle().URLForResource("test", withExtension: "apng")!)
        
        let image = UIImage(animatedImage:imageData!)
        let imageview = UIImageView(animatedImage: image, manager:manager,loopTime: -1)
        imageview.frame = CGRect(x: 7.0, y: 50.0, width: 400.0, height: 224.0)
        view.addSubview(imageview)
    }
}
