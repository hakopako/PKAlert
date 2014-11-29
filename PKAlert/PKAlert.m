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

@interface PKAlert ()
{
    /**
     * in order to avoid that instances are deallocated after being added as a subview.
     */
    PKAlert *pkAlert;
    
    CGRect screenRect;
    float width;
    float height;
    float posX;
    float posY;
    float margin;
    float itemHeight;
}

@property (nonatomic) PKAlert *pkAlert;

- (PKAlert*)setWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText;
- (void)cancelButtonDown;

@end

#pragma mark - LifeCycle
@implementation PKAlert

@synthesize pkAlert;

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
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin+itemHeight, width-margin*2, itemHeight/2)];
        titleLabel.text = @"";
        return titleLabel;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin+itemHeight, width-margin*2, itemHeight)];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return titleLabel;
}

- (UIButton*)generateCancelButtonWithTitle:(NSString*)title
{
    if(title == nil){ title = @"cancel";}
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(margin, margin+itemHeight, width-margin*2, itemHeight)];
    [cancelButton addTarget:self
                     action:@selector(cancelButtonDown)
           forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:title forState:UIControlStateNormal];
    [cancelButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor lightGrayColor]];
    cancelButton.layer.cornerRadius = 3.0f;
    
    return cancelButton;
}

- (UILabel*)generateTextLabelWithString:(NSString*)text
{
    if(text == nil){
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin+itemHeight, width-margin*2, itemHeight/2)];
        textLabel.text = @"";
        return textLabel;
    }
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin+itemHeight, width-margin*2, itemHeight)];
    textLabel.numberOfLines = 0;
    textLabel.text = text;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [textLabel sizeToFit];
    
    return textLabel;
}

- (UIView*)generateAlertView:(UILabel*)titleLabel textLabel:(UILabel*)textLabel cancelButton:(UIButton*)cancelButton
{
    titleLabel.frame = CGRectMake(margin, margin, width-margin*2, titleLabel.frame.size.height);
    textLabel.frame = CGRectMake(margin, margin+titleLabel.frame.size.height, width-margin*2, textLabel.frame.size.height);
    cancelButton.frame = CGRectMake(margin, textLabel.frame.origin.y + textLabel.frame.size.height + margin*2, width-margin*2, cancelButton.frame.size.height);
    
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
    [alertBgView addSubview:cancelButton];
    
    return alertBgView;
}


- (PKAlert*)setWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText
{
    UIView *bgView = [PKAlert generateBackGroundView];
    UIView *alertView = [self generateAlertView:[self generateTitleLabelWithString:title]
                                      textLabel:[self generateTextLabelWithString:text]
                                   cancelButton:[self generateCancelButtonWithTitle:cancelButtonText]];
    
    [bgView addSubview:alertView];
    [self.view addSubview:bgView];
    
    NSLog(@"self=>%@", [self class]);
    pkAlert = self;
    
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


#pragma mark - call methods
+ (void)showWithTitle:(NSString*)title text:(NSString*)text cancelButtonText:(NSString*)cancelButtonText
{
    PKAlert *alert = [[[PKAlert alloc] init] setWithTitle:title text:text cancelButtonText:cancelButtonText];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:alert.view];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         alert.view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}




@end
