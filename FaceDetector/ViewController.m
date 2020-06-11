//
//  ViewController.m
//  FaceDetector
//
//  Created by iverson1234tw on 2020/6/6.
//  Copyright © 2020 josh.chen. All rights reserved.
//

#import "ViewController.h"
#import "SingleFaceViewController.h"
#import "GroupFaceViewController.h"
#import "PhonePhotoViewController.h"

@import Photos;

#define CellLabel @[@"SinglePhotoDetect", @"GroupPhotoDetect", @"PhonePhotoDetect"]

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic , strong) PHFetchResult *assetsFetchResults;
@property(nonatomic , strong) PHCachingImageManager *imageManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - _topView.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    cell.textLabel.text = CellLabel[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        
        SingleFaceViewController *single = [[SingleFaceViewController alloc] init];
        
        [self presentViewController:single animated:YES completion:nil];
        
    } else if (indexPath.row == 1) {
        
        GroupFaceViewController *group = (GroupFaceViewController *)[[UIStoryboard storyboardWithName:
                                                                      @"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"GroupFaceViewController"];
        
        [self presentViewController:group animated:YES completion:nil];
        
    } else {
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        _assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];        
        
        PhonePhotoViewController *phone = (PhonePhotoViewController *)[[UIStoryboard storyboardWithName:
                                                                       @"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PhonePhotoViewController"];
        
        phone.assetsFetchResults = _assetsFetchResults;
        
        [self presentViewController:phone animated:YES completion:nil];
        
    }
    
}

@end
