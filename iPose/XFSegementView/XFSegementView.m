//
//  XFSegement.m
//  XFSegementLabel
//
//  Created by 李雪峰 on 16/1/29.
//  Copyright © 2016年 hfuu. All rights reserved.
//
#define ItemWidth self.frame.size.width/_titleArray.count
#define ItemHeight self.frame.size.height
#define NavBarColor [UIColor colorWithRed:234/255.0f green:114/255.0f blue:60/255.0f alpha:1]
#import "XFSegementView.h"

@implementation XFSegementView

#pragma mark getter方法
- (UIColor *)titleColor{
    if (!_titleColor) {
        _titleColor = [UIColor blackColor];
    }
    return _titleColor;
}

- (CGFloat)titleFont{
    if (!_titleFont) {
        _titleFont = 16.0;
    }
    return _titleFont;
}

- (UIColor *)titleSelectedColor{
    if (!_titleSelectedColor) {
        _titleSelectedColor = NavBarColor;
    }
    return _titleSelectedColor;
}

- (UIColor *)separateColor{
    if (!_separateColor) {
        _separateColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    }
    return _separateColor;
}

- (UIColor *)scrollLineColor{
    if (!_scrollLineColor) {
        _scrollLineColor = NavBarColor;
    }
    return _scrollLineColor;
}

- (float)scrollLineHeight{
    if (!_scrollLineHeight) {
        _scrollLineHeight = 3.0;
    }
    return _scrollLineHeight;
}

- (float)separateHeight{
    if (!_separateHeight) {
        _separateHeight = 0.5;
    }
    return _separateHeight;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addPropertyObserver];
        [self configSubLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addPropertyObserver];
    [self configSubLabel];
}

//- (BOOL)haveNoRightLine{
//    if (!_haveRightLine) {
//        _haveRightLine = YES;
//    }
//    return _haveRightLine;
//}

- (void)addPropertyObserver{
    [self addObserver:self forKeyPath:@"titleColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"titleSelectedColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"titleFont" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"scrollLineColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"separateColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"scrollLineHeight" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"separateHeight" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"titleArray" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"haveRightLine" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"titleColor"];
    [self removeObserver:self forKeyPath:@"titleSelectedColor"];
    [self removeObserver:self forKeyPath:@"titleFont"];
    [self removeObserver:self forKeyPath:@"separateColor"];
    [self removeObserver:self forKeyPath:@"scrollLineColor"];
    [self removeObserver:self forKeyPath:@"scrollLineHeight"];
    [self removeObserver:self forKeyPath:@"separateHeight"];
    [self removeObserver:self forKeyPath:@"titleArray"];
    [self removeObserver:self forKeyPath:@"haveRightLine"];
}

//根据titleArray配置label
- (void)configSubLabel{
    //移除所有子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (int i = 0;  i < self.titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * ItemWidth, 0, ItemWidth, ItemHeight)];
        titleLabel.text = [self.titleArray objectAtIndex:i];
        titleLabel.textColor =  self.titleColor;
        titleLabel.font = [UIFont systemFontOfSize:self.titleFont];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (_haveRightLine) {
            if (i < self.titleArray.count - 1) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(ItemWidth - 0.5, ItemHeight/7*2, 1, ItemHeight/7*3)];
                [line setBackgroundColor:[UIColor lightGrayColor]];
                [titleLabel addSubview:line];
            }
        }
        titleLabel.tag = 100+i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLabelWithGesture:)];
        tap.numberOfTapsRequired = 1;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:tap];
        
        [self addSubview:titleLabel];
    }
    
    [self selectLabelWithIndex:0];

    //分割线
    _separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, ItemHeight - _separateHeight, self.frame.size.width, self.separateHeight)];
    [_separateLine setBackgroundColor:self.separateColor];
    
    //滚动条
    _scrollLine = [[UIView alloc]initWithFrame:CGRectMake(0, ItemHeight - self.scrollLineHeight, ItemWidth, self.scrollLineHeight)];
    [_scrollLine setBackgroundColor:self.scrollLineColor];
    
    [self addSubview:_separateLine];
    [self addSubview:_scrollLine];
}

//点击第几个label触发回调
- (void)touchLabelWithGesture:(UITapGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    NSInteger index = label.tag - 100;
    
    [self selectLabelWithIndex:index];

}

//选中指定位置label
- (void)selectLabelWithIndex:(NSInteger)index{
    UILabel *selectedLabel = [self viewWithTag:index+100];
    for (int i = 0; i < self.titleArray.count; i++) {
        UILabel *label = [self viewWithTag:100+i];
        if ([label isEqual:selectedLabel]) {
            label.textColor = self.titleSelectedColor;
        }else{
            label.textColor = self.titleColor;
        }
    }
    CGRect scrollLineFrame = _scrollLine.frame;
    scrollLineFrame.origin.x = ItemWidth*index;
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollLine setFrame:scrollLineFrame];
    }];
    if ([self.touchDelegate respondsToSelector:@selector(touchLabelWithIndex:)]) {
        [self.touchDelegate touchLabelWithIndex:index];
    }
    
}

- (void)changeTitleColorWithColor:(UIColor *)color{
    for (int i = 0; i < _titleArray.count; i ++) {
        UILabel *label = [self viewWithTag:100+i];
        label.textColor = color;
    }
}

- (void)changeTitleLabelFontWithFont:(CGFloat)font{
    for (int i = 0; i < _titleArray.count; i ++) {
        UILabel *label = [self viewWithTag:100+i];
        label.font = [UIFont systemFontOfSize:font];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"titleColor"]) {
        
        [self changeTitleColorWithColor:_titleColor];
        
    }else if ([keyPath isEqualToString:@"titleSelectedColor"]){
        
        NSInteger index = _scrollLine.frame.origin.x/ItemWidth;
        UILabel *label = [self viewWithTag:index + 100];
        label.textColor = _titleSelectedColor;
        
    }else if ([keyPath isEqualToString:@"titleFont"]){
        
        [self changeTitleLabelFontWithFont:_titleFont];
        
    }else if ([keyPath isEqualToString:@"scrollLineColor"]){
        
        [_scrollLine setBackgroundColor:_scrollLineColor];
        
    }else if ([keyPath isEqualToString:@"separateColor"]){
        
        [_separateLine setBackgroundColor:_separateColor];
        
    }else if ([keyPath isEqualToString:@"scrollLineHeight"]){
        
        CGRect scrollLineFrame = _scrollLine.frame;
        scrollLineFrame.origin.y = ItemHeight - _scrollLineHeight;
        scrollLineFrame.size.height = _scrollLineHeight;
        [_scrollLine setFrame:scrollLineFrame];
        
    }else if ([keyPath isEqualToString:@"separateHeight"]){
        
        CGRect separateLineFrame = _separateLine.frame;
        separateLineFrame.size.height = _separateHeight;
        separateLineFrame.origin.y = ItemHeight - _separateHeight;
        [_separateLine setFrame:separateLineFrame];
        
    }else if ([keyPath isEqualToString:@"titleArray"]){
        
        [self configSubLabel];
        
    }else if ([keyPath isEqualToString:@"haveRightLine"]){
        
        [self configSubLabel];
        
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com