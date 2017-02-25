//
//  ViewController1.m
//  ReactiveCocoa
//
//  Created by comfouriertech on 17/2/24.
//  Copyright © 2017年 ronghua_li. All rights reserved.
//

#import "ViewController1.h"
#import "ViewController2.h"
@interface ViewController1 ()

@end

@implementation ViewController1
//四、RACSubject替换代理
- (IBAction)clickBtn1:(id)sender
{
    ViewController2 *vc2=[[ViewController2 alloc] init];
    vc2.delegateSignal=[RACSubject subject];
    [vc2.delegateSignal subscribeNext:^(id x)
    {
        NSLog(@"vc2的按钮被点击了");
    }];
    [self presentViewController:vc2 animated:YES completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //一、RACSignal 简单使用
    //1.创建信号
    RACSignal *signal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
    {
        //block调用时刻：每当有订阅信号，就会调用block
        //2.发送信号
        [subscriber sendNext:@"RACSignal"];
        //当不在发送数据时,最好调用发送完成方法，内部会自动调用[RACDisposable disposable]方法取消订阅信号
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            //block调用时刻：当信号发送完成或者发送错误，调用block，取消订阅信号
            //执行完block，当前信号就不再被订阅
            NSLog(@"RACSignal,当前信号取消订阅");
            
        }];
    }];
    //3.订阅信号，才会激活信号
    [signal subscribeNext:^(id x)
     {
         //block调用时刻：每当有信号发送出来时，调用block
         NSLog(@"RACSignal,接收到数据：%@",x);
        
     }];
    
    //二、RACSubject和RACReplaySubject简单使用
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"RACSubject，第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"RACSubject，第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@"RACSubject"];

    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@"RACReplaySubject1"];
    [replaySubject sendNext:@"RACReplaySubject2"];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x)
    {
        
        NSLog(@"RACReplaySubject,第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"RACReplaySubject,第二个订阅者接收到的数据%@",x);
    }];

    //三、RACTuple:元组类,类似NSArray,用来包装值
    // 1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"ronghua_li",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
        
    }];
    //3.字典转模型
    
    //五、RACCommand简单使用
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
