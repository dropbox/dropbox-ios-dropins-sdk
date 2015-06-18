//
//  DBChooserAppearance.m
//  DBChooser
//

#import "DBChooserAppearance.h"
#import "DBAppearance.h"
#import <QuartzCore/QuartzCore.h>

@implementation DBChooserAppearance

+ (UIImage *)noDropboxImage
{
    static UIImage *appIconImage;
    if (appIconImage == nil) {
        NSBundle *bundle = [DBAppearance getBundle];
        appIconImage = [DBAppearance loadImageNamed:@"app-icon" fromBundle:bundle];
    }
    return appIconImage;
}

+ (void)customizeButton:(Class<UIAppearance>)cls {
    NSBundle *bundle = [DBAppearance getBundle];
    if (isIOS7()) {
        [[cls appearance] setTitleColor:[self dropboxBlue] forState:UIControlStateNormal];
        return;
    }

    UIEdgeInsets buttoninsets = UIEdgeInsetsMake(0, 5, 0, 5);
    UIImage *blueLargeBtn = [DBAppearance loadImageNamed:@"blue_large_button"
                                            fromBundle:bundle];
    [[cls appearance] setBackgroundImage:[blueLargeBtn resizableImageWithCapInsets:buttoninsets]
                                forState:UIControlStateNormal];

    UIImage *blueLargeBtnPressed = [DBAppearance loadImageNamed:@"blue_large_button_pressed"
                                              fromBundle:bundle];
    [[cls appearance] setBackgroundImage:[blueLargeBtnPressed resizableImageWithCapInsets:buttoninsets]
                                forState:UIControlStateHighlighted];
    
}

+ (void)customizeInstallButton:(UIButton*)btn withWidth:(CGFloat)width {
    if (isIOS7()) {
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn sizeToFit];
        CGRect frame = btn.frame;
        btn.frame = CGRectMake(0, frame.origin.y, width, frame.size.height);

        [btn setAutoresizingMask: UIViewAutoresizingFlexibleWidth];

        [[btn layer] setBorderWidth:[[UIScreen mainScreen] scale] == 2.00 ? 0.5f : 1.0f];
        [[btn layer] setBorderColor:[self buttonBorderColor].CGColor];

        return;
    }
    else {
        [btn sizeToFit];
    }
}

+ (void)customizeTitleLabel:(UILabel *)label {
    label.textColor = [self darkTextColor];
    if (!isIOS7()) {
        label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    }
}


+ (void)customizeSubtitleLabel:(UILabel *)label {
    if (isIOS7()) {
        label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    else {
        label.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    }
}
@end
