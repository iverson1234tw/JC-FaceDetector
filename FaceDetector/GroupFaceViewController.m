//
//  GroupFaceViewController.m
//  FaceDetector
//
//  Created by iverson1234tw on 2020/6/7.
//  Copyright © 2020 josh.chen. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "GroupFaceViewController.h"
#import "PhotoCell.h"
#import "SquareBox.h"

@import Vision;

@interface GroupFaceViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    PhotoCell *photoCell;
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) NSMutableArray *photoArr;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation GroupFaceViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    _photoArr = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 5; i ++) {
        [_photoArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"0%d", i]]];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - _topView.frame.size.height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_collectionView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.detailsLabelText = @"Face Detecting";
    
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_photoArr count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    photoCell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier"
                                                                                forIndexPath:indexPath];
    
    photoCell.imageView.image = [_photoArr objectAtIndex:indexPath.row];
    
    [self faceDetectorFromImageView:photoCell.imageView withImage:[_photoArr objectAtIndex:indexPath.row]];
    
    return photoCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
}

// 偵測臉部位置
- (void)faceDetectorFromImageView:(UIImageView *)imageView withImage:(UIImage *)image {
    
    __weak typeof(self) weakSelf = self;
    
    // 轉換為CIImage
    CIImage *convertImage = [[CIImage alloc] initWithImage:image];
    
    // 取得Image的Rect
    CGRect imageRect = AVMakeRectWithAspectRatioInsideRect(imageView.image.size, imageView.bounds);
    
    // 重置Imageview的位置及大小
    VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:convertImage options:@{}];
    
    VNRequestCompletionHandler completionHandler = ^(VNRequest *request, NSError *error) {
        
        NSArray *observations = request.results;
        
        for (VNFaceObservation *observation  in observations) {
            
            CGRect facePointRect = [weakSelf convertRect:observation.boundingBox imageSize:imageRect.size];
            
            // 添加臉部框位置
            SquareBox *box = [[SquareBox alloc] initWithFrame:facePointRect];
            
            [imageView addSubview:box];
            
        }
        
        [self->hud hide:YES];
        
    };
    
    VNDetectFaceRectanglesRequest *detectRequest = [[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:completionHandler];
    
    [detectRequestHandler performRequests:@[detectRequest] error:nil];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row) {
        
        [hud hide:YES];
        
    }
    
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
