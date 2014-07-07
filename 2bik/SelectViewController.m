//
//  SelectViewController.m
//  2bik2
//
//  Created by nariyuki on 6/5/14.
//  Copyright (c) 2014 Nariyuki Saito. All rights reserved.
//

#import "ViewControllers.h"


@interface SelectViewController ()

@end

@implementation SelectViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWindowSize];
    [self makeSampleViews];
    [self displayOk];
    [self displayNg];
    [self displayTitle];
    
    UISwipeGestureRecognizer* swipeLeftGesture =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
    UISwipeGestureRecognizer* swipeRightGesture =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
}

-(IBAction)swipeLeft:(id)sender{
    //swipe to left: increment of the number of pieces
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    for(int k=2; k<=PIECEN; k++){
        [_views[k] setFrame:CGRectOffset(_views[k].frame, -_fullWindow.size.width, 0)];
    }
    [UIView commitAnimations];
    if(_num==2){
        [_views[PIECEN] setFrame:CGRectOffset(_views[PIECEN].frame, _fullWindow.size.width*(PIECEN-1),0)];
    }else{
        [_views[_num-1] setFrame:CGRectOffset(_views[_num-1].frame, _fullWindow.size.width*(PIECEN-1),0)];
    }
    
    //renewal of _num
    if(_num==PIECEN)
        _num=2;
    else
        _num++;
}

-(IBAction)swipeRight:(id)sender{
    //swipe to right: decrement of the number of pieces
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    for(int k=2; k<=PIECEN; k++){
        [_views[k] setFrame:CGRectOffset(_views[k].frame, _fullWindow.size.width, 0)];
    }
    [UIView commitAnimations];
    if(_num==3){
        [_views[PIECEN] setFrame:CGRectOffset(_views[PIECEN].frame, -_fullWindow.size.width*(PIECEN-1),0)];
    }else if(_num==2){
        [_views[PIECEN-1] setFrame:CGRectOffset(_views[PIECEN-1].frame, -_fullWindow.size.width*(PIECEN-1),0)];
    }else{
        [_views[_num-2] setFrame:CGRectOffset(_views[_num-2].frame, -_fullWindow.size.width*(PIECEN-1),0)];
    }

    //renewal of _num
    if(_num==2)
        _num=PIECEN;
    else
        _num--;
}

-(void)initWindowSize{
    //initialization of the game window
    _fullWindow=[[UIScreen mainScreen] bounds];
    int w=290; //width of the window
    int h=290; //height of the window
    int left=(_fullWindow.size.width-w)/2;
    int top =(_fullWindow.size.height-h)/2;
    _gameWindow = CGRectMake(left, top, w, h);
}

-(void)makeSampleViews{
    _image[0] = [UIImage imageNamed:@"red.png"];
    _image[1] = [UIImage imageNamed:@"blue.png"];
    _image[2] = [UIImage imageNamed:@"yellow.png"];
    _image[3] = [UIImage imageNamed:@"green.png"];
    _image[4] = [UIImage imageNamed:@"purple.png"];
    _image[5] = [UIImage imageNamed:@"orange.png"];

    int pw,ph;
    int i,j,k;
    UIImageView* piece[PIECEN+1][PIECEN][PIECEN];
    UILabel* size[PIECEN+1];
    
    _num = 3;
    
    for(k=2; k<=PIECEN; k++){
        _views[k]=[[UIView alloc]init];
        [_views[k] setFrame:CGRectOffset(_fullWindow, (k-_num)*_fullWindow.size.width, 0)];
        pw = _gameWindow.size.width/k;
        ph = _gameWindow.size.height/k;
        for(i=0; i<k; i++){
            for(j=0; j<k; j++){
                piece[k][i][j]=[[UIImageView alloc] init];
                piece[k][i][j].frame = CGRectMake(_gameWindow.origin.x+pw*i,
                                         _gameWindow.origin.y+ph*j,
                                         pw,ph);
                piece[k][i][j].image = _image[i];
                [_views[k] addSubview:piece[k][i][j]];
            }
        }
        size[k]=[[UILabel alloc]initWithFrame:CGRectMake(_gameWindow.origin.x+_gameWindow.size.width/2-100,
                                                               _gameWindow.origin.y+_gameWindow.size.height/2-50,
                                                               200, 100)];
        [size[k] setAdjustsFontSizeToFitWidth:YES];
        [size[k] setFont:[UIFont systemFontOfSize:50.f]];
        [size[k] setTextAlignment:NSTextAlignmentCenter];
        [size[k] setText:[NSString stringWithFormat:@"%01d×%01d",k,k]];
        [_views[k] addSubview:size[k]];
        [self.view addSubview:_views[k]];
        [self.view sendSubviewToBack:_views[k]];
    }
}

-(void)displayOk{
    UIButton* ok=[UIButton buttonWithType: UIButtonTypeRoundedRect];
    [ok addTarget:self action:@selector(clickOk:) forControlEvents:UIControlEventTouchUpInside];
    [ok setFrame:CGRectMake(_gameWindow.origin.x,_gameWindow.origin.y+_gameWindow.size.height+20,100,50)];
    [ok setTitle:@"スタート" forState:UIControlStateNormal];
    [ok.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [ok.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [ok setTag:0];
    [self.view addSubview:ok];
}

-(IBAction)clickOk:(id)sender{
    MainViewController* next = [[MainViewController alloc] init];
    next.modalTransitionStyle=TRANSSTYLE;
    [next set_num:_num];
    [next set_resume:NO];
    [self presentViewController:next animated:YES completion:nil];
}

-(void)displayNg{
    UIButton* ng=[UIButton buttonWithType: UIButtonTypeRoundedRect];
    [ng addTarget:self action:@selector(clickNg:) forControlEvents:UIControlEventTouchUpInside];
    [ng setFrame:CGRectMake(_gameWindow.origin.x+_gameWindow.size.width-100,_gameWindow.origin.y+_gameWindow.size.height+20,100,50)];
    [ng setTitle:@"戻る" forState:UIControlStateNormal];
    [ng.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [ng.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [ng setTag:1];
    [self.view addSubview:ng];
}

-(IBAction)clickNg:(id)sender{
    MenuViewController* next = [[MenuViewController alloc] init];
    next.modalTransitionStyle=TRANSSTYLE;
    [self presentViewController:next animated:YES completion:nil];
}

-(void)displayTitle{
    UILabel* title=[[UILabel alloc]init];
    [title setFrame:CGRectMake(_gameWindow.origin.x+_gameWindow.size.width/2-100
                               ,_gameWindow.origin.y-100,200,100)];
    [title setText:@"サイズ選択"];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont systemFontOfSize:50.f]];
    [title setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:title];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
