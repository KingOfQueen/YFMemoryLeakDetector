# YFMemoryLeakDetector
一个工具类: 零配置,运行时自动实时监测 iOS 应用内存泄露情况

## 安装

把[工具库源码](https://github.com/ios122/YFMemoryLeakDetector/tree/master/memory_leak_detection/memory_leak_detection/lib)拖拽到项目中即可。

## 使用示例：

这里展示一个基于工具类，二次分析的示例:

```oc
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
```

## 技术实现

详见：[【YFMemoryLeakDetector】人人都能理解的 iOS 内存泄露检测工具类](http://yanfeng.life/2017/11/23/YFMemoryLeakDetector-intro/)