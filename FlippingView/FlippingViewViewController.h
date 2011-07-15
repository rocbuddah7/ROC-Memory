//
//  FlippingViewViewController.h
//  FlippingView
//
//  Created by ROGER CHENG on 6/3/11.
//  Copyright 2011 ROC Solutions Inc. All rights reserved.
//

#import <UIKit/UIKit.h>   

@interface FlippingViewViewController : UIViewController<UIAlertViewDelegate> {
    int _openTiles;
    NSString *_currentLetter;
    NSMutableArray *_containerList;
    BOOL _finishedAnimation;
    NSTimer *_timer;
    BOOL _needToReset;
    NSArray *_alphaArray;
    NSMutableArray *_gameLetters;
    NSMutableArray *_usedRandomList;
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

-(void)disableTiles :(NSString *)letter;
-(void)resetTiles;

@end
