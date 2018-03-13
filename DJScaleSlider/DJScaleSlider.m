//
//  DJScaleSlider.m
//  DJScaleSliderSample
//
//  Created by DJ on 2018/3/7.
//  Copyright © 2018年 DennisDeng. All rights reserved.
//

#import "DJScaleSlider.h"

#define collectionViewTag       20180307

// 文本
#define valueTextFieldFont      [UIFont systemFontOfSize:18.0f]
#define valueTextColor          [UIColor orangeColor]
#define valueTextLineColor      [UIColor orangeColor]
#define valueTextFieldHeight    30.0f

#define valueTextFieldGap       8.0f

// 标尺文本
#define scaleTitleFont          [UIFont systemFontOfSize:10.0f]
#define scaleTitleHeight        14.0f

#define scaleTitleGap           2.0f

// 标尺
#define scaleGap                (6.0f)
#define longScaleHeight         (18.0f)
#define middleScaleHeight       (12.0f)
#define shortScaleHeight        (9.0f)

// 标刻线
#define redLineHeight           20.0f
#define redLineColor            [UIColor orangeColor]

// 限制范围
#define minLineColor           [UIColor greenColor]
#define maxLineColor           [UIColor redColor]

// 用户输入等待时间
#define waitingUserInput       (1.2f)


#pragma mark - DJScaleFirstView

@interface DJScaleFirstView : UIView

@property (nonatomic, assign) NSInteger minValue;
@property (nullable, nonatomic, copy) scaleSliderFormatValueHandler valueFormat;

@property (nonatomic, assign) NSInteger selectMinValue;
@property (nonatomic, assign) NSInteger selectMaxValue;

@end

@implementation DJScaleFirstView

- (void)drawRect:(CGRect)rect
{
    CGFloat longLineY = rect.size.height - longScaleHeight;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    // 设置线的宽度, 默认是1像素
    //CGContextSetLineWidth(context, 2.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    // 起使点
    CGContextMoveToPoint(context, rect.size.width, longLineY);
    NSString *numStr = [NSString stringWithFormat:@"%ld", self.minValue];
    if (self.valueFormat)
    {
        numStr = self.valueFormat(self.minValue);
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:scaleTitleFont, NSForegroundColorAttributeName:[UIColor colorWithWhite:0.7 alpha:1]};
    CGFloat width = [numStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [numStr drawInRect:CGRectMake(rect.size.width-width*0.5f, 0, width, scaleTitleHeight) withAttributes:attribute];
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);

    if (self.selectMinValue == self.minValue)
    {
        // 起使点
        CGContextSetStrokeColorWithColor(context, minLineColor.CGColor);
        CGContextMoveToPoint(context, rect.size.width, longLineY);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
        CGContextStrokePath(context);
    }

    if (self.selectMaxValue == self.minValue)
    {
        // 起使点
        CGContextSetStrokeColorWithColor(context, maxLineColor.CGColor);
        CGContextMoveToPoint(context, rect.size.width, longLineY);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
        CGContextStrokePath(context);
    }
}

@end


#pragma mark -
#pragma mark DJScaleMiddleView

@interface DJScaleMiddleView : UIView

@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nullable, nonatomic, copy) scaleSliderFormatValueHandler valueFormat;

@property (nonatomic, assign) NSInteger selectMinValue;
@property (nonatomic, assign) NSInteger selectMaxValue;

@end

@implementation DJScaleMiddleView

