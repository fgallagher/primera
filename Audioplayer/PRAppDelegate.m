//
//  PRAppDelegate.m
//  Audioplayer
//
//  Created by Paolo Rossignoli on 11/02/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import "PRAppDelegate.h"
#import "YISplashScreen.h"
#import "PRArtwork.h"
#import "FXBlurView.h"

@implementation PRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [YISplashScreen show];
    // Override point for customization after application launch.
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar-background"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSLog(@"applicationDocumentsDirectory %@",[self applicationDocumentsDirectory] );
    PRAppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
     //iphone6 W375.0/320 H667.0/568;
    if(ScreenHeight > 480||ScreenHeight<=480){
        myDelegate.autoSizeScaleX = ScreenWidth/320;
        myDelegate.autoSizeScaleY = ScreenHeight/568;
    }else{
        myDelegate.autoSizeScaleX = 1;
        myDelegate.autoSizeScaleY = 1;
    }
    [YISplashScreen hideWithAnimation:[YISplashScreenAnimation pageCurlAnimation]];
    
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

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


+ (void)storyBoradAutoLay:(UIView *)allView
{
    for (UIView *temp in allView.subviews) {
        temp.frame = CGRectMake1(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
        for (UIView *temp1 in temp.subviews) {
            temp1.frame = CGRectMake1(temp1.frame.origin.x, temp1.frame.origin.y, temp1.frame.size.width, temp1.frame.size.height);
            for (UIView *temp2 in temp1.subviews) {
                temp2.frame = CGRectMake1(temp2.frame.origin.x, temp2.frame.origin.y, temp2.frame.size.width, temp2.frame.size.height);
                for (UIView *temp3 in temp.subviews) {
                    temp3.frame = CGRectMake1(temp3.frame.origin.x, temp3.frame.origin.y, temp3.frame.size.width, temp3.frame.size.height);
                }
            }
        }
    }
}


CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    PRAppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    CGRect rect;
    rect.origin.x = x * myDelegate.autoSizeScaleX;
    rect.origin.y = y * myDelegate.autoSizeScaleY;
    rect.size.width = width * myDelegate.autoSizeScaleX;
    rect.size.height = height * myDelegate.autoSizeScaleY;
    return rect;
}

@end
