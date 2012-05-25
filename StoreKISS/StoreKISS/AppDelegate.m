//
//  AppDelegate.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window,
			navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	
	RootViewController *rootViewController = [[RootViewController alloc] init];
	self.navigationController = [[UINavigationController alloc] 
								 initWithRootViewController:rootViewController];
	self.window.rootViewController = self.navigationController;
	
    [self.window makeKeyAndVisible];
    return YES;
}

@end
