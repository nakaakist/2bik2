//
//  MainViewController.h
//  2bik2
//
//  Created by nariyuki on 6/3/14.
//  Copyright (c) 2014 Nariyuki Saito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "parameters.h"


@interface MainViewController : UIViewController<UIAlertViewDelegate>{
    int _num;                     //number of pieces on one side of square
    UIImage* _image[PIECEN];           //image of pieces
    UIImageView* _piece[PIECEN][PIECEN];    //imageview of pieces
    int _data[PIECEN][PIECEN];              //data of pieces
    CGPoint _tBegan, _tEnded;     //position of fingers
    CGRect _gameWindow;           //position and size of the game window
    int kaisuu;                   //counting variable for timer
    NSDate* _start;               //the time of the start
    int _time;                    //passed time from the start
    UILabel* time;                //label of the time
    BOOL _clearFlag;              //cleared: YES, not cleared: NO
    BOOL _shuffleFlag;            //shuffling: YES, not shuffling: NO
    BOOL _resume;                 //saved game: YES, new game: NO
    UILabel* _ready;
}

@property int _num;
@property BOOL _resume;

@end