//
//  FlippingViewViewController.h
//  FlippingView
//
//  Created by ROGER CHENG on 6/3/11.
//  Copyright 2011 ROC Solutions Inc. All rights reserved.
//

#import <UIKit/UIKit.h>  
#import <iAd/ADBannerView.h>

//testing code
@interface FlippingViewViewController : UIViewController<UIAlertViewDelegate, ADBannerViewDelegate> {
    int _openTiles;
    NSString *_currentLetter;
    NSMutableArray *_containerList;
    BOOL _finishedAnimation;
    NSTimer *_timer;
    BOOL _needToReset;
    NSArray *_alphaArray;
    NSMutableArray *_gameLetters;
    NSMutableArray *_usedRandomList;
    IBOutlet UIView *_gameView;
    IBOutlet UIView *_menuView;
    IBOutlet UIView *_configView;
    ADBannerView *_adView;
    int _numberOfXTiles;
    int _numberOfYTiles;
    int _totalTiles;
    IBOutlet UITextField *_xText;
    IBOutlet UITextField *_yText;
    IBOutlet UILabel *_xMax;
    IBOutlet UILabel *_yMax;
    IBOutlet UISegmentedControl *_tileSize;
    IBOutlet UILabel *_warning;
    IBOutlet UIButton *_saveButton;
    int _TILE_WIDTH;
    int _TILE_HEIGHT;
}

@property (nonatomic, retain) NSArray *alphaArray;
@property (nonatomic, retain) NSMutableArray *gameLetters;
@property int openTiles;
@property (nonatomic, retain) NSString *currentLetter;
@property (nonatomic, retain) NSMutableArray *containerList;
@property BOOL fininshedAnimation;
@property (nonatomic, retain) NSTimer *timer;
@property BOOL needToReset;
@property (nonatomic, retain) NSMutableArray *usedRandomList;
@property (nonatomic, retain) ADBannerView *adView;
@property int numberOfXTiles;
@property int numberOfYTiles;
@property int totalTiles;
@property int TILE_WIDTH;
@property int TILE_HEIGHT;

-(void)disableTiles :(NSString *)letter;
-(void)resetTiles;

@end
