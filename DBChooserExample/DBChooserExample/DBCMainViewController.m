//
//  DBCMainViewController.m
//  DBChooser-Example
//
//  Created by rich on 6/18/13.
//  Copyright (c) 2013 Dropbox. All rights reserved.
//

#import "DBCMainViewController.h"

#import <DBChooser/DBChooser.h>
#import <DBChooser/DBChooserResult.h>

enum {
    DBCSectionIndexLinkType = 0,      // section for choosing link type
    DBCSectionIndexOpener,            // section for opening the Chooser
    DBCSectionIndexResult,            // section for displaying information returned
    DBCSectionCount,
} DBSectionIndex;

enum {
    DBCLinkTypeRowIndexPreview = 0,
    DBCLinkTypeRowIndexDirect,
    DBCLinkTypeRowCount,
} DBCLinkTypeRowIndex;

enum {
    DBCResultRowIndexLink = 0,
    DBCResultRowIndexName,
    DBCResultRowIndexSize,
    DBCResultRowIndexIconURL,
    DBCResultRowIndexThumbnail64,
    DBCResultRowIndexThumbnail200,
    DBCResultRowIndexThumbnail640,
    DBCResultRowCount,
} DBCResultRowIndex;

@implementation DBCMainViewController
{
    NSUInteger _linkTypeIndex;
    DBChooserResult *_result; // result received from last CHooser call
}

#pragma mark - lifecycle

- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - overriden UITableViewController methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _result ? DBCSectionCount : DBCSectionCount - 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case DBCSectionIndexLinkType:
            return @"Link Type";
        default:
            return nil;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case DBCSectionIndexLinkType:
            return @"\"Direct\" provides a link pointing directly to the file, while \"Preview\" links to a page showing a preview of the file.";
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case DBCSectionIndexLinkType:
            return DBCLinkTypeRowCount;
        case DBCSectionIndexOpener:
            return 1;
        case DBCSectionIndexResult:
            return DBCResultRowCount;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case DBCSectionIndexLinkType:
            return [self dbc_cellForLinkTypeRow:indexPath.row];
        case DBCSectionIndexOpener:
            return [self dbc_cellForOpenerRow:indexPath.row];
        case DBCSectionIndexResult:
            return [self dbc_cellForResultRow:indexPath.row];
        default:
            assert(NO);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case DBCSectionIndexLinkType:
        {
            [self dbc_didSelectLinkTypeRow:indexPath.row];
        }
            break;
        case DBCSectionIndexOpener:
        {
            [self didPressChoose];
        }
            break;
        case DBCSectionIndexResult:
        {
            [self dbc_didSelectResultRow:indexPath.row];
        }
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private methods

#pragma mark cell management

- (UITableViewCell*)dbc_standardCellWithStyle:(UITableViewCellStyle)style
{
    NSString *reuseId = [NSString stringWithFormat:@"Cell-%d", style];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseId];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [[cell textLabel] setAdjustsFontSizeToFitWidth:YES];
    [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:10]];
    return cell;
}

- (UITableViewCell*)dbc_cellForLinkTypeRow:(NSInteger)row
{
    UITableViewCell *cell = [self dbc_standardCellWithStyle:UITableViewCellStyleDefault];
    switch (row) {
        case DBCLinkTypeRowIndexPreview:
            [[cell textLabel] setText:@"Preview"];
            break;
        case DBCLinkTypeRowIndexDirect:
            [[cell textLabel] setText:@"Direct"];
            break;
    }
    if (row == _linkTypeIndex) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

- (UITableViewCell*)dbc_cellForOpenerRow:(NSInteger)row
{
    UITableViewCell *cell = [self dbc_standardCellWithStyle:UITableViewCellStyleDefault];
    [[cell textLabel] setText:@"Open Chooser"];
    [[cell textLabel] setTextAlignment:UITextAlignmentCenter];
    return cell;
}

- (UITableViewCell*)dbc_cellForResultRow:(NSInteger)row
{
    UITableViewCell *cell = [self dbc_standardCellWithStyle:UITableViewCellStyleValue2];
    switch (row) {
        case DBCResultRowIndexLink:
            [[cell textLabel] setText:@"Link"];
            [[cell detailTextLabel] setText:[[_result link] absoluteString]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case DBCResultRowIndexName:
            [[cell textLabel] setText:@"Name"];
            [[cell detailTextLabel] setText:[_result name]];
            break;
        case DBCResultRowIndexSize:
            [[cell textLabel] setText:@"Size"];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%lld", [_result size]]];
            break;
        case DBCResultRowIndexIconURL:
            [[cell textLabel] setText:@"Icon"];
            [[cell detailTextLabel] setText:[[_result iconURL] absoluteString]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case DBCResultRowIndexThumbnail64:
            [[cell textLabel] setText:@"Thumb (64x64)"];
            [[cell detailTextLabel] setText:[[_result thumbnails][@"64x64"] absoluteString]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case DBCResultRowIndexThumbnail200:
            [[cell textLabel] setText:@"Thumb (200x200)"];
            [[cell detailTextLabel] setText:[[_result thumbnails][@"200x200"] absoluteString]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case DBCResultRowIndexThumbnail640:
            [[cell textLabel] setText:@"Thumb (640x480)"];
            [[cell detailTextLabel] setText:[[_result thumbnails][@"640x480"] absoluteString]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
    }
    return cell;
}

#pragma mark actions

- (void)dbc_didSelectLinkTypeRow:(NSInteger)row
{
    _linkTypeIndex = row;
    [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:DBCSectionIndexLinkType]
                    withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didPressChoose
{
    DBChooserLinkType linkType = (_linkTypeIndex == DBCLinkTypeRowIndexDirect) ?
                                 DBChooserLinkTypeDirect : DBChooserLinkTypePreview;
    [[DBChooser defaultChooser] openChooserForLinkType:linkType fromViewController:self
                                           completion:^(NSArray *results)
    {
        if ([results count]) {
            _result = results[0];
        } else {
            _result = nil;
            [[[UIAlertView alloc] initWithTitle:@"CANCELLED" message:@"user cancelled!"
                                       delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil]
             show];
        }
        [[self tableView] reloadData];
    }];
}

- (void)dbc_didSelectResultRow:(NSInteger)row
{
    switch (row) {
        case DBCResultRowIndexLink:
            [[UIApplication sharedApplication] openURL:[_result link]];
            break;
        case DBCResultRowIndexIconURL:
            [[UIApplication sharedApplication] openURL:[_result iconURL]];
            break;
        case DBCResultRowIndexThumbnail64:
            [[UIApplication sharedApplication] openURL:[_result thumbnails][@"64x64"]];
            break;
        case DBCResultRowIndexThumbnail200:
            [[UIApplication sharedApplication] openURL:[_result thumbnails][@"200x200"]];
            break;
        case DBCResultRowIndexThumbnail640:
            [[UIApplication sharedApplication] openURL:[_result thumbnails][@"640x480"]];
            break;
    }
}

@end
