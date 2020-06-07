//
//  SquareBox.m
//  FaceDetector
//
//  Created by iverson1234tw on 2020/6/7.
//  Copyright © 2020 josh.chen. All rights reserved.
//

#import "SquareBox.h"

@implementation SquareBox

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2;
        
    }
    return self;
}

@end
