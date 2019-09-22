//
//  InterfaceController.h
//  TestWatchApp Extension
//
//  Created by Company on 2019/09/21.
//  Copyright © 2019 Active User Co.,LTD. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface RowController : NSObject

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *countLbl;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *titleLbl;

@end

@interface InterfaceController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceTable *tbView;

@end
