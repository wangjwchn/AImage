# JWAnimatedImage
A animated GIF engine for iOS in Swift 
##Features
- [x] Have a great performance on memory usage by using producer/consumer pattern.
- [x] Have a great performance on CPU usage by using asynchronous loading.
- [x] Allow to control display quality by using factor 'level of Integrity'
- [x] Allow to control memory usage by using factor 'memoryLimit'
- [x] Small but complete,easy to extend.

##How to Use
```swift
let url = NSBundle.mainBundle().URLForResource(“imagename”, withExtension: "gif")!
let imageData = NSData(contentsOfURL:url)
let imageView = JWAnimatedImageView()
imageView.addGifImage(imageData!)
imageView.frame = CGRect(x: 0.0, y: 30.0, width: 300.0, height: 200.0)
view.addSubview(imageView)
```
##Benchmark:
####Compare with [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage) and [SwiftGif](https://github.com/bahlo/SwiftGif)
> Updated:March2,2016<p>
> Measurement device:&nbsp;iPhone6 with iOS 9.2.1<p>
> Measurement tool:&nbsp;Profile in Xcode<p>
> Measurement image:&nbsp;See it in repository,all the parameters are default.<p>
> Measurement result:<p>
####1.Display just one GIF image
####1.1 CPU usgae:
######JWAnimatedImage<p>
![JW_CPU](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/JW_CPU1.png)<p>
######FLAnimatedImage<p>
![FL_CPU](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/FL_CPU1.png)<p>
######SwiftGif<p>
![SG_CPU](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/SG_CPU.png)<p>
####1.2 Memory usage: 
######JWAnimatedImage<p>
![JW_MEM](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/JW_MEM1.png)<p>
######FLAnimatedImage<p>
![FL_MEM](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/FL_MEM1.png)<p>
######SwiftGif<p>
![SG_MEM](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/SG_MEM.png)<p>
 > I've discussed the high memory usage of FLAnimatedImage with [@mitchellporter](https://github.com/mitchellporter) and confirmed this problem does exist，you can see it [here](https://github.com/wangjwchn/JWAnimatedImage/issues/1)<p>
 > From the graph,we can see that SwiftGif isn't processing the memory usage.<p>

####2.Display 30 GIF images
####Like this:
![DEMO](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/DEMO.jpg)<p>
####2.1 CPU usgae:
######JWAnimatedImage<p>
![JW_CPU](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/JW_CPU2.png)<p>
######FLAnimatedImage<p>
![FL_CPU](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/FL_CPU2.png)<p> 
###### ...... <p>
![FL_CPU](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/FL_CPU3.png)<p> 
 > There is no benckmark graph for SwiftGif because it crash immediately caused by high memory usage.<p>
 > For each image,FLAnimatedImage create a new thread and run independently.From the graph,we can see there are 36 threads when we load 30 GIF images,that will cause a heavy CPU usage.<p>
 > So in JWAnimatedImage,we use 'global queue' by 'GCD' to handle these tasks together.That makes the number of threads down to 10,and those threads are dynamic.From the graph,we can see some of them are just start.<p>

####2.2 Memory usage:
######JWAnimatedImage<p>
![JW_MEM](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/JW_MEM2.png)<p>
######FLAnimatedImage<p>
![FL_MEM](https://raw.githubusercontent.com/wangjwchn/JWAnimatedImage/master/BenchmarkPicture/FL_MEM2.png)<p>
 > I think JWAnimatedImage is better than FLAnimatedImage in cpu and memory usage.<p>

##Licence
 > JWAnimatedImage is released under the MIT license. See [LICENSE](https://github.com/wangjwchn/JWAnimatedImage/raw/master/LICENSE) for details.<p>
