# ARObjectCollectionViewController

`ARObjectCollectionViewController` is an UIViewController that can present a JSON NSString, JSON NSData, JSON URL, XML NSData, XML URL, RSS NSData, RSS URL, NSDictionary, NSArray, NSSet...

![ARObjectCollectionViewController screenshot](https://raw.github.com/alexruperez/ARObjectCollectionViewController/master/screenshot.png "ARObjectCollectionViewController screenshot")

## Requirements

- This project uses ARC. If you want to use it in a non ARC project, you must add the `-fobjc-arc` compiler flag to ARObjectCollectionViewController.m and ARObjectCollectionModalViewController.m in Target Settings > Build Phases > Compile Sources.

## Installation

Add the `ARObjectCollectionViewController` subfolder to your project. There are no required libraries other than `UIKit`.

## Usage

*(See example Xcode project)*

Simply `alloc`/`init` an instance of `ARObjectCollectionViewController` (for pushing) or `ARObjectCollectionModalViewController` (for presenting).

```objectivec
ARObjectCollectionViewController *objectCollectionViewController = [[ARObjectCollectionViewController alloc] initWithObjectCollection:objectCollection];
```
