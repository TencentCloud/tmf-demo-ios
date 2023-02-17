//
//  TMFDevelopSettingCell.m
//  TMFDemo
//
//  Created by v_zwtzzhou on 2021/10/9.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TMFDevelopSettingCell.h"

@implementation TMFDevelopSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _swButton = [[UISwitch alloc] init];
        [self.contentView addSubview:_swButton];
        _swButton.center = CGPointMake(CGRectGetWidth(self.bounds) - 35, CGRectGetHeight(self.bounds) / 2);
        _swButton.autoresizingMask
            = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_swButton addTarget:self action:@selector(clickSwButton:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)clickSwButton:(UISwitch *)swButton{
    if ([self.delegate respondsToSelector:@selector(switchButtonCell:changeValue:)]) {
        [self.delegate switchButtonCell:self changeValue:swButton.isOn];
    }
}

@end
