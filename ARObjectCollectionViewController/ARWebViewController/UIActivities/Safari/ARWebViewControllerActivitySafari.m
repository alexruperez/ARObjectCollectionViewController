//
//  ARWebViewControllerActivitySafari.m
//
//  Created by Sam Vermette on 11 Nov, 2013.
//  Copyright 2013 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/ARWebViewController


#import "ARWebViewControllerActivitySafari.h"

@implementation ARWebViewControllerActivitySafari

- (NSString *)activityTitle {
	return NSLocalizedStringFromTable(@"Open in Safari", @"ARWebViewController", nil);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]] && [[UIApplication sharedApplication] canOpenURL:activityItem]) {
			return YES;
		}
	}
	return NO;
}

- (void)performActivity {
	BOOL completed = [[UIApplication sharedApplication] openURL:self.URLToOpen];
	[self activityDidFinish:completed];
}

@end
