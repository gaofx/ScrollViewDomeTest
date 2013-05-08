//
//  RootViewController.m
//  ScrollViewDome
//
//  Created by zhangqingfeng on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

#define K_contentsOfFile(fileName) [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"]


@interface RootViewController ()

@end

@implementation RootViewController
@synthesize myArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *imageArray_=[[NSMutableArray alloc] init];

    for (int i=0; i<10; i++) {
        NSString *imageName_=[[NSString alloc] initWithFormat:@"%d",i];
        UIImage *image_=[[UIImage alloc] initWithContentsOfFile:K_contentsOfFile(imageName_)];
        [imageArray_ addObject:image_];
        
        [imageName_ release]; imageName_ =nil;
        [image_ release]; image_ =nil;
    }
    
    self.myArray=imageArray_;
    [imageArray_ release];
    
    
    
	myScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    myScrollView.bounces = YES;
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    myScrollView.userInteractionEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator=NO;
    myScrollView.showsVerticalScrollIndicator= NO;
    myScrollView.contentSize = CGSizeMake(myScrollView.frame.size.width * [self.myArray count],myScrollView.frame.size.height);
    [self.view addSubview:myScrollView];
    [myScrollView release];
    recycledPages=[[NSMutableSet alloc] init];
    visiblePages =[[NSMutableSet alloc] init];
    
    //显示有多少页的pageController
    pageController=[[UIPageControl alloc] initWithFrame:CGRectMake(0, 440, 320, 20)];
    [pageController setNumberOfPages:[self.myArray count]];
    [pageController setCurrentPage:0];
    [self.view addSubview:pageController];
    [pageController release];
    
    [self tilePages];


}

#pragma mark -
#pragma mark -scrollViewDelegate
//视图滑动时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     NSLog(@"----%f",myScrollView.contentOffset.x);
    [self tilePages];
    if (myScrollView.contentOffset.x>myScrollView.frame.size.width*([self.myArray count]-1)+100) {
        [myScrollView scrollRectToVisible:CGRectMake(myScrollView.frame.size.width*0,0,myScrollView.frame.size.width,myScrollView.frame.size.height) animated:NO];
        [pageController setCurrentPage:0];
    }

}
//我们移动手指开始
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}
//当滚动视图停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    int currentPage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) /  scrollView.frame.size.width) + 1;
    [pageController setCurrentPage:currentPage];
}
#pragma mark-
#pragma mark-scrollView重用机制-
- (void)tilePages 
{
    // Calculate which pages are visible
    CGRect visibleBounds =myScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self.myArray count] - 1);
    
    // Recycle no-longer-visible pages 
    for (ImageView *page in visiblePages) {
        NSLog(@"page.index=%d",page.index);
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ImageView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[ImageView alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [myScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }    
}

- (ImageView *)dequeueRecycledPage
{
    ImageView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (ImageView *page in visiblePages) {        
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(ImageView *)page forIndex:(NSUInteger)index
{
    page.index = index;  
    [page initView:[self.myArray objectAtIndex:index]];
    page.frame =CGRectMake( myScrollView.frame.size.width*index, 0, myScrollView.frame.size.width,myScrollView.frame.size.height);
} 


- (void)viewDidUnload
{
    [self setMyArray:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [myArray release];
    [super dealloc];
}
@end
