//
//  SGAxis.h
//  SGViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    axisTypeNumeric,
    axisTypeCategory,
    axisTypeUndefined
} axisType;

typedef enum {
    axisPositionLeft,
    axisPositionRight,
    axisPositionBottom,
    axisPositionTop
} axisPosition;

@interface SGAxis : NSObject {
    
}

- (id)initAxisWithPosition:(axisPosition)position andType:(axisType)type;

@property (nonatomic, assign) axisType type;
@property (nonatomic, assign) axisPosition position;
@property (nonatomic, retain) NSMutableArray *dataFieldsBindsNames;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) BOOL showGrid;
// If setted, cause the dataFieldsBindsNames to be ignored
@property (nonatomic, assign) NSRange forcedRange;

// Using internal vars, return something like:
/*
 {
 type: 'Numeric',
 position: 'left',
 fields: ['data1'],
 title: 'Sample Values',
 grid: true,
 minimum: 0
 }
 */
- (NSString *)getJSTextAxis;
+ (NSString *)getJSTextAxes:(NSArray *)axes;

@end
