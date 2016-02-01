# ARObjectCollectionViewController

[![Twitter](http://img.shields.io/badge/contact-@alexruperez-blue.svg?style=flat)](http://twitter.com/alexruperez)
[![Version](https://img.shields.io/cocoapods/v/ARObjectCollectionViewController.svg?style=flat)](http://cocoadocs.org/docsets/ARObjectCollectionViewController)
[![License](https://img.shields.io/cocoapods/l/ARObjectCollectionViewController.svg?style=flat)](http://cocoadocs.org/docsets/ARObjectCollectionViewController)
[![Platform](https://img.shields.io/cocoapods/p/ARObjectCollectionViewController.svg?style=flat)](http://cocoadocs.org/docsets/ARObjectCollectionViewController)
[![Analytics](https://ga-beacon.appspot.com/UA-55329295-1/ARObjectCollectionViewController/readme?pixel)](https://github.com/igrigorik/ga-beacon)

## Overview

`ARObjectCollectionViewController` is an UIViewController that can present a JSON NSString, JSON NSData, JSON URL, XML NSData, XML URL, RSS NSData, RSS URL, NSDictionary, NSArray, NSSet, UIImage EXIF Metadata...

![ARObjectCollectionViewController screenshot](https://raw.github.com/alexruperez/ARObjectCollectionViewController/master/screenshot.png "ARObjectCollectionViewController screenshot")

## Requirements

- This project uses ARC. If you want to use it in a non ARC project, you must add the `-fobjc-arc` compiler flag to ARObjectCollectionViewController.m and ARObjectCollectionModalViewController.m in Target Settings > Build Phases > Compile Sources.

## Installation

Add the `ARObjectCollectionViewController` subfolder to your project. There are no required libraries other than `UIKit`.

## Usage

*(See example Xcode project)*

```objectivec
[ARObjectCollectionViewController showObjectCollection:objectCollection];
```

Or you can `alloc`/`init` an instance of `ARObjectCollectionViewController` (for pushing) or `ARObjectCollectionModalViewController` (for presenting).

```objectivec
ARObjectCollectionViewController *objectCollectionViewController = [[ARObjectCollectionViewController alloc] initWithObjectCollection:objectCollection];
```

## Thanks

[@samvermette](https://github.com/samvermette)/[#SVWebViewController](https://github.com/samvermette/SVWebViewController)
