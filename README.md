

# JWAnimatedImage
[![Language](https://img.shields.io/badge/swift-2.2-orange.svg)](http://swift.org)
[![Build Status](https://travis-ci.org/wangjwchn/JWAnimatedImage.svg?branch=master)](https://travis-ci.org/wangjwchn/JWAnimatedImage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JWAnimatedImage.svg)](https://img.shields.io/cocoapods/v/JWAnimatedImage.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Pod License](http://img.shields.io/cocoapods/l/SDWebImage.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)

An animated GIF engine for iOS in Swift with low memory & cpu usage.

![video](http://i.imgur.com/XOoq9mP.gif)

##Features
- [x] Optimized for Multi-Image case.[New]
- [x] As UIImage and UIImageView extension,easy to use.
- [x] Have a great performance on memory usage by using producer/consumer pattern.
- [x] Have a great performance on CPU usage by using asynchronous loading.
- [x] Allow to control display quality by using factor 'level of Integrity'
- [x] Allow to control memory usage by using factor 'memoryLimit'

##Installation
######With CocoaPods
```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
pod 'JWAnimatedImage'
```
######With Carthage
```ruby
github "wangjwchn/JWAnimatedImage"
```
##How to Use
```swift
let url = NSBundle.mainBundle().URLForResource(“imagename”, withExtension: "gif")!
let imageData = NSData(contentsOfURL:url)
let image = UIImage()
image.AddGifFromData(imageData!)
let gifmanager = JWAnimationManager(memoryLimit:20)
let imageview = UIImageView()
imageview.AddGifImage(image,manager:gifmanager)
imageview.frame = CGRect(x: 0.0, y: 5.0, width: 400.0, height: 200.0)
view.addSubview(imageview)
```
##Architecture
![Architecture](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/Architecture.png)

##Benchmark:
####Compared with [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage) and [SwiftGif](https://github.com/bahlo/SwiftGif)
Last updated: March 26, 2016
Measurement device: iPhone6 with iOS 9.3
Measurement tool: Profile in Xcode 7.3
Measurement image: See it in repository, all the parameters are default.

####1.Single-Image Display

####1.1 CPU usage:
######JWAnimatedImage
![JW_CPU](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/JW_CPU1.png)
######FLAnimatedImage
![FL_CPU](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/FL_CPU1.png)
######SwiftGif
![SG_CPU](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/SG_CPU.png)

####1.2 Memory usage: 
######JWAnimatedImage
![JW_MEM](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/JW_MEM1.png)
######FLAnimatedImage
![FL_MEM](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/FL_MEM1.png)
######SwiftGif
![SG_MEM](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/SG_MEM.png)

I've discussed the high memory usage of FLAnimatedImage with [@mitchellporter](https://github.com/mitchellporter) and confirmed this problem does exist，as described [here].(https://github.com/wangjwchn/JWAnimatedImage/issues/1).<br/>
From the graph, we can see that SwiftGif isn't processing the memory usage.

####2.Multi-Image Display
####2.1 CPU usage:
######JWAnimatedImage
![JW_CPU](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/JW_CPU2.png)
######FLAnimatedImage
![FL_CPU](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/FL_CPU2.png) 
###### ...... 
![FL_CPU](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/FL_CPU3.png) 

####2.2 Memory usage:
######JWAnimatedImage
![JW_MEM](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/JW_MEM2.png)
######FLAnimatedImage
![FL_MEM](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/FL_MEM2.png)

JWAnimatedImage fares better than FLAnimatedImage in both cpu and memory usage.
There is no benckmark for SwiftGif as it crashes immediately due to high memory usage.

For each image, FLAnimatedImage creates a new independent thread. From the graph, we can see there are 36 threads when loading 30 GIFs, which causes a heavy CPU usage.

JWAnimatedImage uses GCD global queue to handle these tasks. This solution decrease the number of threads down to 9, and those threads are dynamic.

##Licence
JWAnimatedImage is released under the MIT license. See [LICENSE](https://github.com/wangjwchn/JWAnimatedImage/raw/master/LICENSE) for details.
