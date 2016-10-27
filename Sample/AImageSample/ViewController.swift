//
//  ViewController.swift
//  AImage
//
//  Created by Jiawei Wang on 03/04/2016.
//  Copyright (c) 2016 Jiawei Wang. All rights reserved.
//
import ImageIO
import UIKit
import AImage

class ViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* gif test */
        Demo1()
        
        /* apng test */
        //Demo2()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Demo1(){
         let imageData = NSData(contentsOfURL:NSBundle.mainBundle().URLForResource("test", withExtension: "gif")!)
        
        let image = UIImage(AImageData:imageData!)
        
        let imageview = UIImageView(AImage: image)
        imageview.frame = CGRect(x: 0.0, y: 50.0, width: 380.0, height: 212.0)
        view.addSubview(imageview)
        imageview.APlay();
        
    }
    func Demo2(){
         let imageData = NSData(contentsOfURL:NSBundle.mainBundle().URLForResource("test", withExtension: "apng")!)
        
        let image = UIImage(AImageData:imageData!)
        let imageview = UIImageView(AImage: image)
        imageview.frame = CGRect(x: 7.0, y: 50.0, width: 380.0, height: 212.0)
        view.addSubview(imageview)
        imageview.APlay();
    }
}
