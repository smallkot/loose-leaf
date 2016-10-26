//
//  MMSilhouetteView.m
//  LooseLeaf
//
//  Created by Adam Wulf on 1/12/15.
//  Copyright (c) 2015 Milestone Made, LLC. All rights reserved.
//

#import "MMShadowHandView.h"
#import "MMDrawingGestureShadow.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+Debug.h"
#import "MMTwoFingerPanShadow.h"
#import "MMTouchDotGestureRecognizer.h"
#import "NSThread+BlockAdditions.h"
#import "UITouch+Distance.h"
#import "MMVector.h"
#import "MMShadowHand.h"


@implementation MMShadowHandView {
    MMDrawingGestureShadow* pointerFingerHelper;
    //    UISlider* slider;
}

@synthesize rightHand = rightHand;
@synthesize leftHand = leftHand;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;

        leftHand = [[MMShadowHand alloc] initForRightHand:NO forView:self];
        rightHand = [[MMShadowHand alloc] initForRightHand:YES forView:self];


        //        slider = [[UISlider alloc] initWithFrame:CGRectMake(450, 50, 200, 40)];
        //        slider.value = 1;
        //        slider.minimumValue = 0;
        //        slider.maximumValue = 1;
        //        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        //
        //        [[NSThread mainThread] performBlock:^{
        //            [self.window addSubview:slider];
        //            [leftHand startPinchingObject:nil withTouches:nil];
        //        } afterDelay:.3];


        [self.layer addSublayer:leftHand.layer];
        [self.layer addSublayer:rightHand.layer];
    }
    return self;
}

//-(void) sliderValueChanged:(UISlider*)_slider{
//    [leftHand continuePinchingObject:nil withTouches:nil andDistance:_slider.value *400+40];
//}


#pragma mark - Panning a Page

- (void)startBezelingInFromRight:(BOOL)fromRight withTouches:(NSArray*)touches {
    [leftHand startBezelingInFromRight:fromRight withTouches:touches];
}

- (void)continueBezelingInFromRight:(BOOL)fromRight withTouches:(NSArray*)touches {
    [leftHand continueBezelingInFromRight:fromRight withTouches:touches];
}

- (void)endBezelingInFromRight:(BOOL)fromRight withTouches:(NSArray*)touches {
    [leftHand endBezelingInFromRight:fromRight withTouches:touches];
}


#pragma mark - Panning a Page

- (void)startPanningObject:(id)obj withTouches:(NSArray*)touches {
    if (!leftHand.isActive) {
        [leftHand startPanningObject:obj withTouches:touches];
        //        [leftHand startPinchingObject:obj withTouches:touches];
    } else {
        [rightHand startPanningObject:obj withTouches:touches];
        //        [rightHand startPinchingObject:obj withTouches:touches];
    }
}

- (void)continuePanningObject:(id)obj withTouches:(NSArray*)touches {
    //    if([touches count] == 4){
    //        touches = [touches sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    //            return [obj1 locationInView:self].x > [obj2 locationInView:self].x;
    //        }];
    //        [leftHand continuePanningObject:obj withTouches:[touches subarrayWithRange:NSMakeRange(0, 2)]];
    //        [rightHand continuePanningObject:obj withTouches:[touches subarrayWithRange:NSMakeRange(2, 2)]];
    //    }else{

    if (leftHand.heldObject == obj) {
        [leftHand continuePanningObject:obj withTouches:touches];
        //            [leftHand continuePinchingObject:obj withTouches:touches];
    } else if (rightHand.heldObject == obj) {
        [rightHand continuePanningObject:obj withTouches:touches];
        //            [rightHand continuePinchingObject:obj withTouches:touches];
    }
    //    }
}

- (void)endPanningObject:(id)obj {
    if (leftHand.heldObject == obj) {
        NSLog(@"ending left pan");
        //        [leftHand endPinchingObject:obj];
        [leftHand endPanningObject:obj];
    }
    if (rightHand.heldObject == obj) {
        NSLog(@"ending right pan");
        //        [rightHand endPinchingObject:obj];
        [rightHand endPanningObject:obj];
    }
}

#pragma mark - Drawing Events

- (void)startDrawingAtTouch:(UITouch*)touch immediately:(BOOL)immediately {
    if (!rightHand.isActive) {
        [rightHand startDrawingAtTouch:touch immediately:immediately];
    } else {
        [leftHand startDrawingAtTouch:touch immediately:immediately];
    }
}
- (void)continueDrawingAtTouch:(UITouch*)touch {
    if (rightHand.isActive) {
        [rightHand continueDrawingAtTouch:touch];
    } else {
        [leftHand continueDrawingAtTouch:touch];
    }
}
- (void)endDrawingAtTouch:(UITouch*)touch {
    if (rightHand.isDrawing) {
        [rightHand endDrawingAtTouch:touch];
    }
    if (leftHand.isDrawing) {
        [leftHand endDrawingAtTouch:touch];
    }
}


#pragma mark - Ignore Touches

/**
 * these two methods make sure that touches on this
 * UIView always passthrough to any views underneath it
 */
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    return nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    return NO;
}


#pragma mark - CALayer Helper

- (void)preventCALayerImplicitAnimation:(void (^)(void))block {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    block();
    [CATransaction commit];
}


@end
