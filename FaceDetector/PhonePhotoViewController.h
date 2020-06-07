//
//  PhonePhotoViewController.h
//  FaceDetector
//
//  Created by iverson1234tw on 2020/6/8.
//  Copyright © 2020 josh.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

@interface PhonePhotoViewController : UIViewController

@property(nonatomic , strong) PHFetchResult *assetsFetchResults;
@property(nonatomic , strong) PHCachingImageManager *imageManager;

@end

