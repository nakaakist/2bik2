//
//  MenuViewController.h
//  2bik2
//
//  Created by nariyuki on 6/3/14.
//  Copyright (c) 2014 Nariyuki Saito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "parameters.h"


@interface MenuViewController : UIViewController<UIAlertViewDelegate>{
    CGRect _menuView;
    CGPoint _screenCenter;
    CGFloat _menuIconSize;
}

@end
