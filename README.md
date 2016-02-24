# JWAnimatedImage
A animated GIF engine for iOS in Swift 
###features
- [x] Have a great performance on memory usage by using producer/consumer pattern.
- [x] More flexible on display by using factor "level of Integrity" 
- [x] Using new Algorithm to decrease the initial loading time.
- [x] Small but complete,easy to extend.

###How to Use
```swift
let url = NSBundle.mainBundle().URLForResource(“imagename”, withExtension: "gif")!
let imageData = NSData(contentsOfURL:url)
let imageView = JWAnimatedImageView()
imageView.addGifImage(imageData!)
imageView.frame = CGRect(x: 0.0, y: 30.0, width: 300.0, height: 200.0)
view.addSubview(imageView)
```
###Benchmark:Compare with [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage)
> Updated:Feb24,2016<p>
> Measurement device:&nbsp;iPhone6 with iOS 9.2.1<p>
> Measurement tool:&nbsp;Profile in Xcode<p>
> Measurement image:&nbsp;See it in repository,all the parameters are default.<p>
> Measurement result:<p>
######&nbsp;&nbsp;1.Main thread of CPU usgae:
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 JWAnimatedImage<p>
![JW_CPU](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/JW_CPU.png)<p>
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 FLAnimatedImage<p>
![FL_CPU](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/FL_CPU.png)<p>
######&nbsp;&nbsp; 2.Memory usage:
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 JWAnimatedImage<p>
![JW_MEM](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/JW_MEM.png)<p>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 FLAnimatedImage<p>
![FL_MEM](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/FL_MEM.png)<p>
> I think JWAnimatedImage is better than FLAnimatedImage in cpu and memory usage.By the way,I think FLAnimatedImage may have memory leak problem.<p>

####Licence
	JWAnimatedImage is released under the MIT license. See LICENSE for details.
