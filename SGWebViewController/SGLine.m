//
//  SGLine.m
//  SGViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGLine.h"


// Memory usage grow as fast as the chart size, be carefull when changeing this option. 
#define DEFAULT_X_POINTS_PADDING 25

@interface SGLine ()

@property (nonatomic, retain) NSMutableArray *x;
@property (nonatomic, retain) NSMutableArray *desc;
@property (nonatomic, retain) NSMutableArray *ys;

- (SGAxis *)setupAxisWithTitle:(NSString *)title position:(axisPosition)position;
- (NSArray *)convertLinesToDrawableData;
- (NSString *)getJSTextSerieForLine:(int)line;
// Future improvement should move intteraction to a separate class
- (NSString *)getJSTextInteractions;

@end


@implementation SGLine


// Public
@synthesize dataSource = _dataSource;
@synthesize xPointsPadding = _xPointsPadding;
//Private
@synthesize x = _x;
@synthesize ys = _ys;
@synthesize desc = _desc;

- (id)init
{
    if (self = [super init]) {
        // Custom init here...
        self.x = [[NSMutableArray alloc] init];
        self.desc = [[NSMutableArray alloc] init];
        self.ys = [[NSMutableArray alloc] init];
        self.xPointsPadding = DEFAULT_X_POINTS_PADDING;
    }
    return self;
}

#pragma mark - Private functions

- (SGAxis *)setupAxisWithTitle:(NSString *)title position:(axisPosition)position
{
    if (!title)
        return nil;
    
    // Creating axis
    SGAxis *newAxis = [[SGAxis alloc] initAxisWithPosition:position andType:axisTypeNumeric];
    newAxis.showGrid = YES;
    newAxis.title = title;
    
    if ((position == axisPositionTop || position == axisPositionBottom)) {
        // Here we have a horizontal (X) axis
        [newAxis.dataFieldsBindsNames addObject:@"x"];
        newAxis.type = axisTypeCategory;
    }
    else {
        // Here we have a vertival (Y) axis
        if ([self.dataSource respondsToSelector:@selector(yAxisForcedRange)]) {
            newAxis.forcedRange = [self.dataSource yAxisForcedRange];
            newAxis.type = axisTypeNumeric;
        }
        else {
            // Looping throught ys and adding them all to the y axis
            for (int l=0; l<[self.ys count]; l++) {
                [newAxis.dataFieldsBindsNames addObject:[NSString stringWithFormat:@"y_%d",l]];
                // If type is still numeric, looking if the actual line is numeric only
                if (newAxis.type == axisTypeNumeric) {
                    for (id sample in [self.ys objectAtIndex:l]) {
                        if ([sample isKindOfClass:[NSString class]]) {
                            newAxis.type = axisTypeCategory;
                            break;
                        }
                    }
                }
            }
        }
    }
    
    return newAxis;
}

- (NSArray *)convertLinesToDrawableData
{
    NSMutableArray *results = [[NSMutableArray alloc]init];
    
    /*
     The final strcture will be something like this: an array of dic.
     {'x':value, 'y_0':10, 'desc':12, 'y_1':8},
     {'x':value, 'y_0':7, 'desc':8, 'y_1':10},
     ...
     */
    
    int rows = [self.x count];
    int column = [self.ys count];
    
    for (int r=0; r<rows; r++) {
        NSMutableDictionary *row = [[NSMutableDictionary alloc]init];
        [row setValue:[self.x objectAtIndex:r] forKey:@"x"];
        [row setValue:[self.desc objectAtIndex:r] forKey:@"desc"];
        for (int c=0; c<column; c++) {
            [row setValue:[[self.ys objectAtIndex:c] objectAtIndex:r] forKey:[NSString stringWithFormat:@"y_%d",c]];
        }
        [results addObject:row];
    }
    
    return results;
}

- (NSString *)getJSTextSerieForLine:(int)line
{
    // Asking for optional smooth value
    NSNumber *smooth = ([self.dataSource respondsToSelector:@selector(smoothValueForLine:)])
    ? [self.dataSource smoothValueForLine:line]
    : [[NSNumber alloc]initWithInt:0];
    
    // Asking it this line should show markers (setting tollerance to zero to prevent touch)
    NSString *markers = ([self.dataSource respondsToSelector:@selector(showMarkersForLine:)] &&
                         [self.dataSource showMarkersForLine:line])
    ? @"showMarkers:false,selectionTolerance:0,"
    : [NSString string];
    
    
    NSString *results = [NSString stringWithFormat:@"{type:\"line\","
                         "axis:\"left\","
                         "smooth:%d,"
                         "%@"
                         "xField:\"x\","
                         "yField:\"y_%d\"}",
                         [smooth intValue],
                         markers,
                         line];
    return results;
}

