//
//  SGPie.m
//  SGViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGPie.h"

@interface SGPie ()

// Made of delightful dictionaries -> key (slice label) value (slice value)
@property (nonatomic, retain) NSMutableArray *pieData;

- (NSString *)slicesLabelFormatter:(NSString *)text;

@end


@implementation SGPie

// Public
@synthesize dataSource = _dataSource;
// Private
@synthesize pieData = _pieData;

- (id)init
{
    if (self = [super init]) {
        // Custom init here...
        self.pieData = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSString *)slicesLabelFormatter:(NSString *)text
{
    static NSString *value = @"{value}";
    static NSString *key = @"{key}";
    
    // Forming a correct javascript chain of strings
    NSString *tempSplit = [text stringByReplacingOccurrencesOfString:value withString:@"'+record.get('value')+'"];
    tempSplit = [tempSplit stringByReplacingOccurrencesOfString:key withString:@"'+record.get('key')+'"];
    return [NSString stringWithFormat:@"'%@'",tempSplit];
}

#pragma mark - Superclass overriden methods

- (void)reloadData
{
    // No need to bother if no data source has been setted
    if (!self.dataSource)
        return;
    
    // For every slice
    int tempSlices = [self.dataSource numberOfSlicesInPie];
    for (int slice=0; slice<tempSlices; slice++) {
        NSDictionary *newSlice = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  [self.dataSource labelForSlice:slice],@"key",
                                  [self.dataSource valueForSlice:slice],@"value",nil];
        [self.pieData addObject:newSlice];
    }
        
    [self setupChartWithData:self.pieData];

    // Clearing now useless local vars
    [self.pieData removeAllObjects];
}

- (NSString *)getJSTextSeries
{   
    NSString *labelRenderer = ([self.dataSource respondsToSelector:@selector(formatSlicesLabels)])
    ? [NSString stringWithFormat:
       @",renderer:function(value){"
       "var index=store.find('key',value);"
       "var record=store.getAt(index);"
       "return %@;}",
       [self slicesLabelFormatter:[self.dataSource formatSlicesLabels]]]
    : [NSString string];
    
    return [NSString stringWithFormat:
            @"series:[{"
            "type:'pie',"
            "angleField:'value',"
            "showInLegend:true,"
            "label:{"
            "field:'key',"
            "contrast:true,"
            "font:'16px Arial',"
            "display:'center'"
            "%@"
            "}}]",labelRenderer];
}

- (NSString *)getJSTextInteractions
{
    return @"interactions:[{type:'rotate'}]";
}

- (NSString *)getJSTextLegend
{
    return ([self.dataSource respondsToSelector:@selector(shouldShowLegend)] && [self.dataSource shouldShowLegend])
    ? @"legend:{position:'bottom'}"
    : nil;
}

- (NSString *)getJSTextContainer
{
    return @"inner_c=new Ext.Panel({"
    "fullscreen:true,"
    "items:[my_chart],"
    "layout:'fit'"
    "});";
}

@end
