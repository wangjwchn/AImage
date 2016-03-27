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

##Benchmark:Compared with [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage)
###1.Display 1 Image
|               |CPU Usage[average] |Memory Usage[average]/MB |
|:-------------:|:-----------------:|:-----------------------:|
|JWAnimatedImage|6% ~ 14% [8%]      |7.5 ~ 8.4 [8.2]          |
|FLAnimatedImage|8% ~ 24% [11%]     |7.3 ~ ??? [???]          |

###2.Display 3 Images
|               |CPU Usage[average] |Memory Usage[average]/MB |
|:-------------:|:-----------------:|:-----------------------:|
|JWAnimatedImage|31% ~ 44% [38%]    |12.4 ~ 13.4 [12.9]       |
|FLAnimatedImage|36% ~ 62% [54%]    |11.0 ~ 12.4 [11.3]       |

###3.Display 30 Images
|               |CPU Usage[average] |Memory Usage[average]/MB |
|:-------------:|:-----------------:|:-----------------------:|
|JWAnimatedImage|38% ~ 81% [53%]    |59.3 ~ 82.4 [63.3]       |
|FLAnimatedImage|126% ~ 185% [143%] |58.4 ~ 98.9 [74.2]       |

NOTE:

1.Measurement Factors:

 - Last updated: March 26, 2016

 - Measurement device: iPhone6 with iOS 9.3

 - Measurement tool: Profile in Xcode 7.3

 - Measurement image: See it in repository, all the parameters are default.

 - Row data are [here](https://github.com/wangjwchn/BenchmarkImage).

2.I've discussed the high memory usage of FLAnimatedImage with [@mitchellporter](https://github.com/mitchellporter) and confirmed this problem does exist，as described [here](https://github.com/wangjwchn/JWAnimatedImage/issues/1).

3.For each image, FLAnimatedImage creates a new independent thread. From the graph, we can see there are 36 threads when loading 30 GIFs, which causes a heavy CPU usage.

4.JWAnimatedImage uses GCD global queue to handle these tasks. This solution decrease the number of threads down to 9, and those threads are dynamic.

##Licence
JWAnimatedImage is released under the MIT license. See [LICENSE](https://github.com/wangjwchn/JWAnimatedImage/raw/master/LICENSE) for details.
