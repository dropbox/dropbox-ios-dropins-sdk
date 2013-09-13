//
//  DBAppearance.m
//  DBChooser
//

#import "DBAppearance.h"

@implementation DBAppearance

static CGFloat NavBarCapWidth = 159;
static CGFloat NavBarCapHeight = 21;
static CGFloat BarButtonCapWidth = 5;
static CGFloat BarButtonCapHeight = 7;
static CGFloat BackBarButtonLeftCap = 15;
static CGFloat BackBarButtonRightCap = 6;
static CGFloat BackBarButtonCapHeight = 0;

+ (void)customizeNavBarForContainer:(Class<UIAppearanceContainer>)cls {
    if (isIOS7()) {
        [[UINavigationBar appearanceWhenContainedIn:cls, nil] setTintColor:[self dropboxBlue]];
        return;
    }

    UIEdgeInsets navInsets = UIEdgeInsetsMake(NavBarCapHeight, NavBarCapWidth, NavBarCapHeight, NavBarCapWidth);
    [[UINavigationBar appearanceWhenContainedIn:cls, nil]
     setBackgroundImage:[[UIImage imageNamed:@"DBChooser.bundle/header"] resizableImageWithCapInsets:navInsets]
     forBarMetrics:UIBarMetricsDefault];
    UIEdgeInsets button_insets = UIEdgeInsetsMake(BarButtonCapHeight, BarButtonCapWidth, BarButtonCapHeight, BarButtonCapWidth);
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], cls, nil]
     setBackgroundImage:[UIImage imageNamed:@"DBChooser.bundle/blue_button"]
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], cls, nil]
     setBackgroundImage:[UIImage imageNamed:@"DBChooser.bundle/blue_button_pressed"]
     forState:UIControlStateHighlighted
     barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], cls, nil]
     setBackgroundImage:[[UIImage imageNamed:@"DBChooser.bundle/blue_button_landscape"] resizableImageWithCapInsets:button_insets]
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], cls, nil]
     setBackgroundImage:[[UIImage imageNamed:@"DBChooser.bundle/blue_button_landscape_pressed"] resizableImageWithCapInsets:button_insets]
     forState:UIControlStateHighlighted
     barMetrics:UIBarMetricsLandscapePhone];
    
    UIEdgeInsets back_insets = UIEdgeInsetsMake(BackBarButtonCapHeight, BackBarButtonLeftCap, BackBarButtonCapHeight, BackBarButtonRightCap);
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], cls, nil]
     setBackButtonBackgroundImage:[[UIImage imageNamed:@"DBChooser.bundle/blue_back"] resizableImageWithCapInsets:back_insets]
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], cls, nil]
     setBackButtonBackgroundImage:[[UIImage imageNamed:@"DBChooser.bundle/blue_back_pressed"] resizableImageWithCapInsets:back_insets]
     forState:UIControlStateHighlighted
     barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], cls, nil]
     setBackButtonBackgroundImage:[[UIImage imageNamed:@"DBChooser.bundle/blue_back_button_landscape"] resizableImageWithCapInsets:back_insets]
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], cls, nil]
     setBackButtonBackgroundImage:[[UIImage imageNamed:@"DBChooser.bundle/blue_back_button_landscape_pressed"] resizableImageWithCapInsets:back_insets]
     forState:UIControlStateHighlighted
     barMetrics:UIBarMetricsLandscapePhone];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                               UITextAttributeTextColor : [UIColor whiteColor],
                         UITextAttributeTextShadowColor : [[UIColor blackColor] colorWithAlphaComponent:0.9],
                        UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, -0.5)] }];
}

+ (UIColor *)dropboxBlue {
    return [UIColor colorWithRed:0 green:126/255.0 blue:230/255.0 alpha:1];
}

+ (UIColor *)lightBackgroundColor {
    if (isIOS7()) {
        return [UIColor colorWithRed:240/255.0 green:243/255.0 blue:245/255.0 alpha:1];
    } else {
        return [UIColor colorWithRed:244.0/255.0 green:250.0/255.0 blue:255.0/255.0 alpha:1];
    }
}

+ (UIColor *)darkGrayColor {
    return [UIColor colorWithRed:61/255.0 green:70/255.0 blue:77/255.0 alpha:1];
}

+ (UIColor *)lightTextColor {
    if (isIOS7()) {
        return [UIColor colorWithRed:123/255.0 green:137/255.0 blue:148/255.0 alpha:1];
    } else {
        return [UIColor grayColor];
    }
}

+ (UIColor *)darkTextColor {
    if (isIOS7()) {
        return [DBAppearance darkGrayColor];
    } else {
        return [UIColor blackColor];
    }
}

+ (UIColor *)buttonBorderColor {
    return [UIColor colorWithRed:0.784 green:0.78 blue:0.8 alpha:1]; /*#c8c7cc*/
}


@end
