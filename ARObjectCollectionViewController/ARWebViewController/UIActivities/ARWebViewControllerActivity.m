//
//  ARWebViewControllerActivity.m
//  ARWeb
//
//  Created by Sam Vermette on 11/11/2013.
//
//

#import "ARWebViewControllerActivity.h"

@implementation ARWebViewControllerActivity

- (NSString *)activityType {
	return NSStringFromClass([self class]);
}

- (UIImage *)activityImage {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return [UIImage imageNamed:[self.activityType stringByAppendingString:@"-iPad"]];
    else
        return [UIImage imageNamed:self.activityType];
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]]) {
			self.URLToOpen = activityItem;
		}
	}
}

@end
