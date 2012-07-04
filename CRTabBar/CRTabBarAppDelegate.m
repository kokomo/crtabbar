//
//  CRTabBarAppDelegate.m
//  CRTabBar
//
//  Created by Constantinos Mavromoustakos on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CRTabBarAppDelegate.h"

@implementation CRTabBarAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self setupTabBarController];
	[self.window makeKeyAndVisible];
	return YES;
}

-(void)setupTabBarController
{
    CRTabBarController *tabBarController = [[CRTabBarController alloc] init];
    NSMutableArray* viewControllers = [[NSMutableArray alloc] init];
    
    UIViewController *crCategoriesslidingViewController = [[UIViewController alloc] init];
    UINavigationController *categoriesNavigationController = [[UINavigationController alloc] initWithRootViewController:crCategoriesslidingViewController];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] init];
    [tabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"ICN_home_ON"]
              withFinishedUnselectedImage: [UIImage imageNamed: @"ICN_home"]];
    [categoriesNavigationController setTabBarItem: tabBarItem];
    [viewControllers addObject:categoriesNavigationController];
    
    UIViewController *crSavedProductsController = [[UIViewController alloc] init];
    UINavigationController *savedNavigationController = [[UINavigationController alloc] initWithRootViewController:crSavedProductsController];
    UITabBarItem* savedTabBarItem = [[UITabBarItem alloc] init];
    [savedTabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"ICN_saved_ON"]
                   withFinishedUnselectedImage: [UIImage imageNamed: @"ICN_saved"]];
    crSavedProductsController.view.backgroundColor = [UIColor purpleColor];
    [savedNavigationController setTabBarItem: savedTabBarItem];    
    [viewControllers addObject:savedNavigationController];    
    
    UIViewController *crSearchController = [[UIViewController alloc] init ];
    UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:crSearchController];
    UITabBarItem* searchTabBarItem = [[UITabBarItem alloc] init];
    [searchTabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"ICN_tab_search_ON"]
                    withFinishedUnselectedImage: [UIImage imageNamed: @"ICN_tab_search"]];
    crSearchController.view.backgroundColor = [UIColor brownColor];
    [searchNavigationController setTabBarItem: searchTabBarItem];    
    [viewControllers addObject:searchNavigationController];    
    
    UIViewController *crRecentProductsController = [[UIViewController alloc] init ];
    UINavigationController *recentNavigationProductsController = [[UINavigationController alloc] initWithRootViewController:crRecentProductsController];
    UITabBarItem* recentTabBarItem = [[UITabBarItem alloc] init];
    [recentTabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"ICN_recent_ON"]
                    withFinishedUnselectedImage: [UIImage imageNamed: @"ICN_recent"]];
    crRecentProductsController.view.backgroundColor = [UIColor redColor];
    [recentNavigationProductsController setTabBarItem: recentTabBarItem];    
    [viewControllers addObject:recentNavigationProductsController];    
    
    UIViewController *crAccountsController = [[UIViewController alloc] init ];
    UINavigationController *accountsNavigationController = [[UINavigationController alloc] initWithRootViewController:crAccountsController];
    UITabBarItem* accountTabBarItem = [[UITabBarItem alloc] init];
    [accountTabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"ICN_account_ON"]
                     withFinishedUnselectedImage: [UIImage imageNamed: @"ICN_account"]];
    crAccountsController.view.backgroundColor = [UIColor yellowColor];
    [accountsNavigationController setTabBarItem: accountTabBarItem];    
    [viewControllers addObject:accountsNavigationController];    
    
    UIViewController *crBrandsViewController = [[UIViewController alloc] init ];
    UINavigationController *brandsNavigationController = [[UINavigationController alloc] initWithRootViewController:crBrandsViewController];
    UITabBarItem *brandsTabBarItem = [[UITabBarItem alloc] init];
    [brandsTabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"ICN_brand_ON"]
                    withFinishedUnselectedImage: [UIImage imageNamed: @"ICN_brand"]];
    crBrandsViewController.view.backgroundColor = [UIColor whiteColor];
    [brandsNavigationController setTabBarItem: brandsTabBarItem];    
    [viewControllers addObject:brandsNavigationController];
    
    
    UIViewController *crAboutController = [[UIViewController alloc] init ];
    UINavigationController *aboutNavigationController = [[UINavigationController alloc] initWithRootViewController:crAboutController];
    UITabBarItem* aboutTabBarItem = [[UITabBarItem alloc] init];
    [aboutTabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"ICN_tab_info_ON"]
                   withFinishedUnselectedImage: [UIImage imageNamed: @"ICN_tab_info"]];
    crAboutController.view.backgroundColor = [UIColor greenColor];
    [aboutNavigationController setTabBarItem: aboutTabBarItem];    
    [viewControllers addObject:aboutNavigationController];    
    
	tabBarController.delegate = self;
	tabBarController.viewControllers = viewControllers;
    
    [self.window addSubview:[tabBarController view]];
    self.window.rootViewController = tabBarController;
}

@end
