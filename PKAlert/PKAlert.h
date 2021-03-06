/***************************************************************************
 
 PKAlert.h
 PKAlert
 
 Created by hakopako on 2014/11/29.
 Copyright (c) 2014年 hakopako.
 
 Permission is hereby granted, free of charge, to any person obtaining a
 copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be included
 in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 ***************************************************************************/

#import <UIKit/UIKit.h>
typedef enum:NSInteger {
    PKAlertStyleDefault,
    PKAlertStyleRectangle
} PKAlertStyle;

@class PKAlertButton;
@interface PKAlert : UIViewController

#pragma mark - call methods (show)
+ (void)showWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText items:(NSArray*)items style:(PKAlertStyle)style tintColor:(UIColor*)tintColor;

#pragma mark - call methods (generate)
+ (PKAlertButton*)generateButtonWithTitle:(NSString*)title action:(void(^)())action type:(UIButtonType)type;
+ (NSDictionary*)generateButtonWithTitle:(NSString*)title action:(void(^)())action type:(UIButtonType)type tintColor:(UIColor*)tintColor;


@end

typedef void (^ActionBlock)(void);
@interface PKAlertButton : UIButton
{
    __weak ActionBlock actionBlock;
    UIButtonType type;
}

@property (weak) ActionBlock actionBlock;
@property (nonatomic) UIButtonType type;

- (instancetype)addActionTarget:(id)target;

@end