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
        CGRect viewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:(self.frame.size.height * 0.75)];
        CGSize size = [_letter sizeWithFont:font];
        float x_pos = (viewRect.size.width - size.width)/2;
        float y_pos = (viewRect.size.height - size.height)/2;
        [[UIColor whiteColor] set];
        //[_letter drawInRect:rect withFont:[UIFont fontWithName:@"Helvetica-Bold" size:72]];
        [_letter drawAtPoint:CGPointMake(x_pos, y_pos) withFont:font];

    }
}


- (void)dealloc
{
    [_letter release];
    _letter = nil;
    [super dealloc];
}

@end
