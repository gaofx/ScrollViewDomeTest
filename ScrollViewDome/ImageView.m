//
//  ImageView.m
//  ScrollViewDome
//
//  Created by zhangqingfeng on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView
@synthesize index;

- (id)initView:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image=image;
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
}

@end
