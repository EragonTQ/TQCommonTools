//
//  TQSwitchViewButton.m
//  hqedu24olapp
//
//  Created by litianqi on 16/7/21.
//  Copyright © 2016年 edu24ol. All rights reserved.
//

#import "TQSwitchViewButton.h"
//#import "UIImage+Color.h"
#import "Masonry.h"
//#import "UIView+Extension.h"
//#import "UIColor+HexString.h"
//#import "UIColor+HQExtensionColor.h"
//#import "GoodsGroupProductListModel.h"


@interface UIView (TQViewExtention)
@property (nonatomic, assign) CGFloat tq_centerX;
@property (nonatomic, assign) CGFloat tq_width;
@end

@implementation UIView (TQViewExtention)

- (void)setTq_centerX:(CGFloat)tq_centerX
{
    CGPoint center = self.center;
    center.x = tq_centerX;
    self.center = center;
}

- (CGFloat)tq_centerX
{
    return self.center.x;
}

- (CGFloat)tq_width
{
    return self.frame.size.width;
}

- (void)setTq_width:(CGFloat)tq_width
{
    CGRect frame = self.frame;
    frame.size.width = tq_width;
    self.frame = frame;
}

@end



@interface TQSwitchViewButton ()
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign) CGSize flagSize;
@end
@implementation TQSwitchViewButton

//- (UIColor *)flagColor
//{
//    if (!_fl) {
//        0x408CFF
//    }
//}

- (void)setFlagSize:(CGSize)flagSize
{
    _flagSize = flagSize;
    CGRect frame = _flagLine.frame;
    frame.size.width = flagSize.width;
    frame.size.height = flagSize.height;
    _flagLine.frame = frame;
    
}

- (void)setFlagColor:(UIColor *)flagColor
{
    _flagColor = flagColor;
    _flagLine.backgroundColor = _flagColor;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame withFlagHeight:2];
}

- (id)initWithFrame:(CGRect)frame withFlagSize:(CGSize)flagSize
{
    if (self = [super initWithFrame:frame]) {
        _flagSize = flagSize;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-2)];
        [_scrollView setContentSize:CGSizeMake(frame.size.width,0)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-2);
        }];
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width ,1)];
        [_bottomLine setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:240.0/255.0 alpha:1]];
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self);
        }];
        
        
        _flagLine = [[UIView alloc] initWithFrame:CGRectMake(20,self.frame.size.height - 4-_flagSize.height,_flagSize.width ,_flagSize.height)];
        if (self.flagColor) {
            [_flagLine setBackgroundColor:self.flagColor];
        }else{
            [_flagLine setBackgroundColor:[UIColor colorWithRed:64.0/255.0 green:140.0/255.0 blue:255.0/255.0 alpha:1]];
        }
       
        [self addSubview:_flagLine];
 
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withFlagHeight:(NSInteger)flagHeight
{
    return [self initWithFrame:frame withFlagSize:CGSizeMake(64, flagHeight)];
}

- (void)hiddenBottomLine:(BOOL)hidden
{
    _bottomLine.hidden = hidden;
}
- (void)setArrayItem:(NSArray *)arrayItem
{
    [self clearSubView];
    _arrayItem = arrayItem ? arrayItem : @[];
    
    [self loadSubView];
}

- (void)clearSubView
{
    if (!_arrayItem || _arrayItem.count == 0) {
        _arrayItem = @[];
        return;
    }
    for (UIView * view in _scrollView.subviews) {
        if (view.tag > 0) {
            [view removeFromSuperview];
        }
    }
}

- (UIColor *)normalColor
{
    if (!_normalColor) {
        _normalColor = [UIColor colorWithRed:42.0/255.0 green:44.0/255.0 blue:52.0/255.0 alpha:1];
    }
    return _normalColor;
}

- (UIColor *)selectedColor
{
    if (!_selectedColor) {
        _selectedColor = self.flagColor;
//        _selectedColor = [UIColor hq_colorWithHexString:ColorSelect];
    }
    return _selectedColor;
}

