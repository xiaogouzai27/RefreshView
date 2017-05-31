//
//  ConfigDataManager.m
//  RefreshView
//
//  Created by everp2p on 17/4/1.
//  Copyright © 2017年 TangLiHua. All rights reserved.
//

#import "ConfigDataManager.h"
#import "Model.h"

@interface ConfigDataManager ()
{
    NSInteger bearCount;//计息中
    NSInteger finishConut;//已完结
    NSInteger allCount;//计息中+已完结
    NSMutableArray *_dataArray;
    NSInteger pullCount;//下拉数据
}

@end

@implementation ConfigDataManager

+(instancetype)shareManager
{
    static ConfigDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[ConfigDataManager alloc] init];
    });
    return instance;
}

-(void)initDataWithBearingCount:(NSInteger)m andFinishCount:(NSInteger)n
{
    bearCount = m;
    finishConut = n;
    allCount = m + n;
    _dataArray = [NSMutableArray array];
    [self setData:m andType:Bear];
    [self setData:n andType:Finish];
}

- (void)setData:(NSInteger)number andType:(ModelType)type
{
    for (int i = 0; i < number; i++) {
        Model *model = [[Model alloc] init];
        model.index = 1 + (NSInteger)i;
        model.type = type;
        if (type == Bear){
            model.des = @"计息中";
        }else{
            model.des = @"已完结";
        }
        [_dataArray addObject:model];
    }
}

-(NSArray *)start
{
    NSArray *array = [NSArray array];
    pullCount = 0;
    if (!allCount) return array;
    if (bearCount) {
        array = [self getStartInfoByCount:bearCount];
        return array;
    }
    if (finishConut) {
        array = [self getStartInfoByCount:finishConut];
        return array;
    }
    return array;
}

- (NSArray *)getStartInfoByCount:(NSInteger)count
{
    NSMutableArray *array = [NSMutableArray array];
    if (count > 10) {
        for (int i = 0; i < 10; i++) {
            [array addObject:_dataArray[i]];
        }
    }else{
        for (int i = 0; i < count; i++) {
            [array addObject:_dataArray[i]];
        }
    }
    pullCount = array.count;
    return array;
}

-(NSArray *)refresh
{
    NSMutableArray * array = [NSMutableArray array];
    //表示刷新已经完成
    if (allCount <= pullCount) return array;
    if (bearCount>pullCount) {                   //表示计息中数量大于当前显示输了
        if (bearCount>pullCount+10) {
            for (NSInteger i = pullCount; i<pullCount+10; i++) {
                [array addObject:_dataArray[i]];
            }
            pullCount += 10;
        }else{
            for (NSInteger i = pullCount; i<bearCount; i++) {
                [array addObject:_dataArray[i]];
            }
            pullCount = bearCount;
        }
        return array;
    }
    //表示已经进入已完结的项目
    if (allCount>pullCount+10) {
        for (NSInteger i = pullCount; i<pullCount+10; i++) {
            [array addObject:_dataArray[i]];
        }
        pullCount += 10;
    }else{
        for (NSInteger i = pullCount; i<allCount; i++) {
            [array addObject:_dataArray[i]];
        }
        pullCount = allCount;
    }
    return array;
}

-(NSString *)getFooterTitle
{
    if (!allCount) return @"无投资记录";
    if (pullCount>=allCount) return @"没有更多数据";
    Model * model1 = _dataArray[pullCount-1];           //前一个model
    Model * model2 = _dataArray[pullCount];             //后一个model
    if (model1.type == model2.type) {                   //前后两个type一致时
        return @"上拉或点击加载更多";
    }else{
        return @"查看已完结数据";
    }

}

@end



























