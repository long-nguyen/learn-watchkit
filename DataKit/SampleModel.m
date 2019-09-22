//
//  SampleModel.m
//  DataKit
//
//  Created by Company on 2019/09/22.
//  Copyright © 2019 Active User Co.,LTD. All rights reserved.
//

#import "SampleModel.h"

@implementation SampleModel

-(id)initWithNum:(int)n :(NSString *)d {
    if (self = [super init]) {
        self.num = n;
        self.des = d;
    }
    return self;
}

@end
