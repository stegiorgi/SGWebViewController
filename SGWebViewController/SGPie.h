//
//  SGPie.h
//  SGViewController
//
//  Created by Michele Amati on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGBase.h"

@protocol SGPieDataSource <NSObject>

@required
- (NSInteger)numberOfSlicesInPie;
- (NSNumber *)valueForSlice:(NSInteger)num;
- (NSString *)labelForSlice:(NSInteger)num;

@optional
- (BOOL)shouldShowLegend;
/*
 * You can compose any string, special values are: {value} and {key} that will 
 * be replaced with the slice specific values. The rest of the string may be
 * whatever you want.
 */
- (NSString *)formatSlicesLabels;

@end

@interface SGPie : SGBase {
    
}

@property (nonatomic, retain) id <SGPieDataSource> dataSource;

@end

