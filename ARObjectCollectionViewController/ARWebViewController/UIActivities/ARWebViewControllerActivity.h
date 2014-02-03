//
//  ARWebViewControllerActivity.h
//  ARWeb
//
//  Created by Sam Vermette on 11/11/2013.
//
//

#import <UIKit/UIKit.h>

@interface ARWebViewControllerActivity : UIActivity

@property (nonatomic, strong) NSURL *URLToOpen;
@property (nonatomic, strong) NSString *schemePrefix;

@end
