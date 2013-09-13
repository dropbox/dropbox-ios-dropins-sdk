//
//  DBChooserNoDropboxViewController.h
//  DBChooser
//

#import "DBChooser+Private.h"
#import <UIKit/UIKit.h>

/** The is the ViewController for showing a No Dropbox screen that asks the user to install Dropbox */
@interface DBChooserNoDropboxViewController : UIViewController

- (id)initWithCompletionBlock:(DBCBlock)done;

@end
