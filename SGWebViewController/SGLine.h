//
//  SGLine.h
//  SGViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGBase.h"
@class SGAxis;

@protocol SGLineDataSource <NSObject>
@required
- (NSInteger)numberOfLinesInChart;
- (NSInteger)numberOfPointsInLines;
- (NSString *)xForPoint:(NSInteger)point;
- (NSString *)descForPoint:(NSInteger)point;
- (id)yForPoint:(NSInteger)point inLine:(NSInteger)line;
// If nil the axis is inactive, if @"" the axis has no title
- (NSString *)titleForAxisInPosition:(axisPosition)position;
@optional
// Valid values are from 0 to 10
- (NSNumber *)smoothValueForLine:(NSInteger)line;
- (BOOL)shouldActivateItemInfoInteraction;
- (BOOL)showMarkersForLine:(NSInteger)line;
// Implementing this one cause vertical axes not to bind to data
- (NSRange)yAxisForcedRange;
@end


@interface SGLine : SGBase {

}

@property (nonatomic, retain) id <SGLineDataSource> dataSource;
// The distance between two point on x axis, used to determinate the total width 
@property (nonatomic, assign) NSInteger xPointsPadding;

@end
