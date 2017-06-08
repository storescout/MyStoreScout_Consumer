//
//  UIUnderlinedButton.m
//  MyStoreScout
//
//  Created by C205 on 12/09/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "UIUnderlinedButton.h"

@implementation UIUnderlinedButton

+ (UIUnderlinedButton*) underlinedButton
{
    UIUnderlinedButton* button = [[UIUnderlinedButton alloc] init];
    return button;
}

- (void) drawRect:(CGRect)rect
{
    
    CGRect textRect = self.titleLabel.frame;
    
    // need to put the line at top of descenders (negative value)
//    CGFloat descender = self.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
        
}

@end
