//
//  ARObjectCollectionViewController.m
//  ARObjectCollectionView
//
//  Created by alexruperez on 30/12/13.
//  Copyright (c) 2013 alexruperez. All rights reserved.
//

#import "ARObjectCollectionViewController.h"
#import "ARWebViewController.h"

#define TEXT_NODE_KEY           @"#text"
#define ATTRIBUTE_PREFIX        @"-"
#define AXIS_PARENT            _axisAncestorOrSelf[_currentLevel - 1]
#define AXIS_PRECEDING_SIBLING _axisAncestorOrSelf[_currentLevel - 1][elementName]
#define AXIS_SELF              _axisAncestorOrSelf[_currentLevel]

@interface ARObjectCollectionViewController () <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) id objectCollection;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *axisAncestorOrSelf;
@property (strong, nonatomic) NSMutableString *selfText;
@property (strong, nonatomic) NSMutableDictionary *root;
@property (assign, nonatomic) NSError *error;
@property (assign, nonatomic) NSInteger currentLevel;

@end

@implementation ARObjectCollectionViewController

- (id)initWithObjectCollection:(id)objectCollection
{
    if (self = [super init])
    {
        if ([objectCollection  isKindOfClass:[NSURL class]])
        {
            objectCollection = [NSData dataWithContentsOfURL:objectCollection];
        }
        if ([objectCollection isKindOfClass:[NSString class]])
        {
            objectCollection = [objectCollection dataUsingEncoding:NSUTF8StringEncoding];
        }
        if ([objectCollection isKindOfClass:[NSData class]])
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

                return  self;
            }
        }
        self.objectCollection = objectCollection;
    }
    
    return self;
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

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSAssert(self.navigationController, @"ARObjectCollectionViewController needs to be contained in a UINavigationController. If you are presenting ARObjectCollectionViewController modally, use ARObjectCollectionModalViewController instead.");
    
    [super viewWillAppear:animated];
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
        return [NSString stringWithFormat:@"%@[%ld]", self.title ? self.title : @"object", indexPath.row];
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
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[value description]] applicationActivities:nil];
            [self presentViewController:activityViewController animated:YES completion:NULL];
        }
    }
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    ///Initialize internal objects and values
    //Set counter for current level to root element level.
    _currentLevel = 0;
    //Create storage for parsing elements.
    _axisAncestorOrSelf = [NSMutableArray new];
    //Create object for result of parsing - the root object
    _root = [NSMutableDictionary new];
    //Put in the array as first the root object.
    [_axisAncestorOrSelf addObject:_root];
    //Create object for storing current element text value.
    _selfText = [NSMutableString new];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    ///Clear unused object
    [_axisAncestorOrSelf removeLastObject];
    self.objectCollection = _root;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    ///Start processing of the current element
    _currentLevel++;
    if ([_axisAncestorOrSelf count] == _currentLevel)
    {
        //Add dictionary for started element if it not exist.
        [_axisAncestorOrSelf addObject:[NSMutableDictionary new]];
        //Processing a text value (if it exist) of the previous (parent) element.
        if ([_selfText length] > 0)
        {
            [AXIS_PARENT setObject:_selfText forKey:TEXT_NODE_KEY];
            _selfText = [NSMutableString new];
        }
    }
    //Add attribute values (if it exist) to current element.
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
    ///Processing the text value of the current element
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *text = [string stringByTrimmingCharactersInSet: characterSet];
    [_selfText appendString:text];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    ///Completion processing of the current element
    if ([AXIS_SELF count] == 0)
    {
        //If exist only text value of element - set it as element value.
        [AXIS_PARENT setObject:_selfText forKey:elementName];
        _selfText = [NSMutableString new];
    }
    else
    {
        if ([_selfText length] > 0)
        {
            //If exist text value of element and child elements - set it as child element value.
            [AXIS_SELF setObject:_selfText forKey:TEXT_NODE_KEY];
            _selfText = [NSMutableString new];
        }
        if (AXIS_PRECEDING_SIBLING)
        {
            if ([AXIS_PRECEDING_SIBLING isKindOfClass:[NSMutableArray class]])
            {
                //If exist collection of preceding-sibling elements - add current element to collection.
                [AXIS_PRECEDING_SIBLING addObject:AXIS_SELF];
            }
            else if ([AXIS_PRECEDING_SIBLING isKindOfClass:[NSMutableDictionary class]])
            {
                /*
                 If exist only one preceding-sibling element - create collection
                 and add both (preceding-sibling and current) elements to collection.
                 */
                NSMutableArray *elementsArray = [NSMutableArray new];
                [elementsArray addObjectsFromArray:@[AXIS_PRECEDING_SIBLING, AXIS_SELF]];
                [AXIS_PARENT setObject:elementsArray forKey:elementName];
            }
        }
        else
        {
            //If preceding-sibling elements not exist - add current element as child element.
            [AXIS_PARENT setObject:AXIS_SELF forKey:elementName];
        }
        //Remove current element from storage for parsing elements.
        [_axisAncestorOrSelf removeObject:AXIS_SELF];
    }
    _currentLevel--;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    ///Handle parse error
    //Output in the console error.
    NSLog(@"Line:%li Column:%li - Parse Error Occurred: %@", (long)[parser lineNumber], (long)[parser columnNumber], [parseError description]);
    //Set error prorerty pointer to parse error.
    _error = parseError;
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    ///Handle validation error
    //Output in the console error.
    NSLog(@"Line:%li Column:%li - Validation Error Occurred: %@", (long)[parser lineNumber], (long)[parser columnNumber], [validationError description]);
    //Set error prorerty pointer to validation error.
    _error = validationError;
}

@end
