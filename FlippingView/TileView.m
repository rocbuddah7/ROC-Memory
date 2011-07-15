//
//  TileView.m
//  FlippingView
//
//  Created by ROGER CHENG on 6/4/11.
//  Copyright 2011 ROC Solutions Inc. All rights reserved.
//

#import "TileView.h"
#import "ContainerView.h"

@implementation TileView
@synthesize isFront = _isFront;
@synthesize letter = _letter;

- (id)initWithFrame:(CGRect)frame :(NSString *)letter : (BOOL)isFront
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _letter = letter;
        _isFront = isFront;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (_isFront){
        [[UIColor whiteColor] set];
        //[_letter drawInRect:rect withFont:[UIFont fontWithName:@"Helvetica-Bold" size:72]];
        [_letter drawAtPoint:CGPointMake(25, 10) withFont:[UIFont fontWithName:@"Helvetica-Bold" size:72]];
    }
}


- (void)dealloc
{
    [_letter release];
    _letter = nil;
    [super dealloc];
}

@end
