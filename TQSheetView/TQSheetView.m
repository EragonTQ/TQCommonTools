//
//  TQSheetView.m
//  hqedu24olapp
//
//  Created by litianqi on 2019/11/11.
//  Copyright © 2019 edu24ol. All rights reserved.
//

#import "TQSheetView.h"
#import "Masonry.h"
//#import "UIView+Extension.h"

#define TQSheetViewKIsiPhoneX TQSheetKIsNotchScreen()

/**
 判断是否刘海屏 iPhone X、iPhone XR、iPhone X Max

 @return YES/NO
 */
static inline bool TQSheetKIsNotchScreen()
{
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            return safeAreaInsets.left > 0.0f;

        } else {
            // ios12 非刘海屏safeAreaInsets为（20，0，0，0）,所以大于20.0才是刘海屏
            return safeAreaInsets.top > 20.0f;
        }
    } else {
        return NO;
    }
}

static inline UIWindow *TQ_keyWindow()
{
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    if (!windows) {
        windows = [UIApplication sharedApplication].windows.firstObject;
    }
    
    return windows;
}



@implementation TQSheetViewConfig
- (UIFont *)fontBtn
{
    if (!_fontBtn) {
        _fontBtn = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    }
    return _fontBtn;
}
@end


@interface TQSheetView()

/** view */
@property (nonatomic, strong) UIView *bottomContainter;
@property (nonatomic, strong) UIView *blackMaskView;

@property (nonatomic, strong) UIView *titleView;
/** TQSheetViewConfig */

@end

@implementation TQSheetView


- (instancetype)initWithFrame:(CGRect)frame
{
    TQSheetViewConfig *config = [TQSheetViewConfig new];
    config.itemArray = @[@"男",@"女"];
    return [self initWithFrame:frame config:config];
}

+ (instancetype)CreateTQSheetViewWithConfig:(TQSheetViewConfig *)config
{
    TQSheetView *_sheetView = [[TQSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds config:config];
     UIWindow *windows = TQ_keyWindow();
     

    [windows addSubview:_sheetView];
    
    return _sheetView;
}

- (instancetype)initWithFrame:(CGRect)frame  config:(TQSheetViewConfig *)config
{
    if (self = [super initWithFrame:frame]) {
        _blackMaskView = [[UIView alloc] initWithFrame:frame];
        _blackMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addSubview:_blackMaskView];
        [_blackMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(0);
        }];
        
        self.config = config;
        if (@available(iOS 13.0, *)) {
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
        self.hidden = YES;
    }
    return self;
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetHeight(self.frame), self.config.heightTitleView)];
        [_bottomContainter addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(self.config.leftMarginBtn);
            make.right.mas_equalTo(self.config.rightMarginBtn);
            make.height.mas_equalTo(self.config.heightTitleView);
        }];
    }
    return _titleView;
}


- (void)setConfig:(TQSheetViewConfig *)config
{
    _config = config;
    [self loadCustomFromArray:config.itemArray];
}

- (void)loadCustomFromArray:(NSArray *)array
{
    [_bottomContainter removeFromSuperview];
    _bottomContainter = nil;
    NSInteger bottomMargin = 0;
    if (TQSheetViewKIsiPhoneX) {
        bottomMargin = [UIApplication sharedApplication].statusBarFrame.size.height;
    }

    NSInteger bottomHeight = self.config.heightTitleView + array.count *  (self.config.lineHeightBtn + self.config.heightButton) - self.config.lineHeightBtn + bottomMargin;
    if (self.config.heightBottomSheetView) {
        bottomHeight = self.config.heightBottomSheetView;
    }
    _bottomContainter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, bottomHeight)];
    [_bottomContainter setBackgroundColor:UIColor.whiteColor];
    [self addSubview:_bottomContainter];
    [_bottomContainter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(bottomHeight);
    }];

    
    NSInteger marginLeft = self.config.leftMarginBtn;
    NSInteger marginRight = self.config.rightMarginBtn;
    if (self.config.titleSheetView.length > 0) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = self.config.titleSheetView;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = self.config.colorTitle ? self.config.colorTitle : [UIColor blackColor];
        titleLabel.font = self.config.fontBtn;
