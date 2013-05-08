//
//  ImageView.h
//  ScrollViewDome
//
//  Created by zhangqingfeng on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageView : UIImageView{
    
    NSUInteger index;

}
@property ( assign) NSUInteger index; 


- (id)initView:(UIImage *)image;

@end