//
//  RootViewController.h
//  ScrollViewDome
//
//  Created by zhangqingfeng on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageView.h"


@interface RootViewController : UIViewController
<UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    
    UIPageControl *pageController;
}

@property (nonatomic, retain) NSArray *myArray;

- (void)tilePages;
- (ImageView *)dequeueRecycledPage;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (void)configurePage:(ImageView *)page forIndex:(NSUInteger)index;

@end
