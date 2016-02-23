# JWAnimatedImage
A animated GIF engine for iOS in Swift 
####features
1. have a great performance on memory usage by using producer/consumer pattern.
2. more flexible on display by using factor "level of Integrity"
3. Using new Algorithm to decrease the initial loading time.
4. Small but complete,easy to extend.

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
	Coming soon…

####Licence
	JWAnimatedImage is released under the MIT license. See LICENSE for details.
