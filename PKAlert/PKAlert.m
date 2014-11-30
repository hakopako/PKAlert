//
//  PKAlert.m
//  PKAlert
//
//  Created by shimada on 2014/11/29.
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
    CloseAlertBlock closeAlertBlock;
    PKAlert *pkAlert;
    NSArray *pkAlertButtons;
    
    CGRect screenRect;
    float width;
    float height;
    float posX;
    float posY;
    float margin;
    float itemWidth;
    float itemHeight;
}

@property (nonatomic) PKAlert *pkAlert;
@property (nonatomic) NSArray *pkAlertButtons;

- (PKAlert*)setWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText items:(NSArray*)items;
- (void)cancelButtonDown;

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
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"PKAlet dealloc");
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
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
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
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [textLabel sizeToFit];
    
    return textLabel;
}

- (UIView*)generateItems:(NSArray*)items
{
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    for(int i=0; i<[items count]; i++){
        if(![[items objectAtIndex:i] isKindOfClass:[PKAlertButton class]]){
            continue;
        }
        PKAlertButton *button = [items objectAtIndex:i];
        button.frame = CGRectMake(0, (margin+itemHeight)*[itemsArray count], itemWidth, itemHeight);
        
        [itemsArray addObject:button];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, (margin+itemHeight)*[itemsArray count])];
    
    for(int i=0; i<[itemsArray count]; i++){
        [view addSubview:[itemsArray objectAtIndex:i]];
    }
    
    return view;
}


- (UIButton*)generateCancelButtonWithTitle:(NSString*)title
{
    if(title == nil){ title = @"cancel";}
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(margin, margin+itemHeight, itemWidth, itemHeight)];
    [cancelButton addTarget:self
                     action:@selector(cancelButtonDown)
           forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:title forState:UIControlStateNormal];
    [cancelButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor lightGrayColor]];
    cancelButton.layer.cornerRadius = 3.0f;
    
    return cancelButton;
}

- (UIView*)generateAlertView:(UILabel*)titleLabel textLabel:(UILabel*)textLabel cancelButton:(UIButton*)cancelButton items:(UIView*)itemView
{
    titleLabel.frame = CGRectMake(margin, margin, itemWidth, titleLabel.frame.size.height);
    textLabel.frame = CGRectMake(margin, margin+titleLabel.frame.size.height+margin, itemWidth, textLabel.frame.size.height);
    itemView.frame = CGRectMake(margin, textLabel.frame.origin.y + textLabel.frame.size.height + margin, itemWidth, itemView.frame.size.height);
    cancelButton.frame = CGRectMake(margin, itemView.frame.origin.y + itemView.frame.size.height, itemWidth, cancelButton.frame.size.height);
    
    height = cancelButton.frame.origin.y + cancelButton.frame.size.height+margin;
    posY = (screenRect.size.height - height)/2;
    UIView *alertBgView = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    alertBgView.backgroundColor = [UIColor whiteColor];
    alertBgView.layer.cornerRadius = 3.0f;
    alertBgView.layer.masksToBounds = NO;
    alertBgView.layer.shadowOffset = CGSizeMake(0, 0);
    alertBgView.layer.shadowOpacity = 0.1f;
    alertBgView.layer.shadowColor = [UIColor blackColor].CGColor;
    alertBgView.layer.shadowRadius = 6.0f;
    
    [alertBgView addSubview:titleLabel];
    [alertBgView addSubview:textLabel];
    [alertBgView addSubview:itemView];
    [alertBgView addSubview:cancelButton];
    
    return alertBgView;
}


- (PKAlert*)setWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText items:(NSArray*)items
{
    UIView *bgView = [PKAlert generateBackGroundView];
    UIView *alertView = [self generateAlertView:[self generateTitleLabelWithString:title]
                                      textLabel:[self generateTextLabelWithString:text]
                                   cancelButton:[self generateCancelButtonWithTitle:cancelButtonText]
                                          items:[self generateItems:items]];
    
    [bgView addSubview:alertView];
    [self.view addSubview:bgView];
    
    NSLog(@"self=>%@", [self class]);
    pkAlert = self;
    pkAlertButtons = items;
    
    return self;
}

- (void)cancelButtonDown
{
    NSLog(@"cancelbuttondown is called.");
    [UIView animateWithDuration:0.2
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
+ (void)showWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText items:(NSArray*)items
{
    PKAlert *alert = [[[PKAlert alloc] init] setWithTitle:title text:text cancelButtonText:cancelButtonText items:items];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:alert.view];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         alert.view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

#pragma mark - call methods (generate)
+ (PKAlertButton*)generateButtonWithTitle:(NSString*)title action:(void(^)())action type:(UIButtonType)type
{
    PKAlertButton *button = [[PKAlertButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    button.layer.cornerRadius = 3.0f;
    return [button addActionBlock:action forControlEvents:UIControlEventTouchUpInside];
}

+ (PKAlertButton*)generateButtonWithTitle:(NSString*)title action:(void(^)())action type:(UIButtonType)type tintColor:(UIColor*)tintColor fontColor:(UIColor*)fontColor
{
    return nil;
}

@end

typedef void (^ActionBlock)(void);
@interface PKAlertButton()
{
    ActionBlock actionBlock;
}

- (void)callActionBlock;

@end

@implementation PKAlertButton

- (instancetype)addActionBlock:(void(^)())action forControlEvents:(UIControlEvents)controlEvents
{
    actionBlock = action;
    [self addTarget:self action:@selector(callActionBlock) forControlEvents:controlEvents];
    return self;
}

- (void)callActionBlock
{
    actionBlock();
}

- (void)dealloc
{
    NSLog(@"PKAlertButton is dealloc.");
}

@end