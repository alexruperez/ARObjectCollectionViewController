//
//  ARWebViewController.h
//
//  Based on SVWebViewController
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/ARWebViewController

#import "ARModalWebViewController.h"

@interface ARWebViewController : UIViewController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;
- (void)doneButtonClicked:(id)sender;

@end
