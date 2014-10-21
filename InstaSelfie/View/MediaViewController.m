//  InstaSelfie
//
//  Created by cheskiewicz on 10/20/14.
//  Copyright (c) 2014 Rymegan LLc. All rights reserved.
//

#import "MediaViewController.h"
#import "MediaCell.h"
#import "UIImageView+AFNetworking.h"
#import "InstagramKit.h"

@interface MediaViewController ()
{
    BOOL liked;
}
@end

@implementation MediaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"@%@",self.media.user.username];
    [self LoadCounts];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([[InstagramEngine sharedEngine] accessToken])?4:3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger retVal = 0;
    switch (indexPath.row) {
        case 0:
            retVal = 320;
            break;
            
        default:
            retVal = 50;
            break;
    }
    return retVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        MediaCell *cell = (MediaCell *)[tableView dequeueReusableCellWithIdentifier:@"MediaCell" forIndexPath:indexPath];
        [cell.mediaImageView setImageWithURL:self.media.thumbnailURL];
        [cell.mediaImageView setImageWithURL:self.media.standardResolutionImageURL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 1:
            {
                if ([[InstagramEngine sharedEngine] accessToken])
                {
                    if (liked) {
                        cell.textLabel.text = @"Unlike";
                    }
                    else
                    {
                        cell.textLabel.text = @"Like";
                    }
                    
                }
                else
                    cell.textLabel.text = [NSString stringWithFormat:@"%ld Likes",(long)self.media.likesCount];
            }
                break;
                
            case 2:
            {
                if ([[InstagramEngine sharedEngine] accessToken])
                    cell.textLabel.text = @"Test Comment";
                else
                    cell.textLabel.text = [NSString stringWithFormat:@"%ld Comments",(long)self.media.commentCount];
            }
                break;
                
            default:
            {
                cell.textLabel.text = @"Test";
            }
                break;
                
        }
        
        return cell;
    }
}


#pragma mark - Tests -

- (void)GetMedia
{
    [[InstagramEngine sharedEngine] getMedia:self.media.Id withSuccess:^(InstagramMedia *media) {
        NSLog(@"Load Media Successful");
    } failure:^(NSError *error) {
        NSLog(@"Loading Media Failed");
    }];
}

- (void)LoadCounts
{
    [self.media.user loadCountsWithSuccess:^{
        NSLog(@"Courtesy: %@. %ld media posts, follows %ld users and is followed by %ld users",self.media.user.username, (long)self.media.user.mediaCount, (long)self.media.user.followsCount, (long)self.media.user.followedByCount);
    } failure:^{
        NSLog(@"Loading User details failed");
    }];
    
}

- (void)Comments
{
    [[InstagramEngine sharedEngine] getCommentsOnMedia:self.media.Id withSuccess:^(NSArray *comments) {
        for (InstagramComment *comment in comments) {
            NSLog(@"@%@: %@",comment.user.username, comment.text);
        }
    } failure:^(NSError *error) {
        NSLog(@"Could not load comments");
    }];
}

- (void)GetLikes
{
    [[InstagramEngine sharedEngine] getLikesOnMedia:self.media.Id withSuccess:^(NSArray *likedUsers) {
        for (InstagramUser *user in likedUsers) {
            NSLog(@"Like : @%@",user.username);
        }
    } failure:^(NSError *error) {
        NSLog(@"Could not load likes");
    }];
}


@end
