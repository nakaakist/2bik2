//
//  SelectViewController.h
//  2bik2
//
//  Created by nariyuki on 6/5/14.
//  Copyright (c) 2014 Nariyuki Saito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "parameters.h"

@interface SelectViewController : UIViewController{
    UIImage* _image[PIECEN];    //image of each piece
    UIView*  _views[PIECEN+1];  //sample of the game view
    CGRect   _gameWindow;       //size of the sample window
    CGRect   _fullWindow;       //size of the full window
    int      _num;              //number of the pieces on one side
}

@end
