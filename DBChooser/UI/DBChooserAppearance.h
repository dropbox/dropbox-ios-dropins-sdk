//
//  DBAppearance.h
//  DBChooser
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DBAppearance.h"

/** This is a container class for all the theming-related code */
@interface DBChooserAppearance : DBAppearance

+ (UIImage *)noDropboxImage;

/** Customize all UIButtons of the given class */
+ (void)customizeButton:(Class<UIAppearance>)cls;
+ (void)customizeInstallButton:(UIButton*)btn withWidth:(CGFloat)width;
+ (void)customizeTitleLabel:(UILabel*)label;
+ (void)customizeSubtitleLabel:(UILabel*)label;

@end
