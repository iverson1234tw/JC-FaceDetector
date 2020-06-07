//
//  PhonePhotoViewController.m
//  FaceDetector
//
//  Created by iverson1234tw on 2020/6/8.
//  Copyright © 2020 josh.chen. All rights reserved.
//

#import "PhonePhotoViewController.h"
#import "PhotoCell.h"

@interface PhonePhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    PhotoCell *photoCell;
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation PhonePhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    _imageManager = [[PHCachingImageManager alloc] init];
    
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

- (IBAction)backButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_assetsFetchResults count];
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
    
    PHAsset *asset = _assetsFetchResults[indexPath.item];
    
    [_imageManager requestImageForAsset:asset targetSize:CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
       
        NSLog(@"%@", result);
        
        self->photoCell.imageView.image = result;
        
    }];
    
    return photoCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
}

@end
