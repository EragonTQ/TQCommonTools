//
//  TQSheetView.h
//  hqedu24olapp
//
//  Created by litianqi on 2019/11/11.
//  Copyright © 2019 edu24ol. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface TQSheetViewConfig : NSObject
/** left margin */
@property (nonatomic) NSInteger leftMarginBtn;
/** right margin */
@property (nonatomic) NSInteger rightMarginBtn;
/** seporate - height */
@property (nonatomic) NSInteger lineHeightBtn;
/** button height */
@property (nonatomic) NSInteger heightButton;
/** line color */
@property (nonatomic) UIColor *lineColorBtn;
@property (nonatomic) UIFont *fontBtn;
@property (nonatomic) UIColor *colorTitleBtn;


/** title */
@property (nonatomic, copy) NSString *titleSheetView;
/** height */
@property (nonatomic) NSInteger heightTitleView;
@property (nonatomic) NSInteger heightTitleBottomLine;
@property (nonatomic) UIColor *colorTitleBottomLine;
@property (nonatomic) UIFont *fontTitle;
@property (nonatomic) UIColor *colorTitle;


@property (nonatomic) NSInteger heightBottomSheetView;
@property (nonatomic, copy) void(^ConfigButtonBlock)(NSInteger index,UIButton *btn);
/** index: 0...n */
@property (nonatomic, copy) void(^ClickSheetBlock)(NSInteger index,UIButton *btn);
@property (nonatomic, copy) NSArray *itemArray;




@end


@interface TQSheetView : UIView
@property (nonatomic, strong) TQSheetViewConfig *config;
/** array */
@property (readonly) NSArray *itemArray;

- (instancetype)initWithFrame:(CGRect)frame config:(TQSheetViewConfig *)config;


/*常用*/
+ (instancetype)CreateTQSheetViewWithConfig:(TQSheetViewConfig *)config;
- (void)animation_show;
- (void)animation_hidden;
@end

NS_ASSUME_NONNULL_END