- (void)drawRect:(CGRect)rect
{
    CGFloat startX = 0;
    
    CGFloat lineCenterX = scaleGap;
    CGFloat shortLineY = rect.size.height - shortScaleHeight;
    CGFloat middleLineY = rect.size.height - middleScaleHeight;
    CGFloat longLineY = rect.size.height - longScaleHeight;
    CGFloat bottomY = rect.size.height;
    
    NSInteger step = (self.maxValue - self.minValue)/10;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetLineCap(context, kCGLineCapButt);
    for (NSInteger i = 0; i<=10; i++)
    {
        if (i%10 == 0)
        {
            // 起使点
            CGContextMoveToPoint(context,startX + lineCenterX*i, longLineY);
            NSString *numStr = [NSString stringWithFormat:@"%ld", i*step+self.minValue];
            if (self.valueFormat)
            {
                numStr = self.valueFormat(i*step+self.minValue);
            }

            NSDictionary *attribute = @{NSFontAttributeName:scaleTitleFont,NSForegroundColorAttributeName:[UIColor colorWithWhite:0.7 alpha:1]};
            CGFloat width = [numStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
            [numStr drawInRect:CGRectMake(startX+lineCenterX*i-width*0.5f, 0, width, scaleTitleHeight) withAttributes:attribute];
        }
        else if (i%5 == 0)
        {
            // 起使点
            CGContextMoveToPoint(context, startX+lineCenterX*i, middleLineY);
        }
        else
        {
            // 起使点
            CGContextMoveToPoint(context, startX+lineCenterX*i, shortLineY);
        }
        CGContextAddLineToPoint(context, startX+lineCenterX*i, bottomY);
        CGContextStrokePath(context);
    }
    
    if (self.selectMinValue >= self.minValue && self.selectMinValue <= self.maxValue)
    {
        CGContextSetStrokeColorWithColor(context, minLineColor.CGColor);
        CGContextMoveToPoint(context, startX+(self.selectMinValue-self.minValue)/step*scaleGap, longLineY);
        CGContextAddLineToPoint(context, startX+(self.selectMinValue-self.minValue)/step*scaleGap, bottomY);
        CGContextStrokePath(context);
    }

    if (self.selectMaxValue >= self.minValue && self.selectMaxValue <= self.maxValue)
    {
        CGContextSetStrokeColorWithColor(context, maxLineColor.CGColor);
        CGContextMoveToPoint(context, startX+(self.selectMaxValue-self.minValue)/step*scaleGap, longLineY);
        CGContextAddLineToPoint(context, startX+(self.selectMaxValue-self.minValue)/step*scaleGap, bottomY);
        CGContextStrokePath(context);
    }
}

@end


#pragma mark -
#pragma mark DJScaleLastView

@interface DJScaleLastView : UIView

@property (nonatomic, assign) NSInteger maxValue;
@property (nullable, nonatomic, copy) scaleSliderFormatValueHandler valueFormat;

@property (nonatomic, assign) NSInteger selectMinValue;
@property (nonatomic, assign) NSInteger selectMaxValue;

@end

@implementation DJScaleLastView

-(void)drawRect:(CGRect)rect
{
    CGFloat longLineY = rect.size.height - longScaleHeight;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    // 起使点
    CGContextMoveToPoint(context, 0, longLineY);
    NSString *numStr = [NSString stringWithFormat:@"%ld", self.maxValue];
    if (self.valueFormat)
    {
        numStr = self.valueFormat(self.maxValue);
    }

    NSDictionary *attribute = @{NSFontAttributeName:scaleTitleFont, NSForegroundColorAttributeName:[UIColor colorWithWhite:0.7 alpha:1]};
    CGFloat width = [numStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [numStr drawInRect:CGRectMake(-width*0.5f, 0, width, scaleTitleHeight) withAttributes:attribute];
    CGContextAddLineToPoint(context, 0, rect.size.height);
    CGContextStrokePath(context);

    if (self.selectMinValue == self.maxValue)
    {
        // 起使点
        CGContextSetStrokeColorWithColor(context, minLineColor.CGColor);
        CGContextMoveToPoint(context, 0, longLineY);
        CGContextAddLineToPoint(context, 0, rect.size.height);
        CGContextStrokePath(context);
    }
    
    if (self.selectMaxValue == self.maxValue)
    {
        // 起使点
        CGContextSetStrokeColorWithColor(context, maxLineColor.CGColor);
        CGContextMoveToPoint(context, 0, longLineY);
        CGContextAddLineToPoint(context, 0, rect.size.height);
        CGContextStrokePath(context);
    }
}

@end


#pragma mark -
#pragma mark DJScaleSlider

@interface DJScaleSlider ()
<
    UIScrollViewDelegate,
    UITextFieldDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>
{
    // 刻度文本最大宽度
    CGFloat scaleTitleWidth;

    CGFloat collectionViewHeight;

    NSUInteger stepCount;
}

@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSUInteger step;

@property (nonatomic, strong) UITextField *valueTextField;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *redLine;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) NSInteger value;

@property (nonatomic, assign) BOOL scrollByHand;

@end


@implementation DJScaleSlider

- (instancetype)initWithFrame:(CGRect)frame minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue step:(NSUInteger)step
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.minValue = minValue;
        self.maxValue = maxValue;
        
        self.selectMinValue = minValue;
        self.selectMaxValue = maxValue;
        
        self.step = step;
        
        stepCount = ceil(fabs((CGFloat)(maxValue-minValue)/(CGFloat)step)/10.0f);
        
        self.scrollByHand = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        collectionViewHeight = scaleTitleHeight+scaleTitleGap+longScaleHeight;

        [self setupTextField];
        [self setupCollectionView];
        
        CGFloat height = valueTextFieldHeight+valueTextFieldGap+collectionViewHeight;
        frame.size.height = height;
        self.frame = frame;
        
        [self setupRedline];
        [self setBottomLine];
    }
    
    return self;
}

