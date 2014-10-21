//  InstaSelfie
//
//  Created by cheskiewicz on 10/20/14.
//  Copyright (c) 2014 Rymegan LLc. All rights reserved.
//

#import "CollectionViewController.h"
#import "InstagramKit.h"
#import "UIImageView+AFNetworking.h"
#import "Cell.h"
#import "InstagramMedia.h"
#import "InstagramUser.h"
#import "MediaViewController.h"

@interface CollectionViewController ()
{
    NSMutableArray *mediaArray;
    __weak IBOutlet UITextField *textField;
}
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@end

@implementation CollectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        mediaArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMedia];
}

- (IBAction)reloadMedia
{
    self.currentPaginationInfo = nil;
    if (mediaArray) {
        [mediaArray removeAllObjects];
    }

    [self loadMedia];
}

- (void)loadMedia
{
    
    [self getSelfieMedia];

}

- (void)getSelfUserDetails
{
    [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:^(InstagramUser *userDetail) {
        NSLog(@"%@",userDetail);
    } failure:^(NSError *error) {
        
    }];
}


- (void)getSelfieMedia
{
    [[InstagramEngine sharedEngine] getMediaWithTagName:@"selfie" count:30 maxId:self.currentPaginationInfo.nextMaxId withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        self.currentPaginationInfo = paginationInfo;
        [mediaArray addObjectsFromArray:media];
        [self reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"Search Media Failed");
    }];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue.media.detail"]) {
        MediaViewController *mvc = (MediaViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathsForSelectedItems][0];
        InstagramMedia *media = mediaArray[selectedIndexPath.item];
        mvc.media = media;
    }

}

#pragma mark - UICollectionViewDelegate -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mediaArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPCELL" forIndexPath:indexPath];
    
    if (mediaArray.count >= indexPath.row+1) {
        InstagramMedia *media = mediaArray[indexPath.row];
        [cell.imageView setImageWithURL:media.thumbnailURL];
    }
    else
        [cell.imageView setImage:nil];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if (self.currentPaginationInfo)
    {

    }
}

#pragma mark - ReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    InstagramMedia *media = mediaArray[fromIndexPath.row];
    [mediaArray removeObjectAtIndex:fromIndexPath.item];
    [mediaArray insertObject:media atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;

}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {

    return YES;

}

#pragma mark - ReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did end drag");
}

@end
