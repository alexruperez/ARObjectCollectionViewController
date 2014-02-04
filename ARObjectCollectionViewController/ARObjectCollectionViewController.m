//
//  ARObjectCollectionViewController.m
//  ARObjectCollectionView
//
//  Created by alexruperez on 30/12/13.
//  Copyright (c) 2013 alexruperez. All rights reserved.
//

#import "ARObjectCollectionViewController.h"

#import <ImageIO/ImageIO.h>
#import "ARWebViewControllerActivityChrome.h"
#import "ARWebViewControllerActivitySafari.h"
#import "ARWebViewController.h"

#define TEXT_NODE_KEY           @"#text"
#define ATTRIBUTE_PREFIX        @"-"
#define AXIS_PARENT            _axisAncestorOrSelf[_currentLevel - 1]
#define AXIS_PRECEDING_SIBLING _axisAncestorOrSelf[_currentLevel - 1][elementName]
#define AXIS_SELF              _axisAncestorOrSelf[_currentLevel]

@interface ARObjectCollectionViewController () <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>

@property (strong, nonatomic) id objectCollection;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableArray *axisAncestorOrSelf;
@property (strong, nonatomic) NSMutableString *selfText;
@property (strong, nonatomic) NSMutableDictionary *rootXML;
@property (assign, nonatomic) NSInteger currentLevel;

@end

@implementation ARObjectCollectionViewController

+ (id)showObjectCollection:(id)objectCollection
{
    ARObjectCollectionViewController *objectCollectionViewController = [[ARObjectCollectionViewController alloc] initWithObjectCollection:objectCollection];
    [objectCollectionViewController show];
    return objectCollectionViewController;
}

- (id)initWithObjectCollection:(id)objectCollection
{
    self = [super init];
    if (self)
    {
        if ([objectCollection  isKindOfClass:[UIImage class]])
        {
            objectCollection = UIImagePNGRepresentation(objectCollection);
        }
        if ([objectCollection  isKindOfClass:[NSURL class]])
        {
            self.url = objectCollection;
            objectCollection = [NSData dataWithContentsOfURL:objectCollection];
        }
        if ([objectCollection isKindOfClass:[NSString class]])
        {
            objectCollection = [objectCollection dataUsingEncoding:NSUTF8StringEncoding];
        }
        if ([objectCollection isKindOfClass:[NSData class]])
        {

            if ([UIImage imageWithData:objectCollection])
            {
                    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)objectCollection, NULL);
                    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
                    objectCollection = (__bridge NSDictionary*)imageMetaData;
            }
            else
            {
                NSError *error;
                id JSONObjectCollection = [NSJSONSerialization JSONObjectWithData:objectCollection options:NSJSONReadingAllowFragments error:&error];
                if (!error && JSONObjectCollection)
                {
                    objectCollection = JSONObjectCollection;
                }
                else
                {
                    NSXMLParser *XMLParser = [[NSXMLParser alloc] initWithData:objectCollection];
                    [XMLParser setDelegate:self];
                    [XMLParser parse];

                    return self;
                }
            }
        }
        self.objectCollection = objectCollection;
    }
    
    return self;
}

- (void)show
{
    [self showWithRootController:nil];
}

- (void)showWithRootController:(UINavigationController *)rootViewController
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissWindow)];
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].origin.x, [[UIScreen mainScreen] bounds].origin.y + [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    self.window.windowLevel = UIWindowLevelStatusBar - 1;
    self.window.rootViewController = rootViewController ? rootViewController : [[UINavigationController alloc] initWithRootViewController:self];
    [self.window makeKeyAndVisible];
    [UIView animateWithDuration:0.4f animations:^{
        self.window.frame = [[UIScreen mainScreen] bounds];
    } completion:NULL];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (id)objectCollection
{
    return _objectCollection;
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

- (IBAction)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)dismissWindow
{
    [UIView animateWithDuration:0.4f animations:^{
        self.window.frame = CGRectMake(self.window.frame.origin.x, self.window.frame.origin.y + self.window.frame.size.height, self.window.frame.size.width, self.window.frame.size.height);
    } completion:^(BOOL finished) {
        self.window.rootViewController = nil;
        self.window = nil;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objectCollection count];
}

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.objectCollection isKindOfClass:[NSDictionary class]])
    {
        return NSLocalizedString([[[self.objectCollection allKeys][indexPath.row] description] stringByReplacingOccurrencesOfString:@"\n" withString:@""], nil);
    }
    else if ([self.objectCollection isKindOfClass:[NSSet class]])
    {
        return NSLocalizedString([[[self.objectCollection allObjects][indexPath.row] description] stringByReplacingOccurrencesOfString:@"\n" withString:@""], nil);
    }
    else if ([self.objectCollection isKindOfClass:[NSArray class]])
    {
        return [NSString stringWithFormat:@"%@[%ld]", self.title ? self.title : @"object", (long)indexPath.row];
    }

    return nil;
}

- (id)valueForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.objectCollection isKindOfClass:[NSDictionary class]])
    {
        return [self.objectCollection allValues][indexPath.row];
    }
    else if ([self.objectCollection isKindOfClass:[NSSet class]])
    {
        return [self.objectCollection allObjects][indexPath.row];
    }
    else if ([self.objectCollection isKindOfClass:[NSArray class]])
    {
        return self.objectCollection[indexPath.row];
    }
    
    return nil;
}

- (NSString *)detailTextForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.objectCollection isKindOfClass:[NSDictionary class]])
    {
        id value = [self valueForIndexPath:indexPath];
        if (![value isKindOfClass:[NSDictionary class]] && ![value isKindOfClass:[NSSet class]] && ![value isKindOfClass:[NSArray class]] && !([value isKindOfClass:[NSString class]] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:value]]))
        {
            if ([value isKindOfClass:[NSNull class]])
            {
                return @"nil";
            }
            return [value description];
        }
    }
    
    return nil;
}