//        titleLabel.font = self.config.fontBtn ? self.config.fontBtn : HQ_Fit_Font(16);
        [self.titleView addSubview:titleLabel];
        NSInteger centerOffsetY =  self.config.heightTitleBottomLine/2;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(marginLeft);
            make.right.mas_equalTo(marginRight);
            make.centerY.mas_equalTo(-centerOffsetY);
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.config.heightTitleBottomLine)];
        lineView.backgroundColor = _config.colorTitleBottomLine;
        [self.titleView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(marginLeft);
            make.right.mas_equalTo(marginRight);
            make.top.mas_equalTo(self.config.heightTitleView- self.config.heightTitleBottomLine);
            make.height.mas_equalTo(self.config.heightTitleBottomLine);
        }];
        
    }
    
    __block NSInteger topMargin = self.config.heightTitleView;
    NSInteger heightBtn = self.config.heightButton;
   
    NSInteger lineHeight = self.config.lineHeightBtn;
    NSInteger count = array.count;
    [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btnMan = [[self class] createButton:obj font:self.config.fontBtn titleColor:self.config.colorTitleBtn];
        btnMan.tag = idx;
        if (_config.ConfigButtonBlock) {
            _config.ConfigButtonBlock(idx,btnMan);
        }
        [_bottomContainter addSubview: btnMan];
//        @weakify(self);
        [btnMan addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//        [btnMan bk_addEventHandler:^(id sender) {
//            @strongify(self);
//            if (self.config.ClickSheetBlock) {
//                self.config.ClickSheetBlock(idx,btnMan);
//            }
//        } forControlEvents:UIControlEventTouchUpInside];
        [btnMan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(heightBtn);
            make.leading.mas_equalTo(marginLeft);
            make.trailing.mas_equalTo(marginRight);
            make.top.mas_equalTo(topMargin);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = _config.lineColorBtn;
        [_bottomContainter addSubview:lineView];
        if (idx == (count -1)) {
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(marginLeft);
                make.trailing.mas_equalTo(marginRight);
                make.bottom.mas_equalTo(0);
                make.top.equalTo(btnMan.mas_bottom);
            }];
            
        } else {
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(marginLeft);
                make.trailing.mas_equalTo(marginRight);
                make.height.mas_equalTo(lineHeight);
                make.top.equalTo(btnMan.mas_bottom);
            }];
        }
        
        topMargin += (lineHeight + heightBtn);
        
    }];
    
    [[self class] tq_addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(10, 10) toView:_bottomContainter];
}

- (void)clickButton:(UIButton *)sender
{
    if (self.config.ClickSheetBlock) {
        self.config.ClickSheetBlock(sender.tag,sender);
    }
}

+ (UIButton *)createButton:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor
{
    font = font ? font : [UIFont systemFontOfSize:15];
    titleColor = titleColor ? titleColor : [UIColor blackColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    return btn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)animation_show
{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.blackMaskView.alpha = 1;
      } completion:^(BOOL finished) {
           self.bottomContainter.transform = CGAffineTransformMakeTranslation(0, self.bottomContainter.bounds.size.height);
          [UIView animateWithDuration:0.25 animations:^{
              self.bottomContainter.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
            
            }];
      }];
      
}

- (void)animation_hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomContainter.transform = CGAffineTransformMakeTranslation(0, self.bottomContainter.bounds.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.blackMaskView.alpha = 0;
          } completion:^(BOOL finished) {
              self.bottomContainter.transform = CGAffineTransformIdentity;
              self.blackMaskView.alpha = 1;
              self.hidden = YES;
          }];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self animation_hidden];
}


+ (void)tq_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii toView:(UIView *)view
{
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:rounded.CGPath];
    
    view.layer.mask = shapeLayer;
}

@end
