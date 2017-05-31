//
//  ConfigDataManager.h
//  RefreshView
//
//  Created by everp2p on 17/4/1.
//  Copyright © 2017年 TangLiHua. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConfigDataManager : NSObject

+(instancetype)shareManager;

-(void)initDataWithBearingCount:(NSInteger)m andFinishCount:(NSInteger)n;

-(NSArray *)start;

-(NSArray *)refresh;

-(NSString *)getFooterTitle;





@end
