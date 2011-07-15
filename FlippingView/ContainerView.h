//
//  ContainerView.h
//  FlippingView
//
//  Created by ROGER CHENG on 6/4/11.
//  Copyright 2011 ROC Solutions Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileView.h"
#import "FlippingViewViewController.h"
@interface ContainerView : UIView {
    BOOL _displayingPrimary;
    BOOL _isLocked;
    TileView *_frontTile;
    TileView *_backTile;
    FlippingViewViewController *_viewController;
}
@property (nonatomic, retain) FlippingViewViewController *viewController;
@property (nonatomic, retain) TileView *frontTile;
@property (nonatomic, retain) TileView *backTile;
@property BOOL displayingPrimary;
@property BOOL isLocked;

- (id)initWithFrame:(CGRect)frame : (NSString *)letter;
-(void)flipViews :(BOOL)addDelay;


@end
