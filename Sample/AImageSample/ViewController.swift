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
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        demoGif()
        demoApng()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func demoGif() {
         let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "test", withExtension: "gif")!)
        
        let image = UIImage(aImageData: imageData!)
        
        let imageview = UIImageView(AImage: image)
        imageview.frame = CGRect(x: 0.0, y: 50.0, width: 380.0, height: 212.0)
        view.addSubview(imageview)
        imageview.APlay();
        
    }
    func demoApng() {
         let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "test", withExtension: "apng")!)
        
        let image = UIImage(aImageData: imageData!)
        let imageview = UIImageView(AImage: image)
        imageview.frame = CGRect(x: 7.0, y: 50.0, width: 380.0, height: 212.0)
        view.addSubview(imageview)
        imageview.APlay();
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
