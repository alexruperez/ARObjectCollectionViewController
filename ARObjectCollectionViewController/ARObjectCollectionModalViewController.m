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

- (id)initWithObjectCollection:(id)objectCollection
{
    self.objectCollectionViewController = [[ARObjectCollectionViewController alloc] initWithObjectCollection:objectCollection];
    if (self = [super initWithRootViewController:self.objectCollectionViewController]) {
        self.objectCollectionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.objectCollectionViewController action:@selector(doneButtonClicked:)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    self.objectCollectionViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

@end
