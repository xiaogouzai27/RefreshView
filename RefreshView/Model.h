//
//  Model.h
//  RefreshView
//
//  Created by everp2p on 17/4/1.
//  Copyright © 2017年 TangLiHua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum :NSUInteger{
    Bear,
    Finish,
}ModelType;


@interface Model : NSObject

@property (nonatomic,assign) ModelType type;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy) NSString *des;

@end
