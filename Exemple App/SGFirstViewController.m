//
//  SGFirstViewController.m
//  Exemple App
//
//  Created by Michele Amati on 8/21/12.
//  Copyright (c) 2012 apexnet.it. All rights reserved.
//

#import "SGFirstViewController.h"

@interface SGFirstViewController () {
    BOOL fistAppear;
}

@end

@implementation SGFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    fistAppear = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (fistAppear) {
        SGPie *pie = [[SGPie alloc] init];
        pie.dataSource = self;
        [pie reloadData];
        [self loadChartWithHTML:pie.htmlIndex senchaBundleURL:pie.baseURL];
        fistAppear = NO;
    }
}

#pragma mark - SGPieDataSource

- (NSInteger)numberOfSlicesInPie
{
    return 5;
}

- (NSString *)labelForSlice:(NSInteger)num
{
    return [NSString stringWithFormat:@"Slice number %d",num];
}

- (NSNumber *)valueForSlice:(NSInteger)num
{    
    return [NSNumber numberWithInteger:num];
}

- (BOOL)shouldShowLegend
{
    return YES;
}

- (NSString *)formatSlicesLabels
{
    return [NSString stringWithFormat:@"{key}"];
}

@end
