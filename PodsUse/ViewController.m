//
//  ViewController.m
//  PodsUse
//
//  Created by Macbook Pro on 2020/8/7.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "ReactiveObjC.h"
#import "RACReturnSignal.h"
#import "OrderListModel.h"
@interface ViewController ()
@property(nonatomic,strong) OrderListModel *model;
@end

@implementation ViewController

- (void)viewDidLoad {
    self.model = [OrderListModel new];
    [super viewDidLoad];
    [self RACuseMethod];

}
#pragma mark --ReactiveObjC 的使用
- (void)RACuseMethod
{
    UITextField *nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, 300, 40)];
       nameTextField.borderStyle = UITextBorderStyleRoundedRect;
       [self.view addSubview:nameTextField];
       
       UITextField *psdTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 150, 300, 40)];
       psdTextField.borderStyle = UITextBorderStyleRoundedRect;
       [self.view addSubview:psdTextField];
       
       UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
       addBtn.center = self.view.center;
       [self.view addSubview:addBtn];
    
    
//    [self RAC_CombineLatestWithNameTF:nameTextField psdTF:psdTextField button:addBtn];
//    [self RAC_reduceWithNameTF:nameTextField psdTF:psdTextField];
//    [self RAC_mapWithNameTF:nameTextField];
//    [self RAC_flattenMapWithNameTF:nameTextField];
//    [self RAC_mergeWithNameTF:nameTextField psdTF:psdTextField];
//    [self RAC_takeWithbutton:addBtn];
//    [self RAC_takeLastNum:2];
//    [self RAC_filterWithNameTF:nameTextField];
//    [self RAC_ignoreWithNameTF:nameTextField];
//    [self RAC_distinctUntilChangedWithNameTF:nameTextField];
//    [self RAC_thenWithTwoSignal];
//    [self RAC_zipWithNameTF:nameTextField button:addBtn];
//    [self RAC_takeUntilNameTF:nameTextField button:addBtn];
//    [self RAC_skipNum:3 button:addBtn];
//    [self RAC_switchToLatest];
//    [self RAC_doNext];
//    [self RAC_interval];
//    [self RAC_delayButton:addBtn];
//    [self RAC_retry];
//    [self RAC_replay];
//    [self RAC_throttleButton:addBtn];
//    [self RAC_RACChannelTerminalWithNameTF:nameTextField psdTF:psdTextField];
    [self RAC_RACTARGETWithNameTF:nameTextField];
    
}
//1--CombineLatest 合并（触发最后一个信号的时候统一返回所有信号结果）
-(void)RAC_CombineLatestWithNameTF:(UITextField *)nameTf psdTF:(UITextField *)psdTf button:(UIButton *)btn
{
    RACSignal *signalBtn = [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    [[RACSignal combineLatest:@[nameTf.rac_textSignal, psdTf.rac_textSignal ,signalBtn]] subscribeNext:^(RACTuple * _Nullable x) {
          NSLog(@"CombineLatest==%@",x);
        NSString *firstText = x.first;
        NSString *secondText = x.second;
        NSString *thirdBtn = x.third;
    
      }];
}

//2--reduce 减少
//实用性*****非常实用
/*下面这段代码，可用于登录时的操作，监听两个文本框的值，如果都有值，返回的BOOL值可以给按钮，让按钮变成可点击状态。如果不满足条件，则不可点击！！！
 */
-(void)RAC_reduceWithNameTF:(UITextField *)nameTf psdTF:(UITextField *)psdTf
{
    [[RACSignal combineLatest:@[nameTf.rac_textSignal,psdTf.rac_textSignal] reduce:^id _Nonnull(NSString *name,NSString *psd){
        
        return @(name.length>0&&psd.length>0);
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%d",[x boolValue]);
    }];
    
}

//3--map 映射   取到监听后的值，映射成一个新值，返回出去！
//实用性****比较实用
/*开发中，如果信号发出的值不是信号，映射一般使用Map
 */
-(void)RAC_mapWithNameTF:(UITextField *)nameTf
{
    [[nameTf.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length == 11);
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"手机号为11位登录按钮是否可以点击==%d",[x boolValue]);
    }];
    
}
//4--flattenMap：映射，取到信号源的值，映射成一个新的信号，返回出去！！
/*开发中，如果信号发出的值是信号，映射就使用FlatternMap
*/
-(void)RAC_flattenMapWithNameTF:(UITextField *)nameTf
{
    [[[nameTf rac_textSignal] flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        value = [NSString stringWithFormat:@"数据处理：%@",value];
        return [RACReturnSignal return:value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"flattenMap==%@",x);
    }];
}
//5--merge 捆绑 、合并
//实用性**用处不多
/*把多个信号捆绑在一起，任何一个信号有新值都会触发这个捆绑的信号！谁触发的信号，就拿到谁的值！
 */
-(void)RAC_mergeWithNameTF:(UITextField *)nameTf psdTF:(UITextField *)psdTf
{
    [[[nameTf rac_textSignal] merge:[psdTf rac_textSignal]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"merge==%@",x);
    }];
    
}
//6--take：从开始一共取N次的信号
//实用性**用处不多
/*你点击按钮的前三次，都会有打印，第四次开始就不会再打印了。
 */
