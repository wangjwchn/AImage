# JWAnimatedImage
A animated GIF engine for iOS in Swift 
####features
- [x] Have a great performance on memory usage by using producer/consumer pattern.
- [x] More flexible on display by using factor "level of Integrity" 
- [x] Using new Algorithm to decrease the initial loading time.
- [x] Small but complete,easy to extend.

####How to Use
```swift
let url = NSBundle.mainBundle().URLForResource(“imagename”, withExtension: "gif")!
let imageData = NSData(contentsOfURL:url)
let imageView = JWAnimatedImageView()
imageView.addGifImage(imageData!)
imageView.frame = CGRect(x: 0.0, y: 30.0, width: 300.0, height: 200.0)
view.addSubview(imageView)
```
####Benchmark
######Updated:Feb24,2016
- Compare with FLAnimatedImage
- Measurement device: iPhone6 with iOS 9.2.1
- Measurement tool:Profile in Xcode
- Measurement image:see it in repository,all the parameters are default.
- Measurement result:
- Main thread of CPU usgae:
- Memory usage:
- By the way,I think FLAnimatedImage may have memory leak problem.

####Licence
	JWAnimatedImage is released under the MIT license. See LICENSE for details.
