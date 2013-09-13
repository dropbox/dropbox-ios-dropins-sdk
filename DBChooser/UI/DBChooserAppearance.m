//
//  DBChooserAppearance.m
//  DBChooser
//

#import "DBChooserAppearance.h"
#import <QuartzCore/QuartzCore.h>

@implementation DBChooserAppearance

+ (UIImage *)noDropboxImage
{
    static UIImage *appIconImage;
    if (appIconImage == nil) {
        appIconImage = [UIImage imageNamed:@"DBChooser.bundle/app-icon"];
    }
    return appIconImage;
}

+ (void)customizeButton:(Class<UIAppearance>)cls {
    if (isIOS7()) {
        [[cls appearance] setTitleColor:[self dropboxBlue] forState:UIControlStateNormal];
        return;
}

    UIEdgeInsets buttoninsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [[cls appearance] setBackgroundImage:[[UIImage imageNamed:@"DBChooser.bundle/blue_large_button"] resizableImageWithCapInsets:buttoninsets]
                                forState:UIControlStateNormal];
    [[cls appearance] setBackgroundImage:[[UIImage imageNamed:@"DBChooser.bundle/blue_large_button_pressed"] resizableImageWithCapInsets:buttoninsets]
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
