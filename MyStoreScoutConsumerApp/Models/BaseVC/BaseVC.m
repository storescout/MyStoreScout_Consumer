//
//  BaseVC.m
//  MyStoreScout
//
//  Created by C205 on 12/09/16.
//  Copyright © 2016 C205. All rights reserved.
//

#import "BaseVC.h"

@implementation BaseVC


/* ----------------------------------------------- */

+ (instancetype)sharedInstance
{
    static BaseVC *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

/* ----------------------------------------------- */

- (void)addAlertBoxWithText:(NSString *)message
                       toVC:(UIViewController *)VC
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *btnOK = [UIAlertAction actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {}];
    [alert addAction:btnOK];
    [VC presentViewController:alert animated:YES completion:nil];
}

- (NSString *)encodeToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (UIImage *)fixOrientation :(UIImage *)receivedImage
{
    // No-op if the orientation is already correct
    if (receivedImage.imageOrientation == UIImageOrientationUp)
        return receivedImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (receivedImage.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, receivedImage.size.width, receivedImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, receivedImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, receivedImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (receivedImage.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, receivedImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, receivedImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, receivedImage.size.width, receivedImage.size.height,
                                             CGImageGetBitsPerComponent(receivedImage.CGImage), 0,
                                             CGImageGetColorSpace(receivedImage.CGImage),
                                             CGImageGetBitmapInfo(receivedImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (receivedImage.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,receivedImage.size.height,receivedImage.size.width), receivedImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,receivedImage.size.width,receivedImage.size.height), receivedImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)compressImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    
    float maxHeight = 800;
    float maxWidth = 800;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    else
    {
        // actualHeight = maxHeight;
        //  actualWidth = maxWidth;
        compressionQuality = 1;
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}


- (void)addCornerRadiusToViews:(NSArray *)views
{
    for (UIView *view in views)
    {
        view.layer.cornerRadius = 20.0f;
        view.clipsToBounds = YES;
    }
}

- (void)addLeftPaddingForTextFields:(NSArray *)textFields
{
    for (UITextField *textField in textFields)
    {
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
        textField.leftView = paddingView2;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

- (void) addBottomLineToTextFields:(NSArray *)textFieldArray
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        for (UITextField *textField in textFieldArray)
        {
            CALayer *border = [CALayer layer];
            CGFloat borderWidth = 2;
            border.borderColor = [UIColor colorWithRed:184/255.0 green:182/255.0 blue:182/255.0 alpha:1.0].CGColor;
            border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
            border.borderWidth = borderWidth;
            [textField.layer addSublayer:border];
            textField.layer.masksToBounds = YES;
        }
    });
}

- (void)addCustomPlaceHolderToTextField:(UITextField *)textField withPlaceHolder:(NSString *)placeHolder
{
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)])
    {
        UIColor *color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: color}];
    }
    else
    {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
}

- (NSInteger)getRowsforTable:(UITableView *)tableView
                    forArray:(NSMutableArray *)array
            withPlaceHolder: (NSString *)strPlaceHolder
{
    if (array.count > 0)
        tableView.backgroundView = nil;
    else
    {
        UILabel *noDataMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        noDataMessage.text = strPlaceHolder;
        noDataMessage.textColor = [UIColor darkGrayColor];
        noDataMessage.textAlignment = NSTextAlignmentCenter;
        tableView.backgroundView = noDataMessage;
    }
    return [array count];
}

- (NSInteger)getRowsforCollection:(UICollectionView *)collectionView
                         forArray:(NSMutableArray *)array
                  withPlaceHolder: (NSString *)strPlaceHolder
{
    if (array.count > 0)
        collectionView.backgroundView = nil;
    else
    {
        UILabel *noDataMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, collectionView.bounds.size.width, collectionView.bounds.size.height)];
        noDataMessage.text = strPlaceHolder;
        noDataMessage.textColor = [UIColor darkGrayColor];
        noDataMessage.textAlignment = NSTextAlignmentCenter;
        collectionView.backgroundView = noDataMessage;
    }
    return [array count];
}

- (void)addRefreshControl:(UIRefreshControl *)refreshControl
                  toTable:(UITableView *)tableView
       withViewController:(UIViewController *)VC
              forSelector:(SEL)handlingMethod
{
    [refreshControl addTarget:VC
                       action:(SEL)handlingMethod
             forControlEvents:UIControlEventValueChanged];
    
    [tableView addSubview:refreshControl];
}

@end
