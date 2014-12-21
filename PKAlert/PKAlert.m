//
//  PKAlert.m
//  PKAlert
//
//  Created by hakopako on 2014/11/29.
//  Copyright (c) 2014年 hakopako.
//

#if !__has_feature(objc_arc)
#error PKAlertView is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "PKAlert.h"
#import <QuartzCore/QuartzCore.h>

@class PKAlertButton;

typedef void (^CloseAlertBlock)(void);
@interface PKAlert ()
{
    __weak CloseAlertBlock closeAlertBlock;
    PKAlert *pkAlert;
    NSArray *pkAlertButtons;
    CGRect screenRect;
    UIView *alertView;
    
    float osVersion;
    float alertViewWidth;
    float alertViewHeight;
    
    UIFont *titleFont;
    UIColor *titleColor;
    UIFont *textFont;
    UIColor *textColor;
    UIFont *buttonFont;
    UIColor *buttonTitleColor;
    UIColor *defaultButtonColor;
    UIColor *defaultLineColor;
}

@property (nonatomic) PKAlert *pkAlert;
@property (nonatomic) NSArray *pkAlertButtons;
@property (nonatomic) UIView *alertView;

@end

@implementation PKAlert

@synthesize pkAlert;
@synthesize pkAlertButtons;
@synthesize alertView;

#pragma mark - UI
/**
 * Default style alert UI
 * @param UILabel titleLabel
 * @param UILabel textLabel
 * @param UIButton cancelButton
 * @param NSArray<PKAlertButton> itemArray
 */
- (void)defaultStyleAlertView:(UILabel*)titleLabel textLabel:(UILabel*)textLabel cancelButton:(UIButton*)cancelButton items:(NSArray*)itemArray
{
    alertViewWidth = 260;
    float margin = 8;
    float itemWidth = alertViewWidth - margin * 2;
    float itemHeight = 44;
    float cornerRadius = 12;
    
    //title
    titleLabel.frame = CGRectMake(margin, margin, itemWidth, itemHeight);
    
    //text
    textLabel.frame = CGRectMake(margin, titleLabel.frame.origin.y + titleLabel.frame.size.height + margin, itemWidth, textLabel.frame.size.height);
    [textLabel sizeToFit];
    CGRect textLabelFrame = textLabel.frame;
    textLabelFrame.size.width = itemWidth;
    textLabelFrame.size.height = textLabel.frame.size.height + margin*2;
    textLabel.frame = textLabelFrame;
    
    //itemButtons
    float btnPosY = textLabel.frame.origin.y + textLabel.frame.size.height + margin;
    CGRect rectButtonMask;
    if([itemArray count] == 1){
        PKAlertButton *button = [itemArray objectAtIndex:0];
        button.frame = CGRectMake(alertViewWidth/2-1, btnPosY, alertViewWidth/2+2, itemHeight+2);
        
        rectButtonMask = CGRectMake(button.bounds.origin.x, button.bounds.origin.y, button.bounds.size.width-1, button.bounds.size.height-1);
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:rectButtonMask
                                         byRoundingCorners:UIRectCornerBottomRight
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = button.bounds;
        maskLayer.path = maskPath.CGPath;
        button.layer.mask = maskLayer;
        
        [[button layer] setBorderColor:[defaultLineColor CGColor]];
        [[button layer] setBorderWidth:1.0];
        
        UIColor *buttonTint = button.backgroundColor;
        UIColor *alertTint = alertView.backgroundColor;
        [button setBackgroundColor:alertTint];
        [button setTitleColor:buttonTint forState:UIControlStateNormal];
        
    } else {
        for(int i=0; i<[itemArray count]; i++){
            PKAlertButton *button = [itemArray objectAtIndex:i];
            button.frame = CGRectMake(0, btnPosY + itemHeight*i, alertViewWidth+1, itemHeight+1);
            
            rectButtonMask = CGRectMake(button.bounds.origin.x+1, button.bounds.origin.y, button.bounds.size.width-2, button.bounds.size.height-1);
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:rectButtonMask];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = button.bounds;
            maskLayer.path = maskPath.CGPath;
            button.layer.mask = maskLayer;
            
            [[button layer] setBorderColor:[defaultLineColor CGColor]];
            [[button layer] setBorderWidth:1.0];
            
            UIColor *buttonTint = button.backgroundColor;
            UIColor *alertTint = alertView.backgroundColor;
            [button setBackgroundColor:alertTint];
            [button setTitleColor:buttonTint forState:UIControlStateNormal];
        }
    }


    
    //cancelButton
    CGRect rectCancelButtonMask;
    if([itemArray count] == 1){
        cancelButton.frame = CGRectMake(0, btnPosY, alertViewWidth/2+1, itemHeight+1);
        rectCancelButtonMask = CGRectMake(cancelButton.bounds.origin.x+1, cancelButton.bounds.origin.y, cancelButton.bounds.size.width-2, cancelButton.bounds.size.height-1);
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:rectCancelButtonMask
                                         byRoundingCorners:UIRectCornerBottomLeft
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cancelButton.bounds;
        maskLayer.path = maskPath.CGPath;
        cancelButton.layer.mask = maskLayer;
    } else {
        cancelButton.frame = CGRectMake(0, btnPosY + itemHeight*[itemArray count], alertViewWidth, itemHeight);
        rectCancelButtonMask = CGRectMake(cancelButton.bounds.origin.x+1, cancelButton.bounds.origin.y, cancelButton.bounds.size.width-2, cancelButton.bounds.size.height-1);
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:rectCancelButtonMask
                                         byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cancelButton.bounds;
        maskLayer.path = maskPath.CGPath;
        cancelButton.layer.mask = maskLayer;
    }
    UIColor *buttonTint = cancelButton.backgroundColor;
    UIColor *alertTint = alertView.backgroundColor;
    [cancelButton setBackgroundColor:alertTint];
    [cancelButton setTitleColor:buttonTint forState:UIControlStateNormal];
    
    [[cancelButton layer] setBorderColor:[defaultLineColor CGColor]];
    [[cancelButton layer] setBorderWidth:1.0];
    
    //alertView
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = cornerRadius;
    alertViewHeight = cancelButton.frame.origin.y + cancelButton.frame.size.height;
}