- (void)setupTextField
{
    UITextField *valueTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, valueTextFieldHeight)];
    valueTextField.defaultTextAttributes = @{NSUnderlineColorAttributeName:valueTextLineColor,
                                             NSUnderlineStyleAttributeName:@(1),
                                             NSFontAttributeName:valueTextFieldFont,
                                             NSForegroundColorAttributeName:valueTextColor};
    
    valueTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"滑动标尺或输入"
                                                                           attributes:@{NSUnderlineColorAttributeName:[UIColor grayColor],
                                                                                        NSUnderlineStyleAttributeName:@(1),
                                                                                        NSFontAttributeName:valueTextFieldFont,
                                                                                        NSForegroundColorAttributeName:[UIColor grayColor]}];
    valueTextField.textAlignment = NSTextAlignmentCenter;
    valueTextField.delegate = self;
    valueTextField.keyboardType = UIKeyboardTypeNumberPad;

    [self addSubview:valueTextField];
    self.valueTextField = valueTextField;
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.valueTextField.frame)+valueTextFieldGap, self.bounds.size.width, collectionViewHeight);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"firstCell"];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"middleCell"];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"lastCell"];

    collectionView.bounces = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)setupRedline
{
    UIView *redLine = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.5f-0.5f, self.frame.size.height-redLineHeight, 1.0f, redLineHeight)];
    self.redLine = redLine;
    self.redLine.backgroundColor = redLineColor;
    [self addSubview:self.redLine];

}

- (void)setBottomLine
{
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-(1.0f / [UIScreen mainScreen].scale), self.bounds.size.width, 1.0f / [UIScreen mainScreen].scale)];
    self.bottomLine = bottomLine;
    bottomLine.backgroundColor = [UIColor grayColor];
    [self addSubview:bottomLine];
}

- (void)setSelectMaxValue:(NSInteger)selectMaxValue
{
    if (selectMaxValue>self.maxValue)
    {
        selectMaxValue = self.maxValue;
    }
    
    _selectMaxValue = selectMaxValue;
}

- (void)setSelectMinValue:(NSInteger)selectMinValue
{
    if (selectMinValue<self.minValue)
    {
        selectMinValue = self.minValue;
    }
    
    _selectMinValue = selectMinValue;
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"shouldChangeCharactersInRange");
    
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newStr integerValue] > self.maxValue)
    {
        self.valueTextField.text = [NSString stringWithFormat:@"%ld", self.maxValue];
        [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:0];
        
        return NO;
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:waitingUserInput];

        self.scrollByHand = NO;

        return YES;
    }
}

-(void)didChangeValue
{
    NSInteger value = [self.valueTextField.text integerValue];
    
    if (value > self.selectMaxValue)
    {
        value = self.selectMaxValue;
    }
    else if (value < self.selectMinValue)
    {
        value = self.selectMinValue;
    }

    [self setRealValue:value animated:YES];
}

