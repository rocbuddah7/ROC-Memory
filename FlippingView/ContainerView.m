//
//  ContainerView.m
//  FlippingView
//
//  Created by ROGER CHENG on 6/4/11.
//  Copyright 2011 ROC Solutions Inc. All rights reserved.
//

#import "ContainerView.h"


@implementation ContainerView
@synthesize displayingPrimary = _displayingPrimary;
@synthesize frontTile = _frontTile;
@synthesize backTile = _backTile;
@synthesize viewController = _viewController;
@synthesize isLocked = _isLocked;

- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // re-enable user interaction when the flip is completed.
    _viewController.fininshedAnimation = YES;
}

-(void)performCheck{
    if (_viewController.currentLetter == nil){
        _viewController.currentLetter = _frontTile.letter;
    }else if (_viewController.currentLetter == _frontTile.letter){
        [_viewController disableTiles:_frontTile.letter];
    }else {
        [_viewController resetTiles];
    }    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_viewController.openTiles < 2){
        if (_isLocked){
            //NSLog(@"touchesBegan, %@ tile is locked", _frontTile.letter);
        }else if(_displayingPrimary){
            //NSLog(@"not doing anything cause you already clicked this");
        }
        else{
            [self flipViews:NO];
            [self performCheck];
        }
    }
}

-(void)flipViews :(BOOL)addDelay{
    _viewController.fininshedAnimation = NO;
    if (_viewController.openTiles >= 2){
        //NSLog(@"nothing done in flip view because 2 open tiles");
        return;        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
    if (_displayingPrimary){
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        [_frontTile removeFromSuperview];
    }else{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        [_backTile removeFromSuperview];    
    }
    if (_displayingPrimary){
        [self addSubview:_backTile];
        _viewController.openTiles--;
        _displayingPrimary = !_displayingPrimary;
    }else{
        [self addSubview:_frontTile];
        _viewController.openTiles++;
        _displayingPrimary = !_displayingPrimary;
    }
    [UIView commitAnimations];   
}

- (id)initWithFrame:(CGRect)frame : (NSString *)letter
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _frontTile = [[TileView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) :letter :YES];
        _frontTile.backgroundColor = [UIColor orangeColor];
        _backTile = [[TileView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) :letter :NO];
        _backTile.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:_backTile];
        _displayingPrimary = NO;
        _isLocked = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_frontTile release];
    _frontTile = nil;
    [_backTile release];
    _backTile = nil;
    [super dealloc];
}

@end
