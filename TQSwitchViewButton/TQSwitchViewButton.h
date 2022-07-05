//
//  TQSwitchViewButton.h
//  hqedu24olapp
//
//  Created by litianqi on 16/7/21.
//  Copyright © 2016年 edu24ol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TQSwitchViewButtonDelegate <NSObject>
- (void)clickButton:(NSInteger)index;//1...n
@end

@interface TQSwitchViewButton : UIView
@property (nonatomic, strong) NSArray * arrayItem;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *normalFont;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;

@property (nonatomic, strong) UIView *flagLine;
@property (nonatomic, strong) UIColor *flagColor;

@property (nonatomic, assign) BOOL hasPreListon;
///默认开启动画的
@property (nonatomic, assign) BOOL flagDisEnabelAnimation;


/**  */
@property (nonatomic, copy) NSDictionary *iconImageDic;

@property (nonatomic, assign)NSInteger currentIndex;//默认1: 1...n
@property (nonatomic, weak) id<TQSwitchViewButtonDelegate>delegate;
+ (CGSize)contentSize;
- (void)hiddenBottomLine:(BOOL)hidden;
- (id)initWithFrame:(CGRect)frame withFlagHeight:(NSInteger)flagHeight;
- (id)initWithFrame:(CGRect)frame withFlagSize:(CGSize)flagSize;
@end


//@protocol SwitchViewButtonCollectionCellDelegate <NSObject>
//-(void)clickCellItem:(NSInteger)indexItem;
//
//@end

@interface SwitchViewButtonCollectionCell : UICollectionViewCell<TQSwitchViewButtonDelegate>
@property (nonatomic, strong) TQSwitchViewButton * swithchViewbutton;
@property (nonatomic, weak) id<TQSwitchViewButtonDelegate> delegate;

@end


@interface SwitchViewButtonCollectionReusableViewCell : UICollectionReusableView<TQSwitchViewButtonDelegate>
@property (nonatomic, strong) TQSwitchViewButton * swithchViewbutton;
@property (nonatomic, weak) id<TQSwitchViewButtonDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;


@end
