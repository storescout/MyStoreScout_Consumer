//
//  RightTriangleView.m
//  MyStoreScout
//
//  Created by C205 on 01/10/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "RightTriangleView.h"

@implementation RightTriangleView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat layerHeight = self.layer.frame.size.height;
    CGFloat layerWidth = self.layer.frame.size.width;
    
    // Create Path
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    // Draw Points
    [bezierPath moveToPoint:CGPointMake(layerWidth, layerHeight/2)];
    [bezierPath addLineToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(0, layerHeight)];
    [bezierPath closePath];
    
    // Apply Color
    [POINT_COLOR setFill];
    [bezierPath fill];
    
    // Mask to Path
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    self.layer.mask = shapeLayer;
}

@end
