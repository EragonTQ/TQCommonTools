//
//  TQLeftTextRightImgButton.m
//  hqedu24olapp
//
//  Created by litianqi on 2024/1/25.
//  Copyright © 2024 edu24ol. All rights reserved.
//

#import "TQLeftTextRightImgButton.h"

@interface NSString (TQSize)
- (CGFloat)tq_getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)tq_getSizeWithFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;
@end

@implementation NSString (TQSize)

- (CGFloat)tq_getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self tq_getSizeWithFont:font paragraphStyle:nil constrainedToSize:size].width;
    
}

- (CGSize)tq_getSizeWithFont:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle constrainedToSize:(CGSize)size
{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        resultSize = [self boundingRectWithSize:size
                                        options:(NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: font,NSParagraphStyleAttributeName:paragraphStyle}
                                        context:nil].size;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
#endif
    }
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    return resultSize;
}

@end


@implementation TQLeftTextRightImgButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageWidth = 0;
    CGFloat titleWidth = 0;
    if (self.currentImage) {
        imageWidth = self.currentImage.size.width + _leftForText;
        titleWidth = [self.currentTitle tq_getWidthWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 30)] + _rightFotImg;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth)];
    }

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

