//
//  SampleModel.h
//  DataKit
//
//  Created by Company on 2019/09/22.
//  Copyright © 2019 Active User Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SampleModel : NSObject

@property (assign, nonatomic) int Id;
@property (assign, nonatomic) int num;
@property (assign, nonatomic) NSString *des;

-(id)initWithNum:(int)n :(NSString *)d;

@end

NS_ASSUME_NONNULL_END
