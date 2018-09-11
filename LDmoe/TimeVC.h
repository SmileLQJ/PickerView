//
//  TimeVC.h
//  LDmoe
//
//  Created by 四川利远扬信息技术有限公司 on 2018/8/25.
//  Copyright © 2018年 四川利远扬信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeVC : UIViewController
@property(nonatomic,strong)NSDictionary *timeDic;//可选时间(key: 小时, value:分钟),不传全部可选
@property(nonatomic,strong)NSString *optionaHint;//可选提示语
@property(nonatomic,strong)NSString *noOptionaHint;//不可选提示语
@property(nonatomic,copy)void (^blockTime)(NSString *time);
@end
