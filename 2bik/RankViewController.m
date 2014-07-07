//
//  RankViewController.m
//  2bik2
//
//  Created by nariyuki on 6/4/14.
//  Copyright (c) 2014 Nariyuki Saito. All rights reserved.
//

#import "ViewControllers.h"

@interface RankViewController ()

@end

@implementation RankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _num=3;
    _windowView=[[UIScreen mainScreen]bounds];
    int w=300; //width of the window
    int h=300; //height of the window
    int left=(_windowView.size.width-w)/2;
    int top =(_windowView.size.height-h)/2;
    _rankView=CGRectMake(left, top, w, h);
    
    
    [self loadRanking];
    _SubViewC=[[UIView alloc]initWithFrame:_windowView];
    _SubViewL=[[UIView alloc]initWithFrame:CGRectOffset(_windowView, -_windowView.size.width, 0)];
    _SubViewR=[[UIView alloc]initWithFrame:CGRectOffset(_windowView, _windowView.size.width, 0)];
    [self displaySize:_SubViewC];
    [self displayRanking:_SubViewC];
    [self.view addSubview:_SubViewC];
    [self.view addSubview:_SubViewL];
    [self.view addSubview:_SubViewR];
    [self displayReset];
    [self displayOk];
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
    [_SubViewC removeFromSuperview];
    [_SubViewR removeFromSuperview];
    
    _SubViewC=[[UIView alloc]init];
    [_SubViewC setFrame:_windowView];
    [self.view addSubview:_SubViewC];
    
    _SubViewR=[[UIView alloc]init];
    [_SubViewR setFrame:CGRectOffset(_windowView, _windowView.size.width, 0)];
    [self.view addSubview:_SubViewR];
    [self.view sendSubviewToBack:_SubViewR];
    
    if( _num< PIECEN ){
        _num++;
    }else{
        _num=2;
    }
    [self loadRanking];
    [self displaySize:_SubViewR];
    [self displayRanking:_SubViewR];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [_SubViewR setFrame:_windowView];
    [_SubViewC setFrame:CGRectOffset(_windowView,-_windowView.size.width, 0)];
    [UIView commitAnimations];
}

-(IBAction)swipeRight:(id)sender{
    [_SubViewC removeFromSuperview];
    [_SubViewR removeFromSuperview];
    
    _SubViewC=[[UIView alloc]init];
    [_SubViewC setFrame:_windowView];
    [self.view addSubview:_SubViewC];
    
    _SubViewR=[[UIView alloc]init];
    [_SubViewR setFrame:CGRectOffset(_windowView, -_windowView.size.width, 0)];
    [self.view addSubview:_SubViewR];
    [self.view sendSubviewToBack:_SubViewR];
    
    if( _num>2 ){
        _num--;
    }else{
        _num=PIECEN;
    }
    [self loadRanking];
    [self displaySize:_SubViewR];
    [self displayRanking:_SubViewR];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [_SubViewR setFrame:_windowView];
    [_SubViewC setFrame:CGRectOffset(_windowView,_windowView.size.width, 0)];
    [UIView commitAnimations];
}



-(void)loadRanking{
    NSString* path;
    NSData* data;
    for(int i=0; i<RANKN; i++){
        path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        path=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"rank%d",_num]];
        path=[path stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        data = [NSData dataWithContentsOfFile:path];
        if( data==nil ){
            _rank[i]=INT_MAX;
        }else{
            [data getBytes:&_rank[i] length:sizeof(_rank[i])];
            data=nil;
        }
    }
}

-(void)resetRanking{
    for(int i=0; i<RANKN; i++){
        _rank[i]=INT_MAX;
    }
}

-(void)saveRanking{
    NSString* path;
    NSData* data;
    for(int i=0; i<RANKN; i++){
        path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        path=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"rank%d",_num]];
        path=[path stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        data = [NSData dataWithBytes:&_rank[i] length:sizeof(_rank[i])];
        [data writeToFile:path atomically:YES];
    }
}

