//
//  SGAppDelegate.h
//  Exemple App
//
//  Created by Michele Amati on 8/21/12.
//  Copyright (c) 2012 apexnet.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
