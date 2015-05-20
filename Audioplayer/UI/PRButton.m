//
//  PRButton.m
//  GetTheBeat
//
//  Created by Paolo Rossignoli on 08/02/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import "PRButton.h"

#define STD_BUTTON_HEIGHT   40

@implementation PRButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void) setupUI {
    
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.]];
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    [attrStr addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0, attrStr.length)];
    [self.titleLabel setAttributedText:attrStr];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth=1.0f;
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
}


- (float) getTopEdgeInsets {
    float buttonHeight = self.frame.size.height;
    float topEdgeInsets = STD_BUTTON_HEIGHT/2 - buttonHeight/2;
    return abs(topEdgeInsets);
}

- (void) setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
        [self setAlpha:1.f];
    } else {
        [self setAlpha:0.4f];
    }
}


@end
