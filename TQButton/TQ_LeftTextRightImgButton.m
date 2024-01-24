//
//  TQ_LeftTextRightImgButton.m
//  hqedu24olapp
//
//  Created by litianqi on 2024/1/25.
//  Copyright © 2024 edu24ol. All rights reserved.
//

#import "TQ_LeftTextRightImgButton.h"

@implementation TQ_LeftTextRightImgButton

- (void)layoutSubviews
{
     [super layoutSubviews];
 
    CGFloat imageWidth = 0;
    CGFloat titleWidth = 0;
    if (self.currentImage) {
        imageWidth = self.currentImage.size.width + _leftForText;
        titleWidth = [self.currentTitle hq_getWidthWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 30)] + _rightFotImg;
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
