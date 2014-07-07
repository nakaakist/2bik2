//
//  ClearViewController.m
//  2bik2
//
//  Created by nariyuki on 5/30/14.
//  Copyright (c) 2014 Nariyuki Saito. All rights reserved.
//

#import "ViewControllers.h"

@interface ClearViewController ()

@end

@implementation ClearViewController

@synthesize _clearTime;
@synthesize _num;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadRanking];
    [self renewRanking];
    [self saveRanking];
    [self displayRanking];
    [self displayClearTime];
    [self displayOk];

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

-(void)renewRanking{
    int i,j;
    _currentRank=-1;
    for(i=0; i<RANKN; i++){
        if( _clearTime<=_rank[i]){
            _currentRank=i;
            break;
        }
    }
    for(j=RANKN-1; j>i; j--){
        _rank[j]=_rank[j-1];
    }
    _rank[i]=_clearTime;
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

-(void)displayRanking{
    
    //display of the ranking
    
    CGSize screenSize=[[UIScreen mainScreen] bounds].size;
    int w=300; //width of the window
    int h=230; //height of the window
    int left=(screenSize.width-w)/2;
    int top =(screenSize.height-h)/2+30;
    _rankView=CGRectMake(left, top, w, h);
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
            _rankLabel[i].text=[NSString stringWithFormat:@"rank%d   %01d:%02d:%02d",i+1,hh,mm,ss];
        }else{
            _rankLabel[i].text=[NSString stringWithFormat:@"rank%d   --:--:--",i+1];
        }
        if( i==_currentRank ){
            _rankLabel[i].backgroundColor=[UIColor cyanColor];
        }
        [self.view addSubview:_rankLabel[i]];
    }
    
}

-(void)displayClearTime{
    int hh,mm,ss;
    hh = _clearTime/3600;
    mm = (_clearTime/60)%60;
    ss = _clearTime%60;

    UILabel* time=[[UILabel alloc]init];
    time.font=[UIFont systemFontOfSize:50.0f];
    time.adjustsFontSizeToFitWidth=YES;
    time.text=[NSString stringWithFormat:@"クリアタイム %01d:%02d:%02d",hh,mm,ss];
    time.frame=CGRectMake(_rankView.origin.x+_rankView.size.width/2-140, _rankView.origin.y-130, 280, 100);
    [self.view addSubview:time];
}

-(void)displayOk{
    UIButton* ok=[UIButton buttonWithType: UIButtonTypeRoundedRect];
    [ok addTarget:self action:@selector(c:) forControlEvents:UIControlEventTouchUpInside];
    [ok setFrame:CGRectMake(_rankView.origin.x+_rankView.size.width/2-50,_rankView.origin.y+_rankView.size.height+10,100,50)];
    [ok setTitle:@"OK" forState:UIControlStateNormal];
    [ok.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [ok.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [ok setTag:1];
    [self.view addSubview:ok];
}

-(IBAction)c:(id)sender{
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
