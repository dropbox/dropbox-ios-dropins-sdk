//
//  DBCStyledNavigationController.m
//  DBChooser
//

#import "DBCStyledNavigationController.h"

#import "DBAppearance.h"

@implementation DBCStyledNavigationController

+ (void)initialize
{
    if (self == [DBCStyledNavigationController class]) {
        [DBAppearance customizeNavBarForContainer:self];
    }
}

@end
