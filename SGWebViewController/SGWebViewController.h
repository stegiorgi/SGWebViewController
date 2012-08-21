//
//  SGWebViewController.h
//  iUniversity
//
//  Created by Michele Amati on 6/14/12.
//  Copyright (c) 2012 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SGPie.h"
#import "SGLine.h"

@interface SGWebViewController : UIViewController <UIWebViewDelegate> {
    
}

- (void)loadChartWithHTML:(NSString*)html senchaBundleURL:(NSString *)bundle;

@end
