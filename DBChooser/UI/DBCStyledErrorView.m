#import "DBCStyledErrorView.h"
#import "DBChooserAppearance.h"
#import "DBCBlueButton.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

static CGFloat kVPadding1 = 14;
static CGFloat kVPadding2 = 7;
static CGFloat kVPadding3 = 14;
static CGFloat kTopPaddingPortrait = 10;
static CGFloat kTopPaddingLandscape = 50;
static CGFloat KBottomPadding = 14;
static CGFloat kSubtitleWidthPadding = 40;
static CGFloat kTitleWidthPadding = 20;

/* This is a hack to make the button act the same in 3.1 as it does in 4.* */
@interface DBCStyledErrorViewButton : UIButton { }
@end

@implementation DBCStyledErrorViewButton

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end


@implementation DBCStyledErrorView {

    UIButton* _button;
    UILabel* _titleView;
    UILabel* _subtitleView;
    UIEdgeInsets edgeInsets;
    UIActivityIndicatorView *activityIndicator;

    // TODO: this is added on top of StyledErrorView
    DBCBlueButton* _bottomButton;
}
@synthesize edgeInsets;
@synthesize padding1PortraitOverride;
@synthesize padding1LandscapeOverride;
@synthesize padding2PortraitOverride;
@synthesize padding2LandscapeOverride;
@synthesize padding3PortraitOverride;
@synthesize padding3LandscapeOverride;
@synthesize topPaddingPortraitOverride;
@synthesize topPaddingLandscapeOverride;
@synthesize bottomPaddingPortraitOverride;
@synthesize bottomPaddingLandscapeOverride;
@synthesize subtitlePaddingOverride;

- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle image:(UIImage*)image
        buttonTitle:(NSString*)buttonTitle buttonTarget:(id)buttonTarget buttonAction:(SEL)buttonAction
         frame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:250.0/255.0 blue:255.0/255.0 alpha:1];
        _button = [DBCStyledErrorViewButton buttonWithType: UIButtonTypeCustom];
        _button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_button sizeToFit];
        [self addSubview: _button];
        
        _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.textColor = [UIColor colorWithRed:52.0/255.0 green:64.0/255.0 blue:93.0/255.0 alpha:1];
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.numberOfLines = 0;
        [DBChooserAppearance customizeTitleLabel:_titleView];
        [self addSubview:_titleView];
        
        _subtitleView = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleView.backgroundColor = [UIColor clearColor];
        _subtitleView.textColor = [UIColor colorWithRed:124.0/255.0 green:135.0/255.0 blue:160.0/255.0 alpha:1];
        _subtitleView.textAlignment = NSTextAlignmentCenter;
        _subtitleView.numberOfLines = 0;
        [DBChooserAppearance customizeSubtitleLabel:_subtitleView];
        [self addSubview:_subtitleView];
        
        if (buttonTitle) {
            _bottomButton = [[DBCBlueButton alloc] initWithFrame:CGRectZero];
            [_bottomButton setTitle:buttonTitle forState:UIControlStateNormal];

            [DBChooserAppearance customizeInstallButton:_bottomButton withWidth:frame.size.width];

            [self addSubview:_bottomButton];

            [_bottomButton addTarget:buttonTarget action:buttonAction forControlEvents:UIControlEventTouchUpInside];
        }
        
        _titleView.text = title;
        [_titleView sizeToFit];
        
        _subtitleView.text = subtitle;
        [_subtitleView sizeToFit];
        
        [_button setImage:image forState:UIControlStateNormal];
        [_button sizeToFit];
        // set target for button
        _button.userInteractionEnabled = NO;
        
        [self setPadding1PortraitOverride:kVPadding1];
        [self setPadding2PortraitOverride:kVPadding2];
        [self setPadding3PortraitOverride:kVPadding3];
        [self setPadding1LandscapeOverride:kVPadding1];
        [self setPadding2LandscapeOverride:kVPadding2];
        [self setPadding3LandscapeOverride:kVPadding3];
        [self setTopPaddingPortraitOverride:kTopPaddingPortrait];
        [self setTopPaddingLandscapeOverride:kTopPaddingLandscape];
        [self setBottomPaddingPortraitOverride:KBottomPadding];
        [self setBottomPaddingLandscapeOverride:KBottomPadding];
        [self setSubtitlePaddingOverride:kSubtitleWidthPadding];
    }
    return self;
}