#pragma mark - UICollectionView

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2 + stepCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstCell" forIndexPath:indexPath];
        
        DJScaleFirstView *firstView = [cell.contentView viewWithTag:collectionViewTag];
        if (!firstView)
        {
            firstView = [[DJScaleFirstView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.5f, collectionViewHeight)];
            firstView.tag = collectionViewTag;
            firstView.backgroundColor = [UIColor clearColor];
            firstView.minValue = self.minValue;
            firstView.valueFormat = self.valueFormat;
            firstView.selectMinValue = self.selectMinValue;
            firstView.selectMaxValue = self.selectMaxValue;

            [cell.contentView addSubview:firstView];
        }
        
        return cell;
    }
    else if (indexPath.item == stepCount+1)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lastCell" forIndexPath:indexPath];
        
        DJScaleLastView *lastView = [cell.contentView viewWithTag:collectionViewTag];
        if (!lastView)
        {
            lastView = [[DJScaleLastView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.5f, collectionViewHeight)];
            lastView.tag = collectionViewTag;
            lastView.backgroundColor = [UIColor clearColor];
            lastView.maxValue = self.maxValue;
            lastView.valueFormat = self.valueFormat;
            lastView.selectMinValue = self.selectMinValue;
            lastView.selectMaxValue = self.selectMaxValue;
            
            [cell.contentView addSubview:lastView];
        }
        
        return cell;
    }
    else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"middleCell" forIndexPath:indexPath];
        DJScaleMiddleView *middleView = [cell.contentView viewWithTag:collectionViewTag];
        if (!middleView)
        {
            middleView = [[DJScaleMiddleView alloc] initWithFrame:CGRectMake(0, 0, scaleGap*10.0f, collectionViewHeight)];
            middleView.tag = collectionViewTag;
            middleView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:middleView];
        }
        
        middleView.minValue = self.minValue+self.step*10.f*(indexPath.item-1);
        middleView.maxValue = self.minValue+self.step*10.f*indexPath.item;
        middleView.valueFormat = self.valueFormat;
        middleView.selectMinValue = self.selectMinValue;
        middleView.selectMaxValue = self.selectMaxValue;

        [middleView setNeedsDisplay];
        
        return cell;
    }
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0 || indexPath.item == stepCount+1)
    {
        return CGSizeMake(self.frame.size.width*0.5f, collectionViewHeight);
    }
    else
    {
        return CGSizeMake(scaleGap*10.0f, collectionViewHeight);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollByHand)
    {
        NSInteger value = scrollView.contentOffset.x/(scaleGap);
        self.valueTextField.text = [NSString stringWithFormat:@"%ld", self.minValue+value*self.step];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollByHand = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");

    // 拖拽时没有滑动动画
    if (!decelerate)
    {
        [self scrollToValue:self.minValue+round(scrollView.contentOffset.x/(scaleGap))*self.step Animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    
    [self scrollToValue:self.minValue+round(scrollView.contentOffset.x/(scaleGap))*self.step Animated:YES];
}

- (void)scrollToValue:(NSInteger)value Animated:(BOOL)animated
{
    if (value > self.selectMaxValue)
    {
        value = self.selectMaxValue;
    }
    else if (value < self.selectMinValue)
    {
        value = self.selectMinValue;
    }
    
    [self setRealValue:value animated:animated];
}

- (void)setRealValue:(NSInteger)realValue animated:(BOOL)animated
{
    NSLog(@"%@", @(realValue));
    
    self.realValue = realValue;
    self.valueTextField.text = [NSString stringWithFormat:@"%ld", self.realValue];
    
    CGPoint point = CGPointMake((realValue-self.minValue)/self.step*scaleGap, 0);
    [self.collectionView setContentOffset:point animated:animated];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scaleSlider:valueChanged:)])
    {
        [self.delegate scaleSlider:self valueChanged:realValue];
    }
}

@end