- (NSString *)getJSTextInteractions
{
    // Asking for optional itemInfo 
    BOOL itemInfo = ([self.dataSource respondsToSelector:@selector(shouldActivateItemInfoInteraction)])
    ? [self.dataSource shouldActivateItemInfoInteraction]
    : NO;
    
    if (itemInfo) {
        return
        @"interactions:[{"
        "type:'iteminfo',"
        "listeners: {"
        "show: function(interaction, item, panel) {"
        "panel.update(['<ul><li>'+item.storeItem.get('desc')+'</li>','<li>'+item.value[1]+'</li></ul>'].join(''));"
        "}}}]";
    }
    
    return nil;
}

#pragma mark - Superclass overriden methods

- (void)reloadData
{
    // No need to bother if no data source has been setted
    if (!self.dataSource)
        return;
    
    int tempLines = [self.dataSource numberOfLinesInChart];
    int tempPoints = [self.dataSource numberOfPointsInLines];
    
    // Asking for x & desc
    for (int point=0; point<tempPoints; point++) {
        [self.x addObject:[self.dataSource xForPoint:point]];
        [self.desc addObject:[self.dataSource descForPoint:point]];
    }
    
    // Asking for ys
    for (int line=0; line<tempLines; line++) {
        NSMutableArray* tempY = [[NSMutableArray alloc] init];
        for (int point=0; point<tempPoints; point++) {
            [tempY addObject:[self.dataSource yForPoint:point
                                                 inLine:line]];
        }
        [self.ys addObject:tempY];
    }
    
    [self setupChartWithData:[self convertLinesToDrawableData]];

    // Clearing the local arrays 
    [self.x removeAllObjects];
    [self.desc removeAllObjects];
    [self.ys removeAllObjects];
}

- (NSString *)getJSTextSeries
{
    NSString *results = @"series:[";
    
    // Generating every serie (one per line)
    for (int l=0; l<[self.ys count]; l++) {
        results = [results stringByAppendingString:[self getJSTextSerieForLine:l]];
        // Avoid adding comma last line
        (l+1 < [self.ys count]) ? results = [results stringByAppendingString:@","] : nil;
    }
    
    return [results stringByAppendingString:@"]"];
}

- (NSString *)getJSTextAxes
{
    NSMutableArray *axes = [[NSMutableArray alloc]init];
    
    // Asking the datasource for axes settings
    
    SGAxis *temp1 = [self setupAxisWithTitle:[self.dataSource titleForAxisInPosition:axisPositionLeft] position:axisPositionLeft];
    (temp1) ? [axes addObject:temp1] : nil;
    SGAxis *temp2 = [self setupAxisWithTitle:[self.dataSource titleForAxisInPosition:axisPositionRight] position:axisPositionRight];
    (temp2) ? [axes addObject:temp2] : nil;
    SGAxis *temp3 = [self setupAxisWithTitle:[self.dataSource titleForAxisInPosition:axisPositionTop] position:axisPositionTop];
    (temp3) ? [axes addObject:temp3] : nil;
    SGAxis *temp4 = [self setupAxisWithTitle:[self.dataSource titleForAxisInPosition:axisPositionBottom] position:axisPositionBottom];
    (temp4) ? [axes addObject:temp4] : nil;
    
    if ([axes count] == 0) {
        return nil;
    }
    
    return [SGAxis getJSTextAxes:axes];
}

- (NSString *)getJSTextContainer
{    
    return @"inner_c=new Ext.Panel({"
    "fullscreen:true,"
    "items:[my_chart],"
    "layout:{"
    "type:'hbox',"
    "align:'stretch',"
    "pack:'start'"
    "}});"
    "outer_c=new Ext.Panel({"
    "layoutOnOrientationChange:true,"
    "listeners: {orientationchange:function(){inner_c.setWidth(calculate_best_width(outer_c));}},"
    "fullscreen:true,"
    "scroll:'horizontal',"
    "items:[inner_c],"
    "layout:{"
    "type:'hbox',"
    "align:'center',"
    "pack:'start' "
    "}});"
    "inner_c.setWidth(calculate_best_width(outer_c));";
}

- (NSString *)getJSTextGlobals
{
    return [NSString stringWithFormat:@"var objective_c_width=%d;"
            "function calculate_best_width(c){if(c.getWidth()<objective_c_width){return objective_c_width;}else{return c.getWidth()}};",
            self.xPointsPadding * [self.x count]];
}

@end
