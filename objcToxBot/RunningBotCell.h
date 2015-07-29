//
//  RunningBotCell.h
//  objcToxBot
//
//  Created by Dmytro Vorobiov on 29/07/15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunningBotCell : UITableViewCell

@property (strong, nonatomic) NSString *botIdentifier;
@property (strong, nonatomic) NSString *connectionStatus;
@property (strong, nonatomic) UIColor *connectionStatusColor;
@property (strong, nonatomic) NSString *userAddress;

@end
