//
//  InterfaceDetailViewController.h
//  TestWatchApp Extension
//
//  Created by Company on 2019/09/21.
//  Copyright © 2019 Active User Co.,LTD. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import "SampleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InterfaceDetailViewController : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfaceButton *upBt;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *detailCountLbl;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *downBt;
@property (strong, nonatomic) SampleModel *data;


@end

NS_ASSUME_NONNULL_END
