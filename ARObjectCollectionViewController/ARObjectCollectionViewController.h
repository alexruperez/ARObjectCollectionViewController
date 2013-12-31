//
//  ARObjectCollectionViewController.h
//  ARObjectCollectionView
//
//  Created by alexruperez on 30/12/13.
//  Copyright (c) 2013 alexruperez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARObjectCollectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithObjectCollection:(id)objectCollection;

- (void)doneButtonClicked:(id)sender;

@end
