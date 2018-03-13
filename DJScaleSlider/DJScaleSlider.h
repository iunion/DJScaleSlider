//
//  DJScaleSlider.h
//  DJScaleSliderSample
//
//  Created by DJ on 2018/3/7.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSUInteger, DJScaleSlider_ScaleType)
//{
//    DJScaleSlider_ScaleType_Ten,
//    DJScaleSlider_ScaleType_Five
//};

NS_ASSUME_NONNULL_BEGIN

@class DJScaleSlider;
typedef void (^scaleSliderValueChangeHandler)(DJScaleSlider *scaleSlider);
typedef NSString * _Nonnull (^scaleSliderFormatValueHandler)(NSInteger value);

@protocol DJScaleSliderDelegate;

@interface DJScaleSlider : UIView

@property (nonatomic, weak) id <DJScaleSliderDelegate> delegate;

//@property (nonatomic, assign) DJScaleSlider_ScaleType scaleType;
@property (nonatomic, assign) BOOL needSnap;

@property (nonatomic, assign, readonly) NSInteger minValue;
@property (nonatomic, assign, readonly) NSInteger maxValue;
@property (nonatomic, assign, readonly) NSUInteger step;

@property (nullable, nonatomic, copy) scaleSliderFormatValueHandler valueFormat;

@property (nonatomic, assign) NSInteger selectMinValue;
@property (nonatomic, assign) NSInteger selectMaxValue;

@property (nonatomic, assign) NSInteger realValue;

- (instancetype)initWithFrame:(CGRect)frame minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue step:(NSUInteger)step;

- (void)setRealValue:(NSInteger)realValue animated:(BOOL)animated;

@end

@protocol DJScaleSliderDelegate <NSObject>

@optional
- (void)scaleSlider:(DJScaleSlider *)slider valueChanged:(NSInteger)value;

@end

NS_ASSUME_NONNULL_END

