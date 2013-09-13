#import "DBChooser.h"

// TODO: The DBCStyledErrorView.* files are basically copied from elsewhere. We should try to dedupe
// these files..

@class DBCBlueButton;

@interface DBCStyledErrorView : UIView

- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle image:(UIImage*)image
        buttonTitle:(NSString*)buttonTitle buttonTarget:(id)buttonTarget buttonAction:(SEL)buttonAction
             frame:(CGRect)frame;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, assign) BOOL buttonEnabled;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) CGFloat padding1PortraitOverride;
@property (nonatomic, assign) CGFloat padding1LandscapeOverride;
@property (nonatomic, assign) CGFloat padding2PortraitOverride;
@property (nonatomic, assign) CGFloat padding2LandscapeOverride;
@property (nonatomic, assign) CGFloat padding3PortraitOverride;
@property (nonatomic, assign) CGFloat padding3LandscapeOverride;
@property (nonatomic, assign) CGFloat topPaddingPortraitOverride;
@property (nonatomic, assign) CGFloat topPaddingLandscapeOverride;
@property (nonatomic, assign) CGFloat bottomPaddingLandscapeOverride;
@property (nonatomic, assign) CGFloat bottomPaddingPortraitOverride;
@property (nonatomic, assign) CGFloat subtitlePaddingOverride;

@end