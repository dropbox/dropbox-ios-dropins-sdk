//
//  DBChooserNoDropboxViewController.m
//  DBChooser
//

#import "DBChooserNoDropboxViewController.h"

#import "DBCConstants.h"
#import "DBChooserAppearance.h"
#import "DBCLocalization.h"
#import "DBCStyledErrorView.h"

static const CGFloat sNoDropboxViewPadding1Portrait = 54;
static const CGFloat sNoDropboxViewPadding2Portrait = 12;
static const CGFloat sNoDropboxViewPadding3Portrait = 37;
static const CGFloat sNoDropboxViewPadding1Landscape = 18;
static const CGFloat sNoDropboxViewPadding2Landscape = 9;
static const CGFloat sNoDropboxViewPadding3Landscape = 12;
static const CGFloat sNoDropboxViewPadding1Pad = 64;
static const CGFloat sNoDropboxViewPadding2Pad = 12;
static const CGFloat sNoDropboxViewPadding3Pad = 24;
static const CGFloat sNoDropboxViewBottomPaddingPad = 36;
static const CGFloat sNoDropboxViewBottomPaddingPhone = 24;
static const CGFloat sNoDropboxViewSubtitlePaddingPad = 160;

@implementation DBChooserNoDropboxViewController
{
    DBCBlock _completionBlock;
}

#pragma mark - lifecycle

- (id)initWithCompletionBlock:(DBCBlock)done
{
    self = [super init];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    if (self) {
        _completionBlock = done;
        [self setTitle:DBCLocalizedString(@"Dropbox", @"")];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                    target:self action:@selector(dbc_didPressCancel:)];
        self.navigationItem.leftBarButtonItem = cancelItem;
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
    }
    return self;
}

#pragma mark - overriden UIViewController methods

- (void)viewDidLoad
{
    [[self view] addSubview:[self dbc_noDropboxView]];
}

#pragma mark - event handling

- (void)dbc_didPressCancel:(id)sender
{
    [self dbc_finished];
}

- (void)dbc_didPressInstall:(id)sender
{
    NSString *appStoreURLString = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                                  kDBCIPadAppStoreURL : kDBCIPhoneAppStoreURL;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURLString]];
    [self dbc_finished];
}

- (void)dbc_finished
{
    if (_completionBlock) {
        _completionBlock();
        _completionBlock = nil;
    }
}

#pragma mark - private methods

- (UIView*)dbc_noDropboxView
{
    NSString *errorTitle = DBCLocalizedString(@"Please Install the Dropbox App", @"");
    NSString *errorSubtitle = DBCLocalizedString(@"With Dropbox installed, you can access all your stuff in your favorite apps, like this one!", @"");
    NSString *buttonTitle = DBCLocalizedString(@"Install Dropbox", @"");

    // check if user has some old version of Dropbox installed. If so, ask to "update" instead of "install".
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"dbapi-1://chooser"]]) {
        errorTitle = DBCLocalizedString(@"Please Update the Dropbox App", @"");
        errorSubtitle = DBCLocalizedString(@"With the new Dropbox app, you can access all your stuff in your favorite apps, like this one!" , @"");
        buttonTitle = DBCLocalizedString(@"Update Dropbox", @"");
    }

    DBCStyledErrorView *noDropboxView = [[DBCStyledErrorView alloc]
                                         initWithTitle:errorTitle subtitle:errorSubtitle
                                         image:[DBChooserAppearance noDropboxImage]
                                         buttonTitle:buttonTitle
                                         buttonTarget:self
                                         buttonAction:@selector(dbc_didPressInstall:)
                                         frame:self.view.bounds];
    [noDropboxView setBottomPaddingPortraitOverride:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? sNoDropboxViewBottomPaddingPad : sNoDropboxViewBottomPaddingPhone];
    [noDropboxView setBottomPaddingLandscapeOverride:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? sNoDropboxViewBottomPaddingPad : sNoDropboxViewBottomPaddingPhone];
    [noDropboxView setPadding1PortraitOverride:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? sNoDropboxViewPadding1Pad : sNoDropboxViewPadding1Portrait];
    [noDropboxView setPadding1LandscapeOverride:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? sNoDropboxViewPadding1Pad : sNoDropboxViewPadding1Landscape];
    [noDropboxView setPadding2PortraitOverride:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? sNoDropboxViewPadding2Pad : sNoDropboxViewPadding2Portrait];
    [noDropboxView setPadding2LandscapeOverride:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? sNoDropboxViewPadding2Pad : sNoDropboxViewPadding2Landscape];
    [noDropboxView setPadding3PortraitOverride:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? sNoDropboxViewPadding3Pad : sNoDropboxViewPadding3Portrait];
    [noDropboxView setPadding3LandscapeOverride:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? sNoDropboxViewPadding3Pad : sNoDropboxViewPadding3Landscape];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [noDropboxView setSubtitlePaddingOverride:sNoDropboxViewSubtitlePaddingPad];
    }
    
    [noDropboxView setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    [noDropboxView setBackgroundColor:[DBAppearance lightBackgroundColor]];
    return noDropboxView;
}

@end
