//
//  UIImageView+ReSize.m
//  FaceDetector
//
//  Created by iverson1234tw on 2020/6/7.
//  Copyright © 2020 josh.chen. All rights reserved.
//

#import "UIImageView+ReSize.h"

@implementation UIImageView (ReSize)

- (void)resizeFrameByImage:(CGRect)rect {
    
    self.frame = CGRectMake(SCREEN_WIDTH/2 - rect.size.width/2, SCREEN_HEIGHT/2 - rect.size.height/2, rect.size.width, rect.size.height);
    
}

@end
