//
//  InterfaceDetailViewController.m
//  TestWatchApp Extension
//
//  Created by Company on 2019/09/21.
//  Copyright © 2019 Active User Co.,LTD. All rights reserved.
//

#import "InterfaceDetailViewController.h"
#import "DBHelper.h"

@interface InterfaceDetailViewController() {
}

@end

@implementation InterfaceDetailViewController

-(void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    if (context) {
        _data = (SampleModel *)context;
        [self updateView];
    } else {
        [self dismissController];
    }
}

-(void)updateView {
    [_detailCountLbl setText:[NSString stringWithFormat:@"%d", _data.num]];
}

-(void)updateData {
    [DBHelper.sharedManager updateData:_data];
}

- (IBAction)onUpClicked {
    _data.num ++;
    [self updateView];
    [self updateData];
}

- (IBAction)onDownClicked {
    _data.num --;
    [self updateView];
    [self updateData];
}

@end
