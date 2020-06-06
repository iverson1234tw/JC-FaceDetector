//
//  ViewController.m
//  FaceDetector
//
//  Created by iverson1234tw on 2020/6/6.
//  Copyright © 2020 josh.chen. All rights reserved.
//

#import "SquareBox.h"
#import "ViewController.h"
#import "UIImageView+ReSize.h"
#import <AVFoundation/AVFoundation.h>

@import CoreML;
@import Vision;

@interface ViewController () {
    UIImage *photo;
}
@property (strong, nonatomic) UIImageView *photoImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    photo = [UIImage imageNamed:@"me"];
    
    _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _photoImageView.image = photo;
    
    [self faceDetector:photo];
    
    [self.view addSubview:_photoImageView];
    
}

// 偵測臉部位置
- (void)faceDetector:(UIImage *)image {
    
    // 轉換為CIImage
    CIImage *convertImage = [[CIImage alloc] initWithImage:image];
    
    // 取得Image的Rect
    CGRect imageRect = AVMakeRectWithAspectRatioInsideRect(self->_photoImageView.image.size, self->_photoImageView.bounds);
    
    // 重置Imageview的位置及大小
    [_photoImageView resizeFrameByImage:imageRect];
    
    VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:convertImage options:@{}];
    
    VNRequestCompletionHandler completionHandler = ^(VNRequest *request, NSError *error) {
        
        NSArray *observations = request.results;
        
        for (VNFaceObservation *observation  in observations) {
            
            CGRect facePointRect = [self convertRect:observation.boundingBox imageSize:imageRect.size];
            
            // 添加臉部框位置
            SquareBox *box = [[SquareBox alloc] initWithFrame:facePointRect];
            
            [self->_photoImageView addSubview:box];
            
        }
        
    };
    
    VNDetectFaceRectanglesRequest *detectRequest = [[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:completionHandler];
    
    [detectRequestHandler performRequests:@[detectRequest] error:nil];
    
}

// 轉換座標
- (CGRect)convertRect:(CGRect)oldRect imageSize:(CGSize)imageSize{
    
    CGFloat w = oldRect.size.width * imageSize.width;
    CGFloat h = oldRect.size.height * imageSize.height;
    CGFloat x = oldRect.origin.x * imageSize.width;
    CGFloat y = imageSize.height - (oldRect.origin.y * imageSize.height) - h;
    
    return CGRectMake(x, y, w, h);
}


@end
