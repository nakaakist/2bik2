//
//  ClearViewController.h
//  2bik2
//
//  Created by nariyuki on 5/30/14.
//  Copyright (c) 2014 Nariyuki Saito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "parameters.h"


@interface ClearViewController : UIViewController{
    int _clearTime;              //clear time of the current game
    int _num;                    //number of pieces on each side of the frame
    int _rank[RANKN];            //highscores
    int _currentRank;            //rank of the current game
    UILabel* _rankLabel[RANKN];  //labels displaying highscores
    CGRect _rankView;            //size and position of the ranking view
}

@property int _clearTime;
@property int _num;

@end
