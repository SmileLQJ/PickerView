//
//  TimeVC.m
//  LDmoe
//
//  Created by 四川利远扬信息技术有限公司 on 2018/8/25.
//  Copyright © 2018年 四川利远扬信息技术有限公司. All rights reserved.
//

#import "TimeVC.h"

@interface TimeVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *hourArray;
@property(nonatomic,strong)NSMutableArray *minuteArray;
@property(nonatomic,strong)NSString *selectHour;//选中小时
@property(nonatomic,assign)NSInteger index;//选择分钟下标
@property(nonatomic,strong)NSString *selectTime;//选中的时间
@end

@implementation TimeVC
- (NSMutableArray *)hourArray{
    if (!_hourArray) {
        self.hourArray = [NSMutableArray new];
    }
    return _hourArray;
}
- (NSMutableArray *)minuteArray{
    if (!_minuteArray) {
        self.minuteArray = [NSMutableArray new];
    }
    return _minuteArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self getHourArray];
    [self getMinuteArray:15];
    //自动滑动到可以选值
    [self selectRowAndinComponent];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.pickerView.frame)/2 - 2.5, CGRectGetHeight(self.pickerView.frame)/2- 12, 5, 20)];
    lab.text = @":";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:24.0];
    [self.pickerView addSubview:lab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTapAction:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark -- 跳转可选择值
- (void)selectRowAndinComponent{
    if (self.timeDic.allKeys.count) {
        //CGFloat max = [[self.timeDic.allKeys valueForKeyPath:@"@max.floatValue"] floatValue];
        NSInteger minH = [[self.timeDic.allKeys valueForKeyPath:@"@min.floatValue"] integerValue];
        NSArray *valueArr = [self.timeDic objectForKey:[NSString stringWithFormat:@"%ld",minH]];
        NSInteger minM = [[valueArr valueForKeyPath:@"@min.floatValue"] integerValue];
        NSInteger indexM = minM/15;
        [self.pickerView selectRow:minH inComponent:0 animated:YES];
        [self.pickerView selectRow:indexM inComponent:1 animated:YES];
        
        self.selectHour = [NSString stringWithFormat:@"%ld",minH];
        self.index = indexM;

    }else{
        [self.pickerView selectRow:9 inComponent:0 animated:YES];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        self.selectHour = @"9";
        self.index = 0;
    }
     self.selectTime = [NSString stringWithFormat:@"%@:%@",self.selectHour,self.minuteArray[self.index]];
    [self getHint:self.index];
    
}



#pragma mark -- 生成小时
- (void)getHourArray{
    for (int i = 0; i < 24; i ++) {
        [self.hourArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
}
#pragma mark -- 生成分钟
- (void)getMinuteArray:(NSInteger)IntervalValue{
    for (int i = 0; i < 60; i += IntervalValue) {
        if (i >  60) return;
        if (i == 0) {
            [self.minuteArray addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [self.minuteArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
    }
}


#pragma mark pickerview function
//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0)return self.hourArray.count;
    return self.minuteArray.count;
}
//要修改picker滚动里每行文字的值及相关属性，分割线等在此方法里设置
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色,这里设为隐藏
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = [UIColor clearColor];
        }
        
    }
    //设置文字的属性
    UILabel *timeLabel = [UILabel new];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:24.0];
    
    timeLabel.textColor =  [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0];
    BOOL isOptional = NO;
    if (component == 0) {
        timeLabel.text = self.hourArray[row];
        if ([self.timeDic.allKeys containsObject:self.hourArray[row]]) {
            isOptional = YES;
        }
    }else{
        timeLabel.text = self.minuteArray[row];
        if ([self.timeDic.allKeys containsObject:self.selectHour]) {
            if ([[self.timeDic objectForKey:self.selectHour] containsObject:self.minuteArray[row]]) {
                isOptional = YES;
            }
        }
        
    }
    if (!self.timeDic.allKeys.count)  isOptional = YES;
    if (!isOptional) {
        // 横线的颜色跟随label字体颜色改变
        NSMutableAttributedString *newTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",timeLabel.text]];
        [newTime addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newTime.length)];
        timeLabel.attributedText = newTime;
    }
    
    return timeLabel;
    
}


//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return CGRectGetWidth(pickerView.frame)/4;
}
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        self.selectHour = self.hourArray[row];
        [self.pickerView reloadComponent:component + 1];
    }else{
        self.index = row;
    }
    
    [self getHint:self.index];
    self.selectTime = [NSString stringWithFormat:@"%@:%@",self.selectHour,self.minuteArray[self.index]];
}

#pragma mark -- 修改提示语
- (void)getHint:(NSInteger)index{
    if ([self isOptiona:index]) {
        self.titleLab.text = self.optionaHint;
        self.titleLab.textColor = [UIColor blackColor];
    }else{
        self.titleLab.text = self.noOptionaHint;
        self.titleLab.textColor = [UIColor colorWithRed:250/255.0 green:125/255.0 blue:70/255.0 alpha:1.0];
    }
}
#pragma mark -- 判断是否可选
- (BOOL)isOptiona:(NSInteger)index{
    //如果限定时间没有值
    if (!self.timeDic.allKeys.count)return YES;
    
    if ([self.timeDic.allKeys containsObject:self.selectHour]) {
        if ([[self.timeDic objectForKey:self.selectHour] containsObject:self.minuteArray[index]]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}


- (IBAction)clickCancelBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickNextBtnAction:(UIButton *)sender {
    if (![self isOptiona:self.index]) return;
    if (self.blockTime) {
        self.blockTime(self.selectTime);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -- 点击事件
- (void)clickTapAction:(UITapGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isEqual:self.view]) {
        return YES;
    }
    return  NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
