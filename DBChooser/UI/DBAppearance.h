//
//  DBAppearance.h
//  DBChooser
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define isIOS7() (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)


/** This is a container class for all the theming-related code */
@interface DBAppearance : NSObject

/** Customize all UINavigationBar contained by the given class */
+ (void)customizeNavBarForContainer:(Class<UIAppearanceContainer>)cls;

+ (UIColor *)dropboxBlue;
+ (UIColor *)lightBackgroundColor;
+ (UIColor *)darkGrayColor;
+ (UIColor *)darkTextColor;
+ (UIColor *)lightTextColor;
+ (UIColor *)buttonBorderColor;

@end
