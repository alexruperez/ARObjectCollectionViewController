//
//  ARObjectCollectionViewController.h
//  ARObjectCollectionView
//
//  Created by alexruperez on 30/12/13.
//  Copyright (c) 2013 alexruperez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARObjectCollectionViewController : UIViewController

+ (id)showObjectCollection:(id)objectCollection;

- (id)initWithObjectCollection:(id)objectCollection;

- (void)show;

- (void)showWithRootController:(UINavigationController *)rootViewController;

- (IBAction)dismissWindow;

- (IBAction)dismissViewController;

- (id)objectCollection;

@end
