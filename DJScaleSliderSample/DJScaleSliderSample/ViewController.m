//
//  ViewController.m
//  DJScaleSliderSample
//
//  Created by DJ on 2018/3/7.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "ViewController.h"
#import "DJScaleSlider.h"

@interface ViewController ()
<
    DJScaleSliderDelegate
>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DJScaleSlider *scaleSlider = [[DJScaleSlider alloc] initWithFrame:CGRectMake(50, 200, 300, 300) minValue:1000 maxValue:10000 step:100];
    scaleSlider.delegate = self;
    scaleSlider.valueFormat = ^NSString * _Nonnull(NSInteger value) {
        NSString *foramtValue = [NSString stringWithFormat:@"%ld元", value];
        return foramtValue;
    };
    scaleSlider.selectMinValue = 3000;
    scaleSlider.selectMaxValue = 6000;
    scaleSlider.showTitle = NO;
    
    [self.view addSubview:scaleSlider];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scaleSlider:(DJScaleSlider *)slider valueChanged:(NSInteger)value
{
    NSLog(@"value: %@", @(value));
}


@end
