//
//  SGSecondViewController.m
//  Exemple App
//
//  Created by Michele Amati on 8/21/12.
//  Copyright (c) 2012 apexnet.it. All rights reserved.
//

#import "SGSecondViewController.h"

@interface SGSecondViewController () {
    BOOL fistAppear;
}

@end

@implementation SGSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    fistAppear = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (fistAppear) {
        SGLine *line = [[SGLine alloc] init];
        line.dataSource = self;
        [line reloadData];
        [self loadChartWithHTML:line.htmlIndex senchaBundleURL:line.baseURL];
        fistAppear = NO;
    }
}

#pragma mark - SGLineDataSource

- (NSInteger)numberOfLinesInChart
{
    return 2;
}

- (NSInteger)numberOfPointsInLines
{
    return 10;
}

- (id)xForPoint:(NSInteger)point
{
    return [NSString stringWithFormat:@"%d",point];
}

- (id)yForPoint:(NSInteger)point inLine:(NSInteger)line
{
    return (line == 0)
    ? [NSNumber numberWithInteger:arc4random_uniform(33)]
    : [NSNumber numberWithInteger:arc4random_uniform(33)];
}

- (NSString *)descForPoint:(NSInteger)point
{
    return [NSString stringWithFormat:@"Description here..."];
}

- (BOOL)shouldActivateItemInfoInteraction
{
    return YES;
}

- (BOOL)showMarkersForLine:(NSInteger)line
{
    return (line == 0) ? NO : YES;
}

- (NSNumber *)smoothValueForLine:(NSInteger)line
{
    return (line == 0)
    ? [[NSNumber alloc]initWithInt:0]
    : [[NSNumber alloc]initWithInt:4];
}

- (NSString *)titleForAxisInPosition:(axisPosition)position
{
    if (position == axisPositionLeft || position == axisPositionBottom) {
        return [NSString string];
    }
    return nil;
}

@end
