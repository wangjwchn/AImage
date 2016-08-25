![Cover](https://raw.githubusercontent.com/wangjwchn/BenchmarkImage/master/Cover.png)

[![Language](https://img.shields.io/badge/swift-2.2-orange.svg)](http://swift.org)
[![Build Status](https://travis-ci.org/wangjwchn/AImage.svg?branch=master)](https://travis-ci.org/wangjwchn/JWAnimatedImage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/AImage.svg)](https://img.shields.io/cocoapods/v/JWAnimatedImage.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Pod License](https://img.shields.io/dub/l/vibe-d.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)

An animated GIF&APNG engine for iOS in Swift with low memory & cpu usage.

![video](http://i.imgur.com/XOoq9mP.gif)

##Features
- [x] Using asynchronous image decoding to reduce the main thread CPU usage.
- [x] Optimized for Multi-Image case.
- [x] As UIImage and UIImageView extension,easy to use.
- [x] Have a great performance on memory usage by using producer/consumer pattern.
- [x] Have a great performance on CPU usage by using asynchronous loading.
- [x] Allow to control display quality by using factor 'level of Integrity'
- [x] Allow to control memory usage by using factor 'memoryLimit'

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `AImage` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'AImage'
```

To get the full benefits import `AImage` wherever you import UIKit

``` swift
import UIKit
import AImage
```

#### Carthage
Create a `Cartfile` that lists the framework and run `carthage bootstrap`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/AImage.framework` to an iOS project.

```
github "wangjwchn/AImage"
```
#### Manually
1. Download and drop ```/AImage```folder in your project.  
2. Congratulations!  

## How to Use

```swift

let imageData = NSData(contentsOfURL:NSBundle.mainBundle().URLForResource("test", withExtension: "gif")!)
let image = UIImage(AImageData:imageData!)
let imageview = UIImageView(AImage: image)
imageview.frame = CGRect(x: 7.0, y: 50.0, width: 400.0, height: 224.0)
view.addSubview(imageview)
imageview.APlay();

```

## Principles
- [Here](https://wangjwchn.github.io/blog/Display-animated-image-on-iOS-device)

##Benchmark
###Display GIF:Compared with [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage)
#####1.Display 1 Image
|               |CPU Usage[average] |Memory Usage[average]/MB |
|:-------------:|:-----------------:|:-----------------------:|
|AImage|6% ~ 14% [8%]      |7.5 ~ 8.4 [8.2]          |
|FLAnimatedImage|8% ~ 24% [11%]     |7.3 ~ ??? [???]          |

#####2.Display 3 Images
|               |CPU Usage[average] |Memory Usage[average]/MB |
|:-------------:|:-----------------:|:-----------------------:|
|AImage|31% ~ 44% [38%]    |12.4 ~ 13.4 [12.9]       |
|FLAnimatedImage|36% ~ 62% [54%]    |11.0 ~ 12.4 [11.3]       |

#####3.Display 30 Images
|               |CPU Usage[average] |Memory Usage[average]/MB |
|:-------------:|:-----------------:|:-----------------------:|
|AImage|38% ~ 81% [53%]    |59.3 ~ 82.4 [63.3]       |
|FLAnimatedImage|126% ~ 185% [143%] |58.4 ~ 98.9 [74.2]       |


###Display APNG:Compared with [APNGKit](https://github.com/onevcat/APNGKit)

#####1.Display 1 Image
|               				|CPU Usage[average] |Memory Usage[average]/MB |
|:------------------------:|:-----------------:|:-----------------------:|
|AImage (Cache)	|2% ~ 44% [3%]      |43.2 ~ 43.2 [43.2]       |
|AImage (noCache)	|20% ~ 49% [33%]    |6.6 ~ 8.3 [7.5]          |
|APNGKit (Cache)				|1% ~ 42% [1%]      |95.6 ~ 95.6 [95.6]        |
|APNGKit (noCache)			|1% ~ 26% [1%]      |95.9 ~ 95.9 [95.9]        |


Measurement Factors:

 - Last updated: April 26, 2016

 - Measurement device: iPhone6 with iOS 9.3

 - Measurement tool: Profile in Xcode 7.3

 - Measurement image: See it in repository, all the parameters are default.

 - Raw data are [here](https://github.com/wangjwchn/BenchmarkImage).

 
##Licence
AImage is released under the MIT license. See [LICENSE](https://github.com/wangjwchn/JWAnimatedImage/raw/master/LICENSE) for details.
