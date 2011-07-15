//
//  TileView.h
//  FlippingView
//
//  Created by ROGER CHENG on 6/4/11.
//  Copyright 2011 ROC Solutions Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContainerView;

@interface TileView : UIView {
    NSString *_letter;
    BOOL _isFront;
}

@property (nonatomic, retain) NSString *letter;
@property BOOL isFront;

- (id)initWithFrame:(CGRect)frame :(NSString *)letter : (BOOL)isFront;

@end
