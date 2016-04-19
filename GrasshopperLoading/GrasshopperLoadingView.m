//
//  GrasshopperLoadingView.m
//  GrasshopperLoading
//
//  Created by Realank on 16/4/18.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "GrasshopperLoadingView.h"
#import <math.h>
#define LINE_WIDTH 6

@interface GrasshopperLoadingView ()

@property (nonatomic, weak) CADisplayLink *link;
@property (nonatomic, assign) NSInteger count;

@end

@implementation GrasshopperLoadingView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    self.backgroundColor=[UIColor clearColor];
    _count = 0;
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(clockTick)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    _link = link;
    
    return self;
}

- (void)dealloc {
    [self deleteTimer];
    NSLog(@"dealloc");
}

- (void)deleteTimer{
    if (_link) {
        [_link invalidate];
        _link = nil;
    }
    
}


- (void)clockTick{
    if (self.superview) {
        _count += 15;
        if (_count > 1000) {
            _count = 0;
        }
        [self setNeedsDisplay];
    }else{
        [self deleteTimer];
    }
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    
    UIGraphicsGetCurrentContext();
    
    CGFloat percent = _count / 1000.0;
    CGFloat r = MAX(rect.size.width, rect.size.height) / 2 - 10;;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height - 5);
    center.x = center.x - 2 * r * (percent - 0.5);
    NSArray* pathArr = [self pathesForLoadingCenter:center andR:r andPercent:percent];
    if (pathArr.count == 3) {
        [[self colorWithR:251 G:205 B:137] setStroke];
        [pathArr[0] stroke];
        [[self colorWithR:237 G:105 B:65] setStroke];
        [pathArr[1] stroke];
        [[self colorWithR:230 G:0 B:18] setStroke];
        [pathArr[2] stroke];
    }

}

- (UIColor*)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

- (NSArray*)pathesForLoadingCenter:(CGPoint)center andR:(CGFloat)r andPercent:(CGFloat)percent{
    
    CGFloat startAngle = 0;
    CGFloat endAngle = 0;
    if (percent < 0.01) {
        percent = 0.01;
    }else if(fabs(percent- 0.5) < 0.01){
        percent = 0.5;
    }else if(percent > 0.99){
        percent = 0.99;
    }
    
    if (percent <= 0.5) {
        startAngle = -M_PI;
//        CGFloat x = 2 * r * percent * 2;
//        endAngle = startAngle + [self angleForDeltaX:(x - r) andR:r];
        endAngle = startAngle + M_PI * percent * 2;
        
    }else {
        endAngle = 0;
//        CGFloat x = 2 * r * (percent- 0.5) * 2;
//        startAngle = -M_PI + [self angleForDeltaX:(x - r) andR:r];
        startAngle = -M_PI + M_PI * (percent-0.5) * 2;
    }
    
    CGFloat segmentAngle = (endAngle - startAngle) / 3;
    
    NSMutableArray* pathArr = [NSMutableArray array];
    [pathArr addObject:[self arcPathAtCenter:center andR:r startAngle:startAngle endAngle:startAngle + segmentAngle withColor:[UIColor redColor]]];
    [pathArr addObject:[self arcPathAtCenter:center andR:r startAngle:startAngle + segmentAngle endAngle:startAngle + 2 * segmentAngle withColor:[UIColor redColor]]];
    [pathArr addObject:[self arcPathAtCenter:center andR:r startAngle:startAngle + 2 * segmentAngle endAngle:startAngle + 3 * segmentAngle withColor:[UIColor redColor]]];
    
    return [pathArr copy];
}

- (CGFloat)angleForDeltaX:(CGFloat)deltaX andR:(CGFloat)r{
    
    if (deltaX < -r || deltaX > r) {
        NSLog(@"错误");
        return 0;
    }
    if (deltaX < 0) {
        deltaX = - deltaX;
        return acos(deltaX / r);
    }else if (deltaX == 0) {
        return M_PI_2;
    }else{
        return M_PI - acos(deltaX / r);
    }
    
    return 0;
}

-(UIBezierPath*)arcPathAtCenter:(CGPoint)center andR:(CGFloat)r startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle  withColor:(UIColor*)color{
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center radius:r startAngle:startAngle endAngle:endAngle clockwise:YES];
    aPath.lineWidth = LINE_WIDTH;
    aPath.lineJoinStyle = kCGLineJoinRound;
    aPath.lineCapStyle = kCGLineCapRound;
    return aPath;
}


@end
