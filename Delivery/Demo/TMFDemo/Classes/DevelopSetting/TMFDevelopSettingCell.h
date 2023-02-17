//
//  TMFDevelopSettingCell.h
//  TMFDemo
//
//  Created by v_zwtzzhou on 2021/10/9.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TMFDevelopSettingCell;
@protocol TMFDevelopSettingCellDelegate <NSObject>
@optional
- (void)switchButtonCell:(TMFDevelopSettingCell *)cell changeValue:(BOOL)value;
@end

@interface TMFDevelopSettingCell : UITableViewCell

/**
 @brief UISwitch,用来控制是否使用新协议进行网络请求
 */
@property (nonatomic, strong) UISwitch *swButton;

/**
 @brief TMFDevelopSettingCellDelegate
 */
@property (nonatomic, weak) id<TMFDevelopSettingCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
