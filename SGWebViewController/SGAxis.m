//
//  SGAxis.m
//  SGViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGAxis.h"
#import "JSONKit.h"

@interface SGAxis ()

- (NSString *)getTextForType:(axisType)type;
- (NSString *)getTextForPosition:(axisPosition)position;

@end

@implementation SGAxis

@synthesize type = _type;
@synthesize position = _position;
@synthesize title = _title;
@synthesize dataFieldsBindsNames = _dataFieldsBindsNames;
@synthesize showGrid = _showGrid;
@synthesize forcedRange = _forcedRange;

- (id)initAxisWithPosition:(axisPosition)position andType:(axisType)type
{
    if (self = [super init]) {
        self.type = type;
        self.position = position;
        self.dataFieldsBindsNames = [NSMutableArray array];
        self.title = [NSString string];
        self.showGrid = YES;
        self.ForcedRange = NSMakeRange(0, 0);
    }
    return self;
}

- (NSString *)getTextForType:(axisType)type
{
    switch (type) {
        case axisTypeNumeric:
            return @"Numeric";
            break;
        case axisTypeCategory:
            return @"Category";
            break;
        default:
            NSLog(@"Undefinex axis type, category will be used by default");
            return @"Category";
            break;
    }
}

- (NSString *)getTextForPosition:(axisPosition)position
{
    switch (position) {
        case axisPositionTop:
            return @"top";
            break;
        case axisPositionLeft:
            return @"left";
            break;
        case axisPositionBottom:
            return @"bottom";
            break;
        case axisPositionRight:
            return @"right";
            break;
        default:
            NSLog(@"Undefinex axis position, left will be used by default");
            return @"left";
            break;
    }
}

- (NSString *)getJSTextAxis
{
    NSString *result = [NSString string];
    
    // Adding mandatory info
    result = [result stringByAppendingFormat:@"type:%@,",[[self getTextForType:self.type] JSONString]];
    result = [result stringByAppendingFormat:@"position:%@,",[[self getTextForPosition:self.position] JSONString]];
    
    // Adding optional info
    (self.title && ![self.title isEqualToString:@""]) ? result = [result stringByAppendingFormat:@"title:%@,",[self.title JSONString]] : nil;
    result = [result stringByAppendingFormat:@"grid:%d,",[[[NSNumber alloc]initWithBool:self.showGrid] intValue]];
    result = (self.forcedRange.location != 0 || self.forcedRange.length != 0)
    ? [result stringByAppendingFormat:@"minorTickSteps:1,majorTickSteps:%d,minimum:%d,maximum:%d",
                  self.forcedRange.length,
                  self.forcedRange.location,
                  self.forcedRange.location + self.forcedRange.length]
    : [result stringByAppendingFormat:@"fields:%@",[self.dataFieldsBindsNames JSONString]];
    
    return [NSString stringWithFormat:@"{%@}",result];
}

+ (NSString *)getJSTextAxes:(NSArray *)axes
{
    // Putting all axes together
    NSString *results = @"axes:[";
    
    for (SGAxis *axis in axes) {
        results = [results stringByAppendingString:[axis getJSTextAxis]];
        if (![axis isEqual:[axes lastObject]]) {
            results = [results stringByAppendingString:@","];
        }
    }
    
    return [results stringByAppendingString:@"]"];
}


@end
