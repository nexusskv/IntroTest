//
//  AppDelegate.m
//  IntroProTestProject
//
//  Created by rost on 20.11.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"


@interface AppDelegate ()

@end


@implementation AppDelegate


#pragma mark - App life cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = self.navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
#pragma mark -


@end
