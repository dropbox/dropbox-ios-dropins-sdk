//
//  DBCBlueButton.m
//  DBChooser
//

#import "DBCBlueButton.h"

#import "DBChooserAppearance.h"

@implementation DBCBlueButton

+ (void)initialize
{
    if (self == [DBCBlueButton class]) {
        [DBChooserAppearance customizeButton:self];
    }
}

#pragma mark - overriden UIView methods

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize s = [super sizeThatFits:size];
    if (s.width > 180) {
        s.width += 20; // add some padding
    } else {
        s.width = 200; // min width
    }
    s.height = 45; // the asset has a static height
    return s;
}

@end