- (void)loadSubView
{
    NSInteger btnWidth =self.frame.size.width / self.arrayItem.count;
    NSInteger index = 0;
    for (NSString *obj in self.arrayItem) {
        UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:obj forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setFrame:CGRectMake(index * btnWidth, 0, btnWidth, self.frame.size.height - 2)];
        [self.scrollView addSubview:button];
    
        if (index == 0) {
            [button setTitleColor:self.selectedColor forState:UIControlStateNormal];
            if (_selectedFont) {
                [button.titleLabel setFont:_selectedFont];
            }
            NSInteger btnTextWidth = button.titleLabel.text.length * 16;
            if (self.flagSize.width) {
                _flagLine.tq_width = self.flagSize.width;
            } else {
                _flagLine.tq_width = btnTextWidth;
            }
          
            
            _flagLine.tq_centerX = button.tq_centerX;
        }
        else {
            [button setTitleColor:self.normalColor forState:UIControlStateNormal];
            if (_normalFont) {
                [button.titleLabel setFont:_normalFont];
            }
        }
        [button setTag: ++index];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
     
    [self addPreListionView];
    [self bringSubviewToFront:_flagLine];
    _currentIndex = 1;
}

- (void)addPreListionView
{
    //没有试听
    if (!self.hasPreListon) {
        return;
    }

    UIButton *button;
    for (UIButton *btn in self.scrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && [btn.currentTitle isEqualToString:@"课表"]) {
            button = btn;
            break;
        }
    }
    
    UIView *view = [self.scrollView viewWithTag:1010];
    UIImage *img = self.iconImageDic[@"课表"];//goodDetail_listen
    if (!view && button && img) {//添加个试听的小图标
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.tag = 1010;
        CGFloat btnWidth = button.tq_width;
        NSInteger index = [self.arrayItem indexOfObject:@"课表"] + 1;
        CGFloat spacing = (btnWidth - button.titleLabel.text.length * 16) / 2;
        CGFloat originX = index * btnWidth - spacing;
        imgView.frame = CGRectMake(originX, 8, img.size.width, img.size.height);
        [self.scrollView addSubview:imgView];
    }
}


- (void)clickButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = [btn tag];
    self.currentIndex = index;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickButton:)]) {
            [self.delegate clickButton:index];
        }
    });
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex > self.arrayItem.count) {
        return;
    }
    if (currentIndex == _currentIndex) {
        [self changeButtonStyle:_currentIndex withIsSelected:YES];
        return;
    }
    [self changeButtonStyle:_currentIndex withIsSelected:NO];
    _currentIndex = currentIndex;
 
    [self changeButtonStyle:_currentIndex withIsSelected:YES];
}
- (void)changeButtonStyle:(NSInteger)index  withIsSelected:(BOOL)isSelect
{
    UIButton *btn = [self.scrollView viewWithTag:index];
    if (!btn || ![btn isKindOfClass:[UIButton class]]) {
        return;
    }
   
    if (isSelect) {
        NSInteger btnTextWidth = btn.titleLabel.text.length * 16;
        CGRect frame = _flagLine.frame;
        if (_flagSize.width) {
            _flagLine.tq_width = _flagSize.width;
        } else {
            _flagLine.tq_width = btnTextWidth;
        }
        
        if (!self.flagDisEnabelAnimation) {
            [UIView animateWithDuration:0.4 animations:^{
               self.flagLine.tq_centerX = btn.tq_centerX;
            } completion:nil];
        }else{
            self.flagLine.tq_centerX = btn.tq_centerX;
        }
        
        [btn setTitleColor:self.selectedColor forState:UIControlStateNormal];
        if (_selectedFont) {
            [btn.titleLabel setFont:_selectedFont];
        }
    }
    else {
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        if (_normalFont) {
            [btn.titleLabel setFont:_normalFont];
        }
    }
}

+ (CGSize)contentSize
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);

}
@end

@implementation SwitchViewButtonCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _swithchViewbutton = [[TQSwitchViewButton alloc] initWithFrame:CGRectMake(0, 0,[TQSwitchViewButton contentSize].width, [TQSwitchViewButton contentSize].height)];
        _swithchViewbutton.delegate = self;
        [self.contentView addSubview:_swithchViewbutton];
    }
    return self;
}

#pragma mark -- TQSwitchViewButtonDelegate
- (void)clickButton:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(clickButton:)]) {
        [self.delegate clickButton:index];
    }
}

@end

@implementation SwitchViewButtonCollectionReusableViewCell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _swithchViewbutton = [[TQSwitchViewButton alloc] initWithFrame:CGRectMake(0, 0, [TQSwitchViewButton contentSize].width, [TQSwitchViewButton contentSize].height)];
        _swithchViewbutton.delegate = self;
        [self addSubview:_swithchViewbutton];
    }
    return self;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    _swithchViewbutton.currentIndex = _currentIndex;
}
#pragma mark -- TQSwitchViewButtonDelegate
- (void)clickButton:(NSInteger)index
{
    
    if ([self.delegate respondsToSelector:@selector(clickButton:)]) {
        [self.delegate clickButton:index];
    }
}



@end
