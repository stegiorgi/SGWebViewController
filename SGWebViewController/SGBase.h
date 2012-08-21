//
//  SGBase.h
//  SGViewController
//
//  Created by Michele Amati on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGAxis.h"

@interface SGBase : NSObject {
    
}

@property (nonatomic, readonly) NSString *htmlIndex;
// The path to the bundle 
@property (nonatomic, readonly) NSString *baseURL;

/*
 * Data is an array of dictionaries (all with the same model):
 * (string) key -> (string | numeric) value
 * How this data is used is specified in the implementation of 'getJSTextSeries'.
 */ 
- (void)setupChartWithData:(NSArray *)data;

/*
 * Functions that child class MUST implement.
 */
- (NSString *)getJSTextSeries;
- (NSString *)getJSTextAxes;
- (NSString *)getJSTextInteractions;
- (NSString *)getJSTextLegend;
- (NSString *)getJSTextContainer;
- (NSString *)getJSTextGlobals;

- (void)reloadData;

@end