-(void)RAC_takeWithbutton:(UIButton *)btn
{
    RACSignal *signalBtn = [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    [[signalBtn take:3] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}
//7--takeLast：取最后N次的信号
//实用性**用处不多
/*n为2的时候只会打印3和4，取的是最后两次的信号！！！
RACSubject既可以作为信号，又可以发送信号!!!
 */
-(void)RAC_takeLastNum:(NSInteger )n
{
    RACSubject *subject = [RACSubject subject];
    [[subject takeLast:n] subscribeNext:^(id  _Nullable x) {
        NSLog(@"takeLast==%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendNext:@"4"];
    [subject sendCompleted];
}
//8--filter：过滤信号，return 满足条件的信号。
//实用性*****用处多
/*输入框内只有你输入满足条件的数字才会被打印出来！！！
 */
-(void)RAC_filterWithNameTF:(UITextField *)nameTf
{
    [[[nameTf rac_textSignal] filter:^BOOL(NSString * _Nullable value) {
        return [value integerValue] % 2 == 0;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"filter2==%@",x);
    }];
    
}
//9--ignore：忽略信号，忽略掉你规定的值。
//实用性*****用处多
/*输入框出现“3”将不被打印！！！内部还是调用filter来实现的。
 */
-(void)RAC_ignoreWithNameTF:(UITextField *)nameTf
{
    [[[nameTf rac_textSignal] ignore:@"3"] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"ignore==%@",x);
    }];
    
}
//10--distinctUntilChanged：监听的值有明显变化时，才会发出信号。
//实用性*****用处多
/*UI刷新的时候，用的最多。
 */
-(void)RAC_distinctUntilChangedWithNameTF:(UITextField *)nameTf
{
    [[[nameTf rac_textSignal] distinctUntilChanged] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"ignore==%@",x);
    }];
    
}
//11--concat：按顺序拼接信号，按顺序接收信号，但是必须等上一个信号完成，下一个信号才有用！！！
//实用性*****用处多
/*可用于两个网络请求的数据之间有依赖关系！！！
 */
-(void)RAC_concatWithTwoSignal
{

    RACSignal *signalTwo = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"解压"];
        return nil;
    }];
        RACSignal *signalOne = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"下载"];
            //[subscriber sendCompleted];如果去掉这句代码，代表这个信号没有结束，下一个信号一直处于等待状态，永远不会打印"解压"
            [subscriber sendCompleted];
            return nil;
        }];
    
    [[signalOne concat:signalTwo] subscribeNext:^(id  _Nullable x) {
        NSLog(@"concat==%@",x);
        
    }];
    
}
//12--then：也是拼接信号，一样需要前面的信号调用sendCompleted，才会发送信号。
//实用性**用处不多
/*然而他永远不会打印“下载”，只会打印拼接在最后的一个信号！！！
 */
-(void)RAC_thenWithTwoSignal
{

    RACSignal *signalTwo = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"解压"];
        return nil;
    }];
    RACSignal *signalOne = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"下载"];
        //[subscriber sendCompleted];如果去掉这句代码，代表这个信号没有结束，下一个信号一直处于等待状态，永远不会打印"解压"
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[signalOne then:^RACSignal * _Nonnull{
        return signalTwo;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"then==%@",x);
    }];
}
//13--zipWith：把两个信号压缩成一个信号，且必须两个信号都触发了（同次数），才会打印。两个信号的值，会合并成一个元组。
//实用性**用处不多
/*输入框触发了三次后，点击一下按钮，就会打印出输入框第一次触发的值和按钮的值！！当按钮点击四次后，不会有打印。必须再次触发输入框的信号，才会打印
 */
-(void)RAC_zipWithNameTF:(UITextField *)nameTf button:(UIButton *)btn
{
    RACSignal *signalBtn = [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    [[[nameTf rac_textSignal] zipWith:signalBtn] subscribeNext:^(RACTwoTuple<NSString *,id> * _Nullable x) {
        NSLog(@"zipWith==%@",x);
        
    }];
}
//14--takeUntil：直到某个信号触发，不再监听。
//实用性**用处不多
/*点击按钮以后，就再也不会打印了！！！
 */
-(void)RAC_takeUntilNameTF:(UITextField *)nameTf button:(UIButton *)btn
{
    RACSignal *signalBtn = [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    [[[nameTf rac_textSignal] takeUntil:signalBtn] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"takeUntil==%@",x);
    }];
}
//15--skip：跳过前面N次信号，和take相反
//实用性**用处不多
/*按钮前三次点击无打印，第四次点击以后，都会打印！！！
 */
