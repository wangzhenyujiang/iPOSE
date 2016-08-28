//
//  XFSegement.h
//  XFSegementLabel
//
//  Created by 李雪峰 on 16/1/29.
//  Copyright © 2016年 hfuu. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void (^TouchLabelIndexBlock)();

@protocol TouchLabelDelegate <NSObject>

- (void)touchLabelWithIndex:(NSInteger)index;

@end

@interface XFSegementView : UIView
/**
 *  标题数组
 */
@property ( nonatomic, strong) NSArray *titleArray;

/**
 *  标题颜色
 */
@property ( nonatomic, strong) UIColor *titleColor;

/**
 *  标题被选中的颜色
 */
@property ( nonatomic, strong) UIColor *titleSelectedColor;

/**
 *  滚动条
 */
@property ( nonatomic, strong) UIView *scrollLine;

/**
 *  滚动条颜色
 */
@property ( nonatomic, strong) UIColor *scrollLineColor;

/**
 *  分割线颜色
 */
@property ( nonatomic, strong) UIColor *separateColor;

/**
 *  分割线
 */
@property ( nonatomic, strong) UIView *separateLine;

/**
 *  滚动条高度
 */
@property ( nonatomic, assign) float scrollLineHeight;

/**
 *  分割线高度
 */
@property ( nonatomic, assign) float separateHeight;

/**
 *  标题字体大小
 */
@property ( nonatomic, assign) CGFloat titleFont;

/**
 *  是否有竖直分割线
 */
@property ( nonatomic, assign) BOOL haveRightLine;


@property ( nonatomic, strong) id<TouchLabelDelegate>touchDelegate;

//根据titleArray配置label
- (void)configSubLabel;

//选中指定位置label
- (void)selectLabelWithIndex:(NSInteger)index;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com