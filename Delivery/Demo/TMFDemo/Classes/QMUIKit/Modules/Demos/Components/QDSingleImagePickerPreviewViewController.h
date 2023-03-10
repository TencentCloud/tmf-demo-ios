//
//  QDSingleImagePickerPreviewViewController.h
//  qmuidemo
//
//  Created by QMUI Team on 15/5/17.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "QDCommonUI.h"
#import "QDUIHelper.h"
#import "QDThemeManager.h"

@class QDSingleImagePickerPreviewViewController;

@protocol QDSingleImagePickerPreviewViewControllerDelegate <QMUIImagePickerPreviewViewControllerDelegate>

@required
- (void)imagePickerPreviewViewController:(QDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset;

@end

@interface QDSingleImagePickerPreviewViewController : QMUIImagePickerPreviewViewController

@property(nonatomic, weak) id<QDSingleImagePickerPreviewViewControllerDelegate> delegate;
@property(nonatomic, strong) QMUIAssetsGroup *assetsGroup;

@end
