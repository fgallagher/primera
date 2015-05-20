//
//  PRAppDelegate.h
//  Audioplayer
//
//  Created by Paolo Rossignoli on 11/02/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface PRAppDelegate : UIResponder <UIApplicationDelegate>
+ (void)storyBoradAutoLay:(UIView *)allView;
@property (strong, nonatomic) UIWindow *window;
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@end