-(void)RAC_skipNum:(NSInteger )n button:(UIButton *)btn
{
    RACSignal *signalBtn = [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    [[signalBtn skip:n] subscribeNext:^(id  _Nullable x) {
        NSLog(@"skip==%@",x);
    }];
}
//16--switchToLatest：用来接收信号发出的信号。
//实用性**用处不多
/*只能用于信号发出的信号
 */
-(void)RAC_switchToLatest
{
    RACSubject *Asignal = [RACSubject subject];
    RACSubject *Bsignal = [RACSubject subject];
    
    [Asignal.switchToLatest subscribeNext:^(id x) {
        //打印出 1
        NSLog(@"switchToLatest==%@",x);
    }];
    //A发送B
    [Asignal sendNext:Bsignal];
    //B发送 1
    [Bsignal sendNext:@1];
}
//17--doNext和doCompleted和doError：在发送信号前。
//实用性**用处不多
/*
 */
-(void)RAC_doNext
{
    [[[[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"ios developer"];
        //sendError和sendCompleted只可以存在一个
//        [subscriber sendError:nil];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id  _Nullable x) {
        //执行[subscriber sendNext:@"ios developer"]前会先走这个block
        NSLog(@"doNext");
    }] doCompleted:^{
        //执行[subscriber sendCompleted]前会先走这个block
        NSLog(@"doCompleted");
    }] doError:^(NSError * _Nonnull error) {
                
        NSLog(@"error = %@",error);

    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"x = %@",x);
    }];
}
//18--interval：多少秒执行一次。
//实用性**用处不多
/*
 */
-(void)RAC_interval
{
    //每秒都会打印现在的时间,一直打印，直到天荒地老...
//     [[RACSignal interval:1 onScheduler:[RACScheduler scheduler]] subscribeNext:^(NSDate * _Nullable x) {
//           NSLog(@"interval1==%@",x);
//       }];
    
    //要记得调用takeUntil来结束它，不然一直打印，直到天荒地老...
    [[[RACSignal interval:1 onScheduler:[RACScheduler scheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"interval2==%@",x);
    }];
    
}
//19--delay：延迟多少秒执行。
//实用性****用处多
/*点击按钮后，过3秒才打印
 */
-(void)RAC_delayButton:(UIButton *)btn
{
    RACSignal *signalBtn = [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    [[signalBtn delay:3] subscribeNext:^(id  _Nullable x) {
        NSLog(@"delay==%@",x);
    }];
}
//20--retry：重试，直到成功。
//实用性****用处多
/*直到a=4才会打印出来
 */
-(void)RAC_retry
{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        static int a = 1;
        if (a > 3) {
            [subscriber sendNext:@(a)];
        }else{
            [subscriber sendError:nil];
        }
        a++;
        return nil;
        
    }] retry] subscribeNext:^(id x) {
        NSLog(@"retry==%@",x);
    } error:^(NSError *error) {
        NSLog(@"error1==%@",error);

    }];
}
//21--replay：被多次订阅后，每次都是重新执行。
//实用性**用处不多
/*被连续三次订阅，打印出来的值都是15，说明后面的每次订阅a=10！！！如果去除replay，将会打印出15、20、25！！加上replay后，后面的订阅者都是从10开始算的！！！
 */
-(void)RAC_replay
{
    __block int a = 10;
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        a += 5;
        [subscriber sendNext:@(a)];
        return nil;
    }]replay];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"第三个订阅者%@",x);
    }];
}
//22--throttle：节流，某个时间内只获取最后一次的信号。
//实用性****用处多
/*如果一秒点了一百下按钮(单身的手速)，那么再过一秒，只会打印出你第一百下点击按钮时的信号，前面的99次都不接收！！！从你不点击按钮后算三秒！！！
 可用于按钮的防止重复点击功能
 */
-(void)RAC_throttleButton:(UIButton *)btn
{
    RACSignal *signalBtn = [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    [[signalBtn throttle:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"throttle==%@",x);
    }];
}
//23--RACSequence：RAC里的集合类
//实用性****用处多
/*可以和数组之间任意转换
 */
-(void)RAC_RACSequence
{
    NSArray * arr = @[@(1), @(2), @(3), @(4), @(5)] ;
    RACSequence * s1 = [arr rac_sequence];
    arr = [s1 array];
}
//24--RACChannelTerminal：用来实现双向绑定的类
//实用性****用处不多
/*不管怎么输入，两个输入框里的内容已经完全保持一致了！！！
 */
-(void)RAC_RACChannelTerminalWithNameTF:(UITextField *)nameTf psdTF:(UITextField *)psdTf
{
    RACChannelTerminal * signalnameText = [nameTf rac_newTextChannel];
    RACChannelTerminal * signalpwdText = [psdTf rac_newTextChannel];
    [signalnameText subscribe:signalpwdText];
    [signalpwdText subscribe:signalnameText];
}
//25--RAC(TARGET, ...)：获取某个信号的值赋给属性
//实用性****用处不多
/*输入框里的值不停的变化，那么person类的name属性值，也会不停的变化！！
 */
-(void)RAC_RACTARGETWithNameTF:(UITextField *)nameTf
{
//25--获取某个信号的值赋给属性
    RAC(self.model,name) = nameTf.rac_textSignal;
    
//26--RACObserve(TARGET, KEYPATH)：监听某个类的某个属性  属性的值一但改变就会打印出来！！！
    [RACObserve(self.model, name) subscribeNext:^(id  _Nullable x) {
        NSLog(@"self.model.name==%@",self.model.name);
       }];
}
@end
