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
    float osVersion;
    float width;
    float height;
    float posX;
    float posY;
    float margin;
    float itemWidth;
    float itemHeight;
    float cornerRadius;
    UIFont *titleFont;
    UIColor *titleColor;
    UIFont *textFont;
    UIColor *textColor;
    UIFont *buttonFont;
    UIColor *buttonTitleColor;
    UIColor *defaultButtonColor;
}

@property (nonatomic) PKAlert *pkAlert;
@property (nonatomic) NSArray *pkAlertButtons;

@end

#pragma mark - LifeCycle
@implementation PKAlert

@synthesize pkAlert;
@synthesize pkAlertButtons;

- (instancetype)init
{
    self = [super init];
    if(self){
        //defaults
        screenRect = [[UIScreen mainScreen] bounds];
        width = 280;
        height = 180;
        posX = (screenRect.size.width - width)/2;
        posY = (screenRect.size.height - height)/2;
        margin = 8;
        itemWidth = width-margin*2;
        itemHeight = 44;
        cornerRadius = 3.0f;
        
        titleFont = [UIFont systemFontOfSize:21];
        titleColor = [[UIColor alloc] initWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
        textFont = [UIFont systemFontOfSize:13];
        textColor = [[UIColor alloc] initWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
        buttonFont = [UIFont systemFontOfSize:17];
        buttonTitleColor = [UIColor whiteColor];
        defaultButtonColor = [[UIColor alloc] initWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
        
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
    if(title == nil){
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin+itemHeight, itemWidth, itemHeight/2)];
        titleLabel.text = @"";
        return titleLabel;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin+itemHeight, itemWidth, itemHeight)];
    titleLabel.text = title;
    titleLabel.font = titleFont;
    titleLabel.textColor = titleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return titleLabel;
}

- (UILabel*)generateTextLabelWithString:(NSString*)text
{
    if(text == nil){
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin+itemHeight, itemWidth, itemHeight/2)];
        textLabel.text = @"";
        return textLabel;
    }
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin+itemHeight, itemWidth, itemHeight)];
    textLabel.numberOfLines = 0;
    textLabel.text = text;
    textLabel.font = textFont;
    textLabel.textColor = textColor;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [textLabel sizeToFit];
    
    return textLabel;
}

- (UIView*)generateItems:(NSArray*)items tintColor:(UIColor*)tintColor
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
        button.frame = CGRectMake(0, (margin+itemHeight)*[itemsArray count], itemWidth, itemHeight);
        button.layer.cornerRadius = cornerRadius;
        
        [itemsArray addObject:button];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, (margin+itemHeight)*[itemsArray count])];
    
    for(int i=0; i<[itemsArray count]; i++){
        [view addSubview:[itemsArray objectAtIndex:i]];
    }
    
    return view;
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
    button.frame = CGRectMake(margin, margin+itemHeight, itemWidth, itemHeight);
    button.layer.cornerRadius = cornerRadius;    
    return button;
}

- (UIView*)generateAlertView:(UILabel*)titleLabel textLabel:(UILabel*)textLabel cancelButton:(UIButton*)cancelButton items:(UIView*)itemView
{
    titleLabel.frame = CGRectMake(margin, margin, itemWidth, titleLabel.frame.size.height);
    textLabel.frame = CGRectMake(margin, titleLabel.frame.origin.y + titleLabel.frame.size.height + margin, itemWidth, textLabel.frame.size.height + margin);
    itemView.frame = CGRectMake(margin, margin+textLabel.frame.origin.y + textLabel.frame.size.height + margin, itemWidth, itemView.frame.size.height);
    cancelButton.frame = CGRectMake(margin, itemView.frame.origin.y + itemView.frame.size.height, itemWidth, cancelButton.frame.size.height);
    
    height = cancelButton.frame.origin.y + cancelButton.frame.size.height+margin;
    posY = (screenRect.size.height - height)/2;
    posX = (screenRect.size.width - width)/2;
    UIView *alertBgView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    alertBgView.backgroundColor = [UIColor whiteColor];
    alertBgView.layer.cornerRadius = cornerRadius;
    alertBgView.layer.masksToBounds = NO;
    alertBgView.layer.shadowOffset = CGSizeMake(0, 8);
    alertBgView.layer.shadowOpacity = 0.2f;
    alertBgView.layer.shadowColor = [UIColor blackColor].CGColor;
    alertBgView.layer.shadowRadius = 8.0f;
    
    [alertBgView addSubview:titleLabel];
    [alertBgView addSubview:textLabel];
    [alertBgView addSubview:itemView];
    [alertBgView addSubview:cancelButton];
    
    return (osVersion < 8.0f)? [self lotateView:alertBgView] : alertBgView;
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

- (PKAlert*)setWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText items:(NSArray*)items tintColor:(UIColor*)tintColor
{
    UIView *bgView = [PKAlert generateBackGroundView];
    UIView *alertView = [self generateAlertView:[self generateTitleLabelWithString:title]
                                      textLabel:[self generateTextLabelWithString:text]
                                   cancelButton:[self generateCancelButtonWithTitle:cancelButtonText tintColor:tintColor]
                                          items:[self generateItems:items tintColor:tintColor]];
    
    [bgView addSubview:alertView];
    [self.view addSubview:bgView];
    
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
+ (void)showWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText items:(NSArray*)items tintColor:(UIColor *)tintColor
{
    PKAlert *alert = [[[PKAlert alloc] init] setWithTitle:title text:text cancelButtonText:cancelButtonText items:items tintColor:tintColor];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:alert.view];
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         alert.view.alpha = 1.0;
                         alert.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.03, 1.03);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.05
                                          animations:^{
                                              alert.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                                          } completion:^(BOOL finished) {
                                              
                                          }];
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

+ (PKAlertButton*)generateButtonWithTitle:(NSString*)title action:(void(^)())action type:(UIButtonType)type backgoundColor:(UIColor*)backgroundColor
{
    PKAlertButton* button = [PKAlert generateButtonWithTitle:title action:action type:type];
    [button setBackgroundColor:backgroundColor];
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