/**
 * Rectangle style alert UI
 * @param UILabel titleLabel
 * @param UILabel textLabel
 * @param UIButton cancelButton
 * @param NSArray<PKAlertButton> itemArray
 */
- (void)rectangleStyleAlertView:(UILabel*)titleLabel textLabel:(UILabel*)textLabel cancelButton:(UIButton*)cancelButton items:(NSArray*)itemArray
{
    alertViewWidth = 260;
    float margin = 8;
    float itemWidth = alertViewWidth - margin * 2;
    float itemHeight = 44;
    float cornerRadius = 1;
    
    //title
    titleLabel.frame = CGRectMake(margin, margin, itemWidth, itemHeight);
    
    //text
    textLabel.frame = CGRectMake(margin, titleLabel.frame.origin.y + titleLabel.frame.size.height + margin, itemWidth, textLabel.frame.size.height);
    [textLabel sizeToFit];
    CGRect textLabelFrame = textLabel.frame;
    textLabelFrame.size.width = itemWidth;
    textLabelFrame.size.height = textLabel.frame.size.height + margin*2;
    textLabel.frame = textLabelFrame;
    
    //itemButtons
    float btnPosY = textLabel.frame.origin.y + textLabel.frame.size.height + margin;
    for(int i=0; i<[itemArray count]; i++){
        PKAlertButton *button = [itemArray objectAtIndex:i];
        button.frame = CGRectMake(margin, btnPosY + (margin + itemHeight)*i, itemWidth, itemHeight);
    }
    
    //cancelButton
    cancelButton.frame = CGRectMake(margin, btnPosY + (margin + itemHeight)*[itemArray count], itemWidth, itemHeight);

    //alertView
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = cornerRadius;
    alertViewHeight = cancelButton.frame.origin.y + cancelButton.frame.size.height + margin;
}

#pragma mark - LifeCycle
- (instancetype)init
{
    self = [super init];
    if(self){
        //defaults
        screenRect = [[UIScreen mainScreen] bounds];
        
        alertViewWidth = 280;
        alertViewHeight = 180;
        
        alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        titleFont = [UIFont systemFontOfSize:21];
        titleColor = [[UIColor alloc] initWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
        textFont = [UIFont systemFontOfSize:13];
        textColor = [[UIColor alloc] initWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
        buttonFont = [UIFont systemFontOfSize:17];
        buttonTitleColor = [UIColor whiteColor];
        defaultButtonColor = [[UIColor alloc] initWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
        defaultLineColor = [[UIColor alloc] initWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
        
        osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        //NSLog(@"%@ is initialized.", [self class]);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    //NSLog(@"%@ is deallocated.", [self class]);
}

#pragma mark - instance methods
- (UILabel*)generateTitleLabelWithString:(NSString*)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = titleFont;
    titleLabel.textColor = titleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return titleLabel;
}

- (UILabel*)generateTextLabelWithString:(NSString*)text
{
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.text = text;
    textLabel.font = textFont;
    textLabel.textColor = textColor;
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    return textLabel;
}

- (NSArray*)generateItems:(NSArray*)items tintColor:(UIColor*)tintColor
{
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    for(int i=0; i<[items count]; i++){
        if(![[items objectAtIndex:i] isKindOfClass:[PKAlertButton class]]){
            continue;
        }
        PKAlertButton *button = [items objectAtIndex:i];
        [button addActionTarget:self];
        [button setTitleColor:buttonTitleColor forState: UIControlStateNormal];
        
        // if button already has any color, skip setting background color.
        if(button.backgroundColor == nil){
            [button setBackgroundColor:(tintColor == nil)? defaultButtonColor : tintColor];
        }
        
        button.titleLabel.font = buttonFont;
        [itemsArray addObject:button];
    }
    
    return itemsArray;
}


- (UIButton*)generateCancelButtonWithTitle:(NSString*)title tintColor:(UIColor*)tintColor
{
    if(title == nil){ title = @"cancel";}
    
    PKAlertButton *button = [PKAlert generateButtonWithTitle:title
                                                      action:^{}
                                                        type:UIButtonTypeSystem];
    [button addActionTarget:self];
    [button setTitleColor:buttonTitleColor forState: UIControlStateNormal];
    [button setBackgroundColor:(tintColor == nil)? defaultButtonColor : tintColor];
    button.titleLabel.font = buttonFont;   
    return button;
}

- (UIView*)generateAlertView:(UILabel*)titleLabel textLabel:(UILabel*)textLabel cancelButton:(UIButton*)cancelButton items:(NSArray*)itemArray style:(PKAlertStyle)style
{
    switch (style) {
        case PKAlertStyleRectangle:
        {
            [self rectangleStyleAlertView:titleLabel textLabel:textLabel cancelButton:cancelButton items:itemArray];
            break;
        }
        case PKAlertStyleDefault:
        {
            [self defaultStyleAlertView:titleLabel textLabel:textLabel cancelButton:cancelButton items:itemArray];
            break;
        }
    }
    
    CGRect rect = alertView.frame;
    rect.origin.x = (screenRect.size.width - alertViewWidth)/2;
    rect.origin.y = (screenRect.size.height - alertViewHeight)/2;
    rect.size.width = alertViewWidth;
    rect.size.height = alertViewHeight;
    alertView.frame = rect;
    
    [alertView addSubview:titleLabel];
    [alertView addSubview:textLabel];
    for(int i=0; i<[itemArray count]; i++){
        PKAlertButton *button = [itemArray objectAtIndex:i];
        [alertView addSubview:button];
    }
    [alertView addSubview:cancelButton];

    alertView.layer.masksToBounds = NO;
    alertView.layer.shadowOffset = CGSizeMake(0, 8);
    alertView.layer.shadowOpacity = 0.2f;
    alertView.layer.shadowColor = [UIColor blackColor].CGColor;
    alertView.layer.shadowRadius = 8.0f;

    return (osVersion < 8.0f)? [self lotateView:alertView] : alertView;
}

- (UIView*)lotateView:(UIView*)view
{
    switch([[UIApplication sharedApplication] statusBarOrientation])
    {
        case UIInterfaceOrientationPortrait:
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            view.layer.transform = CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            view.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * (-1) * M_PI, 0.0, 0.0, 1.0);
            break;
        case UIInterfaceOrientationLandscapeRight:
            view.layer.transform = CATransform3DMakeRotation(90.0 / 180.0 * M_PI, 0.0, 0.0, 1.0);
            break;
        case UIInterfaceOrientationUnknown:
            break;
    }
    return view;
}

- (PKAlert*)setWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText items:(NSArray*)items style:(PKAlertStyle)style tintColor:(UIColor*)tintColor
{
    UIView *bg = [PKAlert generateBackGroundView];
    UIView *av = [self generateAlertView:[self generateTitleLabelWithString:title]
                                      textLabel:[self generateTextLabelWithString:text]
                                   cancelButton:[self generateCancelButtonWithTitle:cancelButtonText tintColor:tintColor]
                                          items:[self generateItems:items tintColor:tintColor]
                                          style:style];
    
    [bg addSubview:av];
    [av sizeToFit];
    
    [self.view addSubview:bg];
    
    pkAlert = self;
    pkAlertButtons = items;
    
    return self;
}

- (void)callActionBlock:(id)sender
{
    if(![sender isKindOfClass:[PKAlertButton class]]){
        return;
    }
    
    PKAlertButton *button = (PKAlertButton*)sender;
    button.actionBlock();
    
    [UIView animateWithDuration:0.15
                     animations:^{
                         self.view.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         pkAlert = nil;
                         pkAlertButtons = nil;
                     }];
}

#pragma mark - hoge
+ (UIView*)generateBackGroundView
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    UIView *bgView = [[UIView alloc] initWithFrame:screenSize];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.2;
    
    UIView *bgClearView = [[UIView alloc] initWithFrame:screenSize];
    bgClearView.userInteractionEnabled = YES;
    bgClearView.backgroundColor = [UIColor clearColor];
    bgClearView.alpha = 1;
    
    [bgClearView addSubview:bgView];
    
    return bgClearView;
}


#pragma mark - call methods (show)
+ (void)showWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText items:(NSArray*)items style:(PKAlertStyle)style tintColor:(UIColor *)tintColor
{
    PKAlert *alert = [[[PKAlert alloc] init] setWithTitle:title text:text cancelButtonText:cancelButtonText items:items style:style tintColor:tintColor];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:alert.view];
    alert.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         alert.view.alpha = 1.0;
                         alert.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                     } completion:^(BOOL finished) {
                     }];
    
}

#pragma mark - call methods (generate)
+ (PKAlertButton*)generateButtonWithTitle:(NSString*)title action:(void(^)())action type:(UIButtonType)type
{
    PKAlertButton *button = [[PKAlertButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.actionBlock = action;
    button.type = type;
    return button;
}

+ (PKAlertButton*)generateButtonWithTitle:(NSString*)title action:(void(^)())action type:(UIButtonType)type tintColor:(UIColor*)tintColor
{
    PKAlertButton* button = [PKAlert generateButtonWithTitle:title action:action type:type];
    [button setBackgroundColor:tintColor];
    return button;
}

@end


@interface PKAlertButton()
@end

@implementation PKAlertButton

@synthesize actionBlock;
@synthesize type;

- (instancetype)init
{
    self = [super init];
    if(self){
        //NSLog(@"%@ is initialized.", [self class]);
    }
    return self;
}

- (instancetype)addActionTarget:(id)target
{
    [self addTarget:target action:@selector(callActionBlock:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

//@override
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.alpha = (highlighted)? 0.6 : 1.0;
}

- (void)dealloc
{
    //NSLog(@"%@ is deallocated.", [self class]);
}

@end