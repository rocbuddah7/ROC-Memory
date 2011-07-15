//
//  FlippingViewAppDelegate.h
//  FlippingView
//
//  Created by ROGER CHENG on 6/3/11.
//  Copyright 2011 ROC Solutions Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlippingViewViewController;

@interface FlippingViewAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet FlippingViewViewController *viewController;

@end
