![Cover](https://wangjwchn.github.io/image/cover.png)

[![Language](https://img.shields.io/badge/swift-4.0-orange.svg)](http://swift.org)
[![Pod License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/wangjwchn/AImage/master/LICENSE)


## Features

- [x] Small but complete, only`200`lines of code. 
- [x] Allow to control display quality, memory usage, loop time and display progress.
- [x] Have a great performance on memory and cpu usage. 
- [x] Using asynchronous image decoding to reduce the main thread CPU usage.


## Usage

```swift
/* Create AImage with URL */
let image = AImage(url: Bundle.main.url(forResource: "test", withExtension: "gif")!)

/* Create AImageView */
let imageview = AImageView(frame:CGRect(x: 0.0, y: 50.0, width: 380.0, height: 212.0))

/* Add AImage to AImageView */
imageview.add(image: image!)

/* Start displaying animated image */
imageview.play = true

...
...

/* Stop displaying animated image */
imageview.play = false

```

## Benchmark

Compared with [Gifu](https://github.com/kaishin/Gifu/tree/swift4) and [Apple's example code](https://developer.apple.com/library/content/samplecode/UsingPhotosFramework/Introduction/Intro.html).

#### Test1: Display [view.gif](https://wangjwchn.github.io/image/view.gif)

|Library|CPU|Memory|
|:--:|:--:|:--:|
|Apple's Example Code |  <img src="https://wangjwchn.github.io/image/apple-view-cpu.png" width = "1000" height = "150" />   |    <img src="https://wangjwchn.github.io/image/apple-view-mem.png" width = "600" height = "120" />     |
|Gifu| <img src="https://wangjwchn.github.io/image/gifu-view-cpu.png" width = "1000" height = "150" />   |    <img src="https://wangjwchn.github.io/image/gifu-view-mem.png" width = "600" height = "120" />     |
|AImage|  <img src="https://wangjwchn.github.io/image/aimage-view-cpu.png" width = "1000" height = "150" />   |    <img src="https://wangjwchn.github.io/image/aimage-view-mem.png" width = "600" height = "120" />     |

#### Test2: Display [view.gif](https://wangjwchn.github.io/image/earth.gif)

|Library|CPU|Memory|
|:--:|:--:|:--:|
|Apple's Example Code |  <img src="https://wangjwchn.github.io/image/apple-earch-cpu.png" width = "1000" height = "150" />   |    <img src="https://wangjwchn.github.io/image/apple-earth-mem.png" width = "600" height = "120" />     |
|Gifu| <img src="https://wangjwchn.github.io/image/gifu-earth-cpu.png" width = "1000" height = "150" />   |    <img src="https://wangjwchn.github.io/image/gifu-earth-mem.png" width = "600" height = "120" />     |
|AImage|  <img src="https://wangjwchn.github.io/image/aimage-earth-cpu.png" width = "1000" height = "150" />   |    <img src="https://wangjwchn.github.io/image/aimage-earth-mem.png" width = "600" height = "120" />     |

Measurement Factors:

 - Measurement time: August 24, 2017

 - Measurement device: iPhone6, iOS 11.0(15A5362a)
 
## Old Version

Version of swift 2.3 can be found in [here](https://github.com/wangjwchn/AImage/tree/Swift2.3).
 
## Licence
AImage is released under the MIT license. See [LICENSE](https://github.com/wangjwchn/JWAnimatedImage/raw/master/LICENSE) for details.