//
//  ARObjectCollectionViewController.m
//  ARObjectCollectionView
//
//  Created by alexruperez on 30/12/13.
//  Copyright (c) 2013 alexruperez. All rights reserved.
//

#import "ARObjectCollectionViewController.h"

@interface ARObjectCollectionViewController ()

@property (nonatomic, strong) id objectCollection;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ARObjectCollectionViewController

- (id)initWithObjectCollection:(id)objectCollection
{
    if (self = [super init]) {
        if ([objectCollection isKindOfClass:[NSString class]]) {
            objectCollection = [objectCollection dataUsingEncoding:NSUTF8StringEncoding];
        }
        if ([objectCollection isKindOfClass:[NSData class]]) {
            NSError *error;
            id JSONObjectCollection = [NSJSONSerialization JSONObjectWithData:objectCollection options:NSJSONReadingAllowFragments error:&error];
            if (!error) {
                objectCollection = JSONObjectCollection;
            }
        }
        self.objectCollection = objectCollection;
    }
    
    return self;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSAssert(self.navigationController, @"ARObjectCollectionViewController needs to be contained in a UINavigationController. If you are presenting ARObjectCollectionViewController modally, use ARObjectCollectionModalViewController instead.");
    
    [super viewWillAppear:animated];
}

- (void)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objectCollection count];
}

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.objectCollection isKindOfClass:[NSDictionary class]]) {
        return NSLocalizedString([[self.objectCollection allKeys][indexPath.row] description], nil);
    } else if ([self.objectCollection isKindOfClass:[NSSet class]]) {
        return NSLocalizedString([[[self.objectCollection allObjects][indexPath.row] description] stringByReplacingOccurrencesOfString:@"\n" withString:@""], nil);
    } else if ([self.objectCollection isKindOfClass:[NSArray class]]) {
        return NSLocalizedString([[self.objectCollection[indexPath.row] description] stringByReplacingOccurrencesOfString:@"\n" withString:@""], nil);
    }
    
    return nil;
}

- (id)valueForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.objectCollection isKindOfClass:[NSDictionary class]]) {
        return [self.objectCollection allValues][indexPath.row];
    } else if ([self.objectCollection isKindOfClass:[NSSet class]]) {
        return [self.objectCollection allObjects][indexPath.row];
    } else if ([self.objectCollection isKindOfClass:[NSArray class]]) {
        return self.objectCollection[indexPath.row];
    }
    
    return nil;
}

- (NSString *)detailTextForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.objectCollection isKindOfClass:[NSDictionary class]]) {
        id value = [self valueForIndexPath:indexPath];
        if (![value isKindOfClass:[NSDictionary class]] && ![value isKindOfClass:[NSSet class]] && ![value isKindOfClass:[NSArray class]]) {
            return [value description];
        }
    }
    
    return nil;
}

- (UITableViewCellAccessoryType)accessoryTypeForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.objectCollection isKindOfClass:[NSDictionary class]]) {
        id value = [self valueForIndexPath:indexPath];
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSSet class]] || [value isKindOfClass:[NSArray class]]) {
            return UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if ([self.objectCollection isKindOfClass:[NSSet class]] || [self.objectCollection isKindOfClass:[NSArray class]]) {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return UITableViewCellAccessoryNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    [cell.textLabel setText:[self textForIndexPath:indexPath]];
    [cell.detailTextLabel setText:[self detailTextForIndexPath:indexPath]];
    [cell setAccessoryType:[self accessoryTypeForIndexPath:indexPath]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id value = [self valueForIndexPath:indexPath];
    
    if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSSet class]] || [value isKindOfClass:[NSArray class]]) {
        ARObjectCollectionViewController *objectCollectionViewController = [[ARObjectCollectionViewController alloc] initWithObjectCollection:value];
        [objectCollectionViewController setTitle:[self textForIndexPath:indexPath]];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.navigationController pushViewController:objectCollectionViewController animated:YES];
    } else {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[value description]] applicationActivities:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self presentViewController:activityViewController animated:YES completion:NULL];
    }
}

@end