- (void)layoutSubviews {
    CGRect tFrame = _titleView.frame;
    tFrame.size.width = self.frame.size.width - kTitleWidthPadding;
    _titleView.frame = tFrame;
    [_titleView sizeToFit];
    CGRect sFrame = _subtitleView.frame;
    sFrame.size.width = self.frame.size.width - [self subtitlePaddingOverride];
    _subtitleView.frame = sFrame;
    [_subtitleView sizeToFit];

    BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    CGFloat titlePadding = isPortrait ? [self padding1PortraitOverride] : [self padding1LandscapeOverride];
    CGFloat postTitleViewPadding = isPortrait ? [self padding2PortraitOverride] : [self padding2LandscapeOverride];
    CGFloat postSubtitleViewPadding = isPortrait ? [self padding3PortraitOverride] : [self padding3LandscapeOverride];
    CGFloat bottomPadding = isPortrait ? [self bottomPaddingPortraitOverride] : [self bottomPaddingLandscapeOverride];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(edgeInsets.top + isPortrait ? [self topPaddingPortraitOverride] : [self topPaddingLandscapeOverride], 0, edgeInsets.bottom + bottomPadding, 0);


    CGRect contentBounds = UIEdgeInsetsInsetRect(self.bounds, contentInsets);
    CGSize imageSize = [_button imageForState:UIControlStateNormal].size;
    
    CGFloat totalHeight = imageSize.height;
    
    if (_titleView.text.length) {
        totalHeight += (totalHeight ? titlePadding : 0) + _titleView.frame.size.height;
    }
    if (_subtitleView.text) {
        totalHeight += (totalHeight ? postTitleViewPadding : 0) + _subtitleView.frame.size.height;
    }
    if (_bottomButton) {
        totalHeight += (totalHeight ? postSubtitleViewPadding : 0) + _bottomButton.frame.size.height;
    }
    
    if (totalHeight > contentBounds.size.height) {
        // Tighten up spacing in landscape on iPhone and leave more space for the image
        titlePadding -= 8;
        postTitleViewPadding -= 2;
        totalHeight -= 10;
        
        // Make image small enough so everything just fits
        imageSize.height -= (totalHeight - contentBounds.size.height);
        CGRect buttonFrame = _button.frame;
        buttonFrame.size = imageSize;
        _button.frame = buttonFrame;
        totalHeight = contentBounds.size.height;
    } else {
        [_button sizeToFit];
    }
    
    CGFloat top = 70;
    
    CGRect bFrame = _button.frame;
    bFrame.origin = CGPointMake(floor(self.frame.size.width/2 - _button.frame.size.width/2), top);
    _button.frame = bFrame;
    
    top += _button.frame.size.height;
    top += titlePadding;
    
    if (_titleView.text.length) {
        CGRect tiFrame = _titleView.frame;
        tiFrame.origin = CGPointMake(floor(self.frame.size.width/2 - _titleView.frame.size.width/2), top);
        _titleView.frame = tiFrame;
        top += _titleView.frame.size.height + postTitleViewPadding;
    }
    
    if (_subtitleView.text) {
        CGFloat totalWidth = _subtitleView.frame.size.width;
        CGRect stFrame = _subtitleView.frame;
        stFrame.origin = CGPointMake(floor(self.frame.size.width/2 - totalWidth/2), top);
        _subtitleView.frame = stFrame;
        top += _subtitleView.frame.size.height + postSubtitleViewPadding;
    }
    
    if (_bottomButton) {
        CGFloat totalWidth = _bottomButton.frame.size.width;
        CGRect buttonFrame = _bottomButton.frame;
        buttonFrame.origin = CGPointMake(floor(self.frame.size.width/2 - totalWidth/2), top);
        _bottomButton.frame = buttonFrame;
    }
    
    if (activityIndicator) {
        CGRect frame = activityIndicator.frame;
        frame.origin.x = floor(contentBounds.origin.x + contentBounds.size.width/2 - frame.size.width/2);
        frame.origin.y = top - 1;
        activityIndicator.frame = frame;
    }
}

- (NSString *)title {
    return _titleView.text;
}

- (void)setTitle:(NSString *)title {
    if (title == _titleView.text) return;
    _titleView.text = title;
    [_titleView sizeToFit];
    [self setNeedsLayout];
}

- (NSString *)subtitle {
    return _subtitleView.text;
}

- (void)setSubtitle:(NSString *)subtitle {
    if (subtitle == _subtitleView.text) return;
    _subtitleView.text = subtitle;
    [_subtitleView sizeToFit];
    [self setNeedsLayout];
}

- (BOOL)buttonEnabled {
    return _button.enabled;
}

- (void)setButtonEnabled:(BOOL)enabled {
    _button.enabled = enabled;
}

- (BOOL)loading {
    return [activityIndicator isAnimating];
}

- (void)setLoading:(BOOL)loading {
    if (loading == self.loading) return;
    
    if (self.loading) {
        [activityIndicator stopAnimating];
    } else {
        if (!activityIndicator) {
            activityIndicator = [[UIActivityIndicatorView alloc]
                                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self addSubview:activityIndicator];
            [self setNeedsLayout];
        }
        [activityIndicator startAnimating];
    }
}

@end