-(void)displayRanking:(UIView*)view{
    
    //display of the ranking
    
    int w=300; //width of the window
    int h=230; //height of the window
    int left=(_windowView.size.width-w)/2;
    int top =(_windowView.size.height-h)/2+20;

    int hh,mm,ss;
    
    for(int i=0; i<RANKN; i++){
        _rankLabel[i]=[[UILabel alloc]init];
        _rankLabel[i].font=[UIFont systemFontOfSize:30.0f];
        _rankLabel[i].adjustsFontSizeToFitWidth=YES;
        _rankLabel[i].textAlignment=NSTextAlignmentCenter;
        _rankLabel[i].frame=CGRectMake(left, top+i*h/RANKN,w,h/RANKN);
        if(_rank[i]<INT_MAX){
            hh = _rank[i]/3600;
            mm = (_rank[i]/60)%60;
            ss = _rank[i]%60;
            _rankLabel[i].text=[NSString stringWithFormat:@"%d   %01d:%02d:%02d",i+1,hh,mm,ss];
        }else{
            _rankLabel[i].text=[NSString stringWithFormat:@"%d   --:--:--",i+1];
        }
        [view addSubview:_rankLabel[i]];
    }
    
}

-(void)displaySize:(UIView*)view{
    UILabel* size=[[UILabel alloc]init];
    size.font=[UIFont systemFontOfSize:35.0f];
    size.adjustsFontSizeToFitWidth=YES;
    [size setTextAlignment:NSTextAlignmentCenter];
    size.text=[NSString stringWithFormat:@"%01d×%01d",_num,_num];
    size.frame=CGRectMake(_rankView.origin.x+_rankView.size.width/2-75,_rankView.origin.y, 150, 50);
    [view addSubview:size];
}

-(void)displayReset{
    UIButton* reset=[UIButton buttonWithType: UIButtonTypeRoundedRect];
    [reset addTarget:self action:@selector(clickReset:) forControlEvents:UIControlEventTouchUpInside];
    [reset setFrame:CGRectMake(_rankView.origin.x,_rankView.origin.y+_rankView.size.height,100,50)];
    [reset setTitle:@"リセット" forState:UIControlStateNormal];
    [reset.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [reset.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [reset setTag:1];
    [self.view addSubview:reset];
}

-(void)displayTitle{
    UILabel* title=[[UILabel alloc]init];
    [title setFrame:CGRectMake(_rankView.origin.x+_rankView.size.width/2-100
                               ,_rankView.origin.y-100,200,100)];
    [title setText:@"ハイスコア"];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont systemFontOfSize:50.f]];
    [title setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:title];

}


-(IBAction)clickReset:(id)sender{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil
                                                 message:@"ハイスコアをリセットしますか？"
                                                delegate:self
                                       cancelButtonTitle:@"いいえ"
                                       otherButtonTitles:@"はい", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if( buttonIndex==1 ){
        [self resetRanking];
        [self saveRanking];
        [self loadRanking];
    
        [_SubViewR removeFromSuperview];
        _SubViewR=[[UIView alloc]init];
        [_SubViewR setFrame:_windowView];
        [self displaySize:_SubViewR];
        [self displayRanking:_SubViewR];
        [self.view addSubview:_SubViewR];
        [self.view sendSubviewToBack:_SubViewR];
    }
}

-(void)displayOk{
    UIButton* ok=[UIButton buttonWithType: UIButtonTypeRoundedRect];
    [ok addTarget:self action:@selector(clickOk:) forControlEvents:UIControlEventTouchUpInside];
    [ok setFrame:CGRectMake(_rankView.origin.x+_rankView.size.width-100,_rankView.origin.y+_rankView.size.height,100,50)];
    [ok setTitle:@"戻る" forState:UIControlStateNormal];
    [ok.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [ok.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [ok setTag:0];
    [self.view addSubview:ok];
}

-(IBAction)clickOk:(id)sender{
    MenuViewController* next = [[MenuViewController alloc] init];
    next.modalTransitionStyle=TRANSSTYLE;
    [self presentViewController:next animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



