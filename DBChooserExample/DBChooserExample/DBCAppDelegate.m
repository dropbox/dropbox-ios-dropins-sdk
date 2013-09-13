//
//  DBCAppDelegate.m
//  DBChooser-Example
//
//  Created by rich on 6/18/13.
//  Copyright (c) 2013 Dropbox. All rights reserved.
//

#import "DBCAppDelegate.h"

#import "DBCMainViewController.h"
#import <DBChooser/DBChooser.h>

@implementation DBCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    // set our testing view controller as the root
    [self.window setRootViewController:[[DBCMainViewController alloc] init]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[DBChooser defaultChooser] handleOpenURL:url]) {
        // This was a Chooser response and handleOpenURL automatically ran the
        // completion block
        return YES;
    }
    return NO;
}

@end
