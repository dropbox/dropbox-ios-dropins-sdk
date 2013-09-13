//
//  DBChooserResult.m
//  DBChooser
//

#import "DBChooserResult.h"

@implementation DBChooserResult

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        _link = [NSURL URLWithString:dictionary[@"link"]];
        _name = dictionary[@"name"];
        _size = [dictionary[@"bytes"] longLongValue];
        _iconURL = [NSURL URLWithString:dictionary[@"icon"]];
        
        NSDictionary *thumbnailsStringDict = dictionary[@"thumbnails"];
        NSMutableDictionary *thumbnailsDict = [NSMutableDictionary dictionaryWithCapacity:[thumbnailsStringDict count]];
        [thumbnailsStringDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            thumbnailsDict[key] = [NSURL URLWithString:obj];
        }];
        _thumbnails = thumbnailsDict;
    }
    return self;
}

@end
