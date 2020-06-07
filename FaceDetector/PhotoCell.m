//
//  PhotoCell.m
//  FaceDetector
//
//  Created by iverson1234tw on 2020/6/8.
//  Copyright © 2020 josh.chen. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initialize];
        
    }
 
    return self;
}

- (void)initialize {
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, SCREEN_WIDTH/3)];
    
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.backgroundColor = [UIColor blackColor];
    
    [self.contentView addSubview:_imageView];
    
}

@end
