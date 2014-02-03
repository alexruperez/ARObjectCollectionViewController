//
//  ARObjectCollectionModalViewController.h
//  ARObjectCollectionView
//
//  Created by alexruperez on 30/12/13.
//  Copyright (c) 2013 alexruperez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARObjectCollectionViewController.h"

@interface ARObjectCollectionModalViewController : UINavigationController

+ (id)showObjectCollection:(id)objectCollection;

- (id)initWithObjectCollection:(id)objectCollection;

- (void)show;

- (id)objectCollection;

@property (nonatomic, strong) UIColor *barsTintColor;

@end
