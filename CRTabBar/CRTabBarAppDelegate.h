//
//  CRTabBarAppDelegate.h
//  CRTabBar
//
//  Created by Constantinos Mavromoustakos on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRTabBarController.h"

@interface CRTabBarAppDelegate : UIResponder <UIApplicationDelegate, CRTabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
