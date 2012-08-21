//
//  SGBase.m
//  SGViewController
//
//  Created by Michele Amati on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SGBase.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"

//#define READ_INDEX_JS

@interface SGBase ()

// Chart related data
@property (nonatomic, retain) NSArray *chartData;

- (NSString *)getJSTextStore;
- (NSString *)getJSTextChart;
- (NSString *)getJSPage;

@end

@implementation SGBase

// Private
@synthesize htmlIndex = _htmlIndex;
@synthesize baseURL = _baseURL;
@synthesize chartData = _chartData;

- (id)init
{
    self = [super init];
    if (self) {
        // Initializing html page to load
        NSError *error = nil;
        _baseURL = [NSString stringWithFormat:@"%@/Sencha.bundle/", [[NSBundle mainBundle] bundleURL]];
        _htmlIndex = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/Sencha.bundle/index.html", [[NSBundle mainBundle] bundlePath]]
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
        if (error)
        {
            NSLog(@"%@",[error localizedDescription]);
            NSLog(@"%@",[error localizedFailureReason]);
        }
        
        // TOTO: the title is the html tag title, don't known if it could be usefull to set it
        _htmlIndex = [self.htmlIndex stringByReplacingOccurrencesOfString:@"{title}" withString:@"SGGraph"];
    }
    return self;
}

- (void)setupChartWithData:(NSArray *)data
{
    self.chartData = data;
    NSString *fullJSTextPage = [self getJSPage];
    
#ifdef READ_INDEX_JS
    // Using the index.js file included in the bundle for fast changes/debugging purpose
    _htmlIndex = [self.htmlIndex stringByReplacingOccurrencesOfString:@">{graph_javascript}" withString:@" src=\"index.js\">"];
#else
    // Injecting the javascript page into the html    
    _htmlIndex = [self.htmlIndex stringByReplacingOccurrencesOfString:@"{graph_javascript}" withString:fullJSTextPage];
#endif

    // Clearing now useless data
    [self setChartData:nil];
}

#pragma mark - Private

- (NSString *)getJSTextStore
{
    static NSString *top = @"var store=new Ext.data.JsonStore({";
    static NSString *fieldsStr = @"fields:";
    static NSString *dataStr = @"data:";
    static NSString *bottom = @"});";
    
    // Adding top js part...
    NSString *store = [NSString stringWithString:top];
    
    // Adding fields
    store = [store stringByAppendingString:fieldsStr];
    store = [store stringByAppendingString:[[[self.chartData objectAtIndex:0] allKeys] JSONString]];
    store = [store stringByAppendingString:@","];
    
    // Adding data
    store = [store stringByAppendingString:dataStr];
    store = [store stringByAppendingString:[self.chartData JSONString]];
    
    // Closing js part...
    store = [store stringByAppendingString:bottom];
    
    return store;
}

- (NSString *)getJSTextChart
{
    static NSString *bottom = @"});";
    NSString *main =  @"var my_chart=new Ext.chart.Chart({"
    "listeners:{'afterrender':function(){window.location='callback:whatever'}},"
    "animate:false,"
    "flex:1,"
    "store:store,";
    
    NSString *axesJSText = [self getJSTextAxes];
    NSString *interactionsJSTexs = [self getJSTextInteractions];
    NSString *seriesJSText = [self getJSTextSeries];
    NSString *legendJSText = [self getJSTextLegend];
    
    // Stick together axes + series + some other chart info to form the complete chart code.
    return [NSString stringWithFormat:@"%@%@%@%@%@%@",
            main,
            (axesJSText) ? [axesJSText stringByAppendingString:@","] : [NSString string],
            (interactionsJSTexs) ? [interactionsJSTexs stringByAppendingString:@","] : [NSString string],
            (legendJSText) ? [legendJSText stringByAppendingString:@","] : [NSString string],
            (seriesJSText) ? seriesJSText : [NSString string],
            bottom];
}



- (NSString *)getJSPage
{
    // Stick together the store and the chart + some other page setup code to form a complete JS sencha page.
    
    // Handleing optional pieces
    NSString *globals = [self getJSTextGlobals];
    if (!globals) {
        globals = [NSString string];
    }
    
    return [NSString stringWithFormat:@"%@Ext.setup({onReady:function(){%@%@%@}});",
            globals,
            [self getJSTextStore],
            [self getJSTextChart],
            [self getJSTextContainer]];
}


#pragma mark - Subclass overriden methods

- (NSString *)getJSTextSeries
{
    return nil;
}

- (NSString *)getJSTextAxes
{
    return nil;
}

- (NSString *)getJSTextInteractions
{
    return nil;
}

- (NSString *)getJSTextLegend
{
    return nil;
}

- (NSString *)getJSTextContainer
{
    return nil;
}

- (NSString *)getJSTextGlobals
{
    return nil;
}

- (void)reloadData 
{
    return;
}

@end
