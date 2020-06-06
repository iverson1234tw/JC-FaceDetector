//
//  UIImageView+ReSize.h
//  FaceDetector
//
//  Created by iverson1234tw on 2020/6/7.
//  Copyright © 2020 josh.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ReSize)

// 調整ImageView大小及x,y軸位置
- (void)resizeFrameByImage:(CGRect)rect;

@end

