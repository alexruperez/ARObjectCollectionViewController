//
//  ARObjectCollectionModalViewController.m
//  ARObjectCollectionView
//
//  Created by alexruperez on 30/12/13.
//  Copyright (c) 2013 alexruperez. All rights reserved.
//

#import "ARObjectCollectionModalViewController.h"

@interface ARObjectCollectionModalViewController ()

@property (nonatomic, strong) ARObjectCollectionViewController *objectCollectionViewController;

@end

@implementation ARObjectCollectionModalViewController

+ (id)showObjectCollection:(id)objectCollection
{
    ARObjectCollectionModalViewController *objectCollectionModalViewController = [[ARObjectCollectionModalViewController alloc] initWithObjectCollection:objectCollection];
    [objectCollectionModalViewController show];
    return objectCollectionModalViewController;
}

- (id)initWithObjectCollection:(id)objectCollection
{
    self.objectCollectionViewController = [[ARObjectCollectionViewController alloc] initWithObjectCollection:objectCollection];
    self = [super initWithRootViewController:self.objectCollectionViewController];
    if (self) {
        self.objectCollectionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.objectCollectionViewController action:@selector(dismissViewController)];
    }
    return self;
}

- (void)show
{
    [self.objectCollectionViewController showWithRootController:self];
}

- (id)objectCollection
{
    return _objectCollectionViewController ? _objectCollectionViewController.objectCollection : nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    self.objectCollectionViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

@end
