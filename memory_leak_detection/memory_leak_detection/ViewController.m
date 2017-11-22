//
//  ViewController.m
//  memory_leak_detection
//
//  Created by 颜风 on 2017/11/22.
//  Copyright © 2017年 yanfeng. All rights reserved.
//

#import "ViewController.h"
#import "YFMemoryLeakDetector.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 100)];
    tipLabel.text = @"检测结果,详见 Xcode 控制台输出!";
    
    [self.view addSubview: tipLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        YFMemoryLeakDetector * memoryLeakDetector = [YFMemoryLeakDetector sharedInstance];
        
        /* 控制器检测结果的输出. */
        [memoryLeakDetector.loadedViewControllers enumerateKeysAndObjectsUsingBlock:^(NSValue *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            UIViewController * vc = (UIViewController *)[key pointerValue];
            if (!vc.parentViewController) { /* 进一步过滤掉有父控制器的控制器. */
                NSLog(@"有内存泄露风险的控制器: %@", obj);
            }
        }];
        
        /* 视图检测结果的输出. */
        [memoryLeakDetector.loadedViews enumerateKeysAndObjectsUsingBlock:^(NSValue *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            UIView * view = (UIView *)[key pointerValue];
            if (!view.superview) { /* 进一步过滤掉有父视图的视图,即只输出一组视图的根节点,这样便于更进一步定位问题. */
                NSLog(@"有内存泄露风险的视图: %@", obj);
            }
        }];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
