//
//  AppDelegate.h
//  LDmoe
//
//  Created by 四川利远扬信息技术有限公司 on 2018/8/25.
//  Copyright © 2018年 四川利远扬信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

