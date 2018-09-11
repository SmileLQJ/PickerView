//
//  ViewController.m
//  LDmoe
//
//  Created by 四川利远扬信息技术有限公司 on 2018/8/25.
//  Copyright © 2018年 四川利远扬信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "TimeVC.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(100, 100, 50, 50);
    [btn setTitle:@"时间" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(clickBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
   
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)clickBtnAction:(UIButton *)sender{
    TimeVC *tVC = [TimeVC new];
    tVC.timeDic = @{@"11":@[@"15",@"45"],@"10":@[@"00",@"45"]};//可以选时间
    tVC.optionaHint = @"请选择取车时间";
    tVC.noOptionaHint = @"本时间不可组";
    tVC.modalTransitionStyle =  UIModalTransitionStyleCoverVertical;
    tVC.providesPresentationContextTransitionStyle = YES;
    tVC.definesPresentationContext = YES;
    tVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    tVC.blockTime = ^(NSString *time) {
        [sender setTitle:time forState:(UIControlStateNormal)];
        NSLog(@"%@",time);
    };
    [self presentViewController:tVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
