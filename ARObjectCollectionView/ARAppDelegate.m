//
//  ARAppDelegate.m
//  ARObjectCollectionView
//
//  Created by alexruperez on 30/12/13.
//  Copyright (c) 2013 alexruperez. All rights reserved.
//

#import "ARAppDelegate.h"
#import "ARObjectCollectionViewController.h"

@implementation ARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ARObjectCollectionViewController *objectCollectionViewController = [[ARObjectCollectionViewController alloc] initWithObjectCollection:[[NSDictionary alloc] initWithObjectsAndKeys:@"Value 1", @"Key 1", [NSDate date], @"Key 2", [NSURL URLWithString:@"http://alexruperez.com"], @"Key 3", [NSData data], @"Key 4", @5, @"Key 5", [[NSDictionary alloc] initWithObjectsAndKeys:@"Value 1", @"Key 1", @"Value 2", @"Key 2", @"Value 3", @"Key 3", @"Value 4", @"Key 4", @"Value 5", @"Key 5", nil], @"Key 6", [NSNull null], @"Key 7", kCFNull, @"Key 8", [NSArray arrayWithObjects:@"Key 1", @2, [NSURL URLWithString:@"http://alexruperez.com"], nil], @"Key 9", [NSSet setWithObjects:@1, [NSDate date], [NSData data], nil], @"Key 10", nil]];
    
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:objectCollectionViewController]];
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
