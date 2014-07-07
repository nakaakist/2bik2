//
//  RankViewController.h
//  2bik2
//
//  Created by nariyuki on 6/4/14.
//  Copyright (c) 2014 Nariyuki Saito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "parameters.h"

@interface RankViewController : UIViewController<UIAlertViewDelegate>{
    int _num;
    int _rank[RANKN];
    CGRect _rankView;
    CGRect _windowView;
    UILabel* _rankLabel[RANKN];
    UIView *_SubViewC,*_SubViewL,*_SubViewR;
}

@end
