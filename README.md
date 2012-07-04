# CRTabBarController

This is a custom container view controller for iOS 5 that works just like a regular UITabBarController, except the tabs are at the buttom and the more button expands up instead of taking you to a new table controller.

![Screenshot](https://github.com/cmavromoustakos/crtabbar/raw/master/Screenshot.jpg)
![Screenshot](https://github.com/cmavromoustakos/crtabbar/raw/master/Screenshot2.jpg)


To use:

Declare your app delegate @interface CRTabBarAppDelegate : UIResponder <UIApplicationDelegate, CRTabBarControllerDelegate>

And setup your controllers

     UIViewController *crCategoriesslidingViewController = [[UIViewController alloc] init];
    UINavigationController *categoriesNavigationController = [[UINavigationController alloc] initWithRootViewController:crCategoriesslidingViewController];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] init];
    [tabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"ICN_home_ON"]
              withFinishedUnselectedImage: [UIImage imageNamed: @"ICN_home"]];
    [categoriesNavigationController setTabBarItem: tabBarItem];
    [viewControllers addObject:categoriesNavigationController];

The case above is a view controller wrapped in a navigation controller so we can push other views if we want to from the controller that was loaded.

The code is a compulation of 

https://github.com/hollance/MHTabBarController/

And

https://github.com/brendandixon/ExpandableTabBar


Thanks to Joe Scarano http://joescarano.com/ For the tab bar images.