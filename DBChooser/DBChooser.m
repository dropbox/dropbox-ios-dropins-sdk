//
//  DBChooser.m
//  DBChooser
//

#import "DBChooser.h"

#import "DBChooserResult+Private.h"
#import "DBCConstants.h"
#import "DBChooserNoDropboxViewController.h"
#import "DBCStyledNavigationController.h"

@implementation DBChooser
{
    NSString *_appKey;
    DBChooserCompletionBlock _completionBlock;
    UIView *_noDropboxInstalledView;
}

#pragma mark - lifecycle

- (id)init
{
    NSAssert(NO, @"Please do not initialize DBChooser directly. Use [DBChooser defaultChooser] instead.");
    assert(NO);
}

- (id)initWithAppKey:(NSString*)appKey
{
    self = [super init];
    if (self) {
        _appKey = [appKey copy];
    }
    return self;
}

#pragma mark - public class methods

+ (DBChooser*)defaultChooser
{
    static DBChooser *defaultChooser = nil;;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *appKey = [self dbc_appKeyFromInfoPlist];
        NSAssert(appKey, @"DBChooser: no Dropbox url scheme found in Info.plist!");
        defaultChooser = [[DBChooser alloc] initWithAppKey:appKey];
    });
    return defaultChooser;
}

#pragma mark - public methods

- (void)openChooserForLinkType:(DBChooserLinkType)linkType
            fromViewController:(UIViewController *)topViewController
                    completion:(DBChooserCompletionBlock)blk
{
    _completionBlock = blk; // save the block into the Chooser object
    
    NSURL *chooserURL = [[self class] dbc_chooserURLForAppKey:_appKey linkType:linkType];
    if ([[UIApplication sharedApplication] canOpenURL:chooserURL]) {
        [[UIApplication sharedApplication] openURL:chooserURL];
    } else {
        [self dbc_openNoDropboxInstalledViewFromViewController:topViewController];
    }
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    BOOL handled = NO;
    if (_completionBlock) {
        NSArray *components = [[url path] pathComponents];
        NSString *methodName = [components count] > 1 ? [components objectAtIndex:1] : nil;
        if ([methodName isEqual:@"chooser"]) {
            NSDictionary *params = [[self class] dbc_dictionaryFromQueryString:[url query]];
            NSArray *files = [[self class] dbc_parseFilesJson:params[@"files"]];
            
            [self dbc_completedWithResult:files];
            handled = YES; // handled a Chooser URL
        } else {
            // app got opened by something else. in other words, the Chooser flow got interrupted.
            [self dbc_completedWithResult:nil];
        }
    }
    return handled;
}

#pragma mark - private methods

+ (NSURL*)dbc_chooserURLForAppKey:(NSString*)appKey linkType:(DBChooserLinkType)linkType
{
    NSString *baseURL = [NSString stringWithFormat:@"%@://%@/chooser", kDBCProtocol, kDBCAPIVersion];
    NSString *linkTypeString = [[self class] dbc_getLinkTypeString:linkType];
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?k=%@&linkType=%@", baseURL, appKey, linkTypeString]];
}

+ (NSString*)dbc_getLinkTypeString:(DBChooserLinkType)linkType
{
    switch (linkType) {
        case DBChooserLinkTypeDirect:
            return @"direct";
        case DBChooserLinkTypePreview:
            return @"preview";
        default:
            assert(NO); // unknown link type
    }
}

+ (NSDictionary*)dbc_dictionaryFromQueryString:(NSString*)queryString
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *pair in [queryString componentsSeparatedByString:@"&"]) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if ([kv count] == 2) {
            params[kv[0]] = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return params;
}

+ (NSArray*)dbc_parseFilesJson:(NSString*)filesJson
{
    if ([filesJson length]) {
        NSArray *filesJsonDict = [NSJSONSerialization JSONObjectWithData:[filesJson dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options:0 error:nil];
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:[filesJsonDict count]];
        for (NSDictionary *fileJson in filesJsonDict) {
            DBChooserResult *result = [[DBChooserResult alloc] initWithDictionary:fileJson];
            [results addObject:result];
        }
        return results;
    } else {
        return nil;
    }
}

// look for an app key in the info plist (the app should have a url scheme that looks like "db-(appkey)://"
+ (NSString*)dbc_appKeyFromInfoPlist
{
    NSDictionary *loadedPlist = [[NSBundle mainBundle] infoDictionary];
    NSArray *urlTypes = loadedPlist[@"CFBundleURLTypes"];
    
    NSString *appKey = nil;
    for (NSDictionary *urlType in urlTypes) {
        NSArray *schemes = urlType[@"CFBundleURLSchemes"];
        for (NSString *scheme in schemes) {
            if ([scheme hasPrefix:@"db-"]) {
                if (!appKey) {
                    appKey = [scheme substringFromIndex:3]; // substring after "db-"
                } else {
                    NSAssert(NO, @"DBChooser: WARNING multiple Dropbox url schemes found in Info.plist. Please use the method -initWithAppKey: instead.");
                }
            }
        }
    }
    return appKey;
}

- (void)dbc_openNoDropboxInstalledViewFromViewController:(UIViewController*)topViewController
{
    __weak UIViewController *weakTopVC = topViewController;
    __weak DBChooser *weakSelf = self;
    DBChooserNoDropboxViewController *c = [[DBChooserNoDropboxViewController alloc] initWithCompletionBlock:^{
        [weakTopVC dismissViewControllerAnimated:YES completion:^{
            [weakSelf dbc_completedWithResult:nil];
        }];
    }];
    UINavigationController *noDropboxModal = [[DBCStyledNavigationController alloc] initWithRootViewController:c];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        noDropboxModal.modalPresentationStyle = UIModalPresentationFormSheet;
    }

    [topViewController presentModalViewController:noDropboxModal animated:YES];
}

- (void)dbc_completedWithResult:(NSArray*)results
{
    if (_completionBlock) {
        _completionBlock(results);
        _completionBlock = nil;
    }
}

@end