- (UITableViewCellAccessoryType)accessoryTypeForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.objectCollection isKindOfClass:[NSDictionary class]] || [self.objectCollection isKindOfClass:[NSArray class]])
    {
        id value = [self valueForIndexPath:indexPath];
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSSet class]] || [value isKindOfClass:[NSArray class]] || ([value isKindOfClass:[NSString class]] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:value]]))
        {
            return UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return UITableViewCellAccessoryNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    [cell.textLabel setText:[self textForIndexPath:indexPath]];
    [cell.detailTextLabel setText:[self detailTextForIndexPath:indexPath]];
    [cell setAccessoryType:[self accessoryTypeForIndexPath:indexPath]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id value = [self valueForIndexPath:indexPath];
    
    if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSSet class]] || [value isKindOfClass:[NSArray class]])
    {
        ARObjectCollectionViewController *objectCollectionViewController = [[ARObjectCollectionViewController alloc] initWithObjectCollection:value];
        [objectCollectionViewController setTitle:[self textForIndexPath:indexPath]];
        [self.navigationController pushViewController:objectCollectionViewController animated:YES];
    }
    else
    {
        if ([value isKindOfClass:[NSString class]] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:value]])
        {
            ARObjectCollectionViewController *objectCollectionViewController = [[ARObjectCollectionViewController alloc] initWithObjectCollection:[NSURL URLWithString:value]];

            if (objectCollectionViewController.objectCollection && ([objectCollectionViewController.objectCollection isKindOfClass:[NSDictionary class]] || [objectCollectionViewController.objectCollection isKindOfClass:[NSSet class]] || [objectCollectionViewController.objectCollection isKindOfClass:[NSArray class]]) && [objectCollectionViewController.objectCollection count] > 0)
            {
                [objectCollectionViewController setTitle:[self textForIndexPath:indexPath]];
                [self.navigationController pushViewController:objectCollectionViewController animated:YES];
            }
            else
            {
                [self.navigationController pushViewController:[[ARWebViewController alloc] initWithAddress:value] animated:YES];
            }
        }
        else if (![value isKindOfClass:[NSNull class]])
        {
            NSArray *activities = @[[ARWebViewControllerActivitySafari new], [ARWebViewControllerActivityChrome new]];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[value description]] applicationActivities:activities];
            [self presentViewController:activityViewController animated:YES completion:NULL];
        }
    }
}

- (void)showWebView
{
    [self.navigationController pushViewController:[[ARWebViewController alloc] initWithURL:self.url] animated:YES];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.currentLevel = 0;
    self.axisAncestorOrSelf = [NSMutableArray new];
    self.rootXML = [NSMutableDictionary new];
    [_axisAncestorOrSelf addObject:self.rootXML];
    self.selfText = [NSMutableString new];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [_axisAncestorOrSelf removeLastObject];
    self.objectCollection = self.rootXML;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentLevel++;
    if ([_axisAncestorOrSelf count] == _currentLevel)
    {
        [_axisAncestorOrSelf addObject:[NSMutableDictionary new]];
        if ([_selfText length] > 0)
        {
            [AXIS_PARENT setObject:_selfText forKey:TEXT_NODE_KEY];
            _selfText = [NSMutableString new];
        }
    }
    if ([attributeDict count] != 0)
    {
        for (id key in [attributeDict allKeys])
        {
            NSString *attributeKey = [NSString stringWithFormat:@"%@%@", ATTRIBUTE_PREFIX, key];
            [AXIS_SELF setObject:attributeDict[key] forKey:attributeKey];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *text = [string stringByTrimmingCharactersInSet: characterSet];
    [_selfText appendString:text];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([AXIS_SELF count] == 0)
    {
        [AXIS_PARENT setObject:_selfText forKey:elementName];
        _selfText = [NSMutableString new];
    }
    else
    {
        if ([_selfText length] > 0)
        {
            [AXIS_SELF setObject:_selfText forKey:TEXT_NODE_KEY];
            _selfText = [NSMutableString new];
        }
        if (AXIS_PRECEDING_SIBLING)
        {
            if ([AXIS_PRECEDING_SIBLING isKindOfClass:[NSMutableArray class]])
            {
                [AXIS_PRECEDING_SIBLING addObject:AXIS_SELF];
            }
            else if ([AXIS_PRECEDING_SIBLING isKindOfClass:[NSMutableDictionary class]])
            {
                NSMutableArray *elementsArray = [NSMutableArray new];
                [elementsArray addObjectsFromArray:@[AXIS_PRECEDING_SIBLING, AXIS_SELF]];
                [AXIS_PARENT setObject:elementsArray forKey:elementName];
            }
        }
        else
        {
            [AXIS_PARENT setObject:AXIS_SELF forKey:elementName];
        }
        [_axisAncestorOrSelf removeObject:AXIS_SELF];
    }
    _currentLevel--;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Line:%li Column:%li - Parse Error Occurred: %@", (long)[parser lineNumber], (long)[parser columnNumber], [parseError description]);
    if (self.url)
    {
        [self performSelector:@selector(showWebView) withObject:nil afterDelay:0.6f];
    }
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"Line:%li Column:%li - Validation Error Occurred: %@", (long)[parser lineNumber], (long)[parser columnNumber], [validationError description]);
    if (self.url)
    {
        [self performSelector:@selector(showWebView) withObject:nil afterDelay:0.6f];
    }
}

@end
