//
//  OnlineFriendsViewController.h
//  objcToxBot
//
//  Created by Chuong Vu on 9/5/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnlineFriendsViewControllerDelegate <NSObject>

- (NSInteger)numberOfOnlineFriends;
- (NSString *)nicknameForIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectFriendAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface OnlineFriendsViewController : UIViewController

@property (nonatomic, weak) id<OnlineFriendsViewControllerDelegate> delegate;

@end
