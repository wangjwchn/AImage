//
//  ViewController.swift
//  JWGif
//
//  Created by 王佳玮 on 16/2/21.
//  Copyright © 2016年 jw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageData = NSData(contentsOfURL:NSBundle.mainBundle().URLForResource("test", withExtension: "gif")!)
        let imageView = JWAnimatedImageView()
        imageView.addGifImage(imageData!)
        imageView.frame = CGRect(x: 7.0, y: 50.0, width: 400.0, height: 224.0)
        view.addSubview(imageView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

