//
//  SingleFaceViewController.m
//  FaceDetector
//
//  Created by iverson1234tw on 2020/6/7.
//  Copyright © 2020 josh.chen. All rights reserved.
//

#import "SquareBox.h"
#import "ViewController.h"
#import "UIImageView+ReSize.h"
#import "SingleFaceViewController.h"
#import <AVFoundation/AVFoundation.h>

@import Vision;

@interface SingleFaceViewController (){
    MBProgressHUD *hud;
    UIImage *photo;
}
@property (strong, nonatomic) UIImageView *photoImageView;

@end

@implementation SingleFaceViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    photo = [UIImage imageNamed:@"me"];
    
    _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _photoImageView.image = photo;
    
    [self.view addSubview:self.photoImageView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPrevious:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Face Detecting";
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    [self faceDetector:photo];
    
}

// 偵測臉部位置
- (void)faceDetector:(UIImage *)image {
    
    __weak typeof(self) weakSelf = self;
    
    // 轉換為CIImage
    CIImage *convertImage = [[CIImage alloc] initWithImage:image];
    
    // 取得Image的Rect
    CGRect imageRect = AVMakeRectWithAspectRatioInsideRect(_photoImageView.image.size, _photoImageView.bounds);
    
    // 重置Imageview的位置及大小
    [_photoImageView resizeFrameByImage:imageRect];
    
    VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:convertImage options:@{}];
    
    VNRequestCompletionHandler completionHandler = ^(VNRequest *request, NSError *error) {
        
        NSArray *observations = request.results;
        
        for (VNFaceObservation *observation  in observations) {
            
            CGRect facePointRect = [weakSelf convertRect:observation.boundingBox imageSize:imageRect.size];
            
            // 添加臉部框位置
            SquareBox *box = [[SquareBox alloc] initWithFrame:facePointRect];
            
            [weakSelf.photoImageView addSubview:box];
            
        }
        
        [self->hud hide:YES];
        
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

- (void)backToPrevious:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
