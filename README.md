# PickerView

使用方法
 
    TimeVC *tVC = [TimeVC new];
    tVC.timeDic = @{@"11":@[@"15",@"45"],@"10":@[@"00",@"45"]};//可以选时间
    tVC.optionaHint = @"请选择取车时间";
    tVC.noOptionaHint = @"本时间不可组";
    tVC.modalTransitionStyle =  UIModalTransitionStyleCoverVertical;
    tVC.providesPresentationContextTransitionStyle = YES;
    tVC.definesPresentationContext = YES;
    tVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    tVC.blockTime = ^(NSString *time) {//回调选中时间
        [sender setTitle:time forState:(UIControlStateNormal)];
        NSLog(@"%@",time);
    };
    [self presentViewController:tVC animated:YES completion:nil];
