//
//  AZSeekBar.m
//  WellRun
//
//  Created by Paolo Rossignoli on 05/02/14.
//  Copyright (c) 2014 Paolo Rossignoli. All rights reserved.
//

#import "PRSeekBar.h"

@implementation PRSeekBar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
         //[self setupUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setupUI];
    }
    return self;
}

-(void)setupUI {
    [self setHandleType:EFBigCircle];
    self.handleColor = [UIColor whiteColor];
    self.unfilledColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.filledColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    self.lineWidth = 6;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
