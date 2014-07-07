//
//  MenuViewController.m
//  2bik2
//
//  Created by nariyuki on 6/3/14.
//  Copyright (c) 2014 Nariyuki Saito. All rights reserved.
//

#import "ViewControllers.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMenuSize];
    [self displayTitle];
    [self displayPlay];
    [self displayRank];
    [self displayTutorial];
    
}

-(void)initMenuSize{
    CGSize screenSize=[[UIScreen mainScreen] bounds].size;
    int w=300; //width of the window
    int h=200; //height of the window
    int left=(screenSize.width-w)/2;
    int top =(screenSize.height-h)/2+100;
    _menuView=CGRectMake(left, top, w, h);
    _screenCenter=CGPointMake(left+w/2, top+h/2);
    _menuIconSize=_menuView.size.height/MENUN-50;
}

-(void)displayTitle{
    /*UIImageView* title=[[UIImageView alloc]init];
    title.image = [UIImage imageNamed:@"reset.png"];*/
    UILabel* title=[[UILabel alloc]init];
    [title setText:@"2bik Cube"];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont systemFontOfSize:50.f]];
    [title setAdjustsFontSizeToFitWidth:YES];
    title.frame=CGRectMake(_screenCenter.x-100, _menuView.origin.y-170, 200, 100);
    [self.view addSubview:title];
}

-(void)displayPlay{
    /*UIButton* play=[UIButton buttonWithType: UIButtonTypeCustom];
    [play addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [play setFrame:CGRectMake(_menuView.origin.x,_menuView.origin.y,_menuIconSize,_menuIconSize)];
    [play setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    [play setTag:0];
    [self.view addSubview:play];*/
    UIButton* playl=[UIButton buttonWithType: UIButtonTypeRoundedRect];
    [playl addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [playl setFrame:CGRectMake(_menuView.origin.x+ _menuView.size.width/2-120,_menuView.origin.y,240,_menuIconSize)];
    [playl setTitle:@"新しいゲーム" forState:UIControlStateNormal];
    [playl.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [playl.titleLabel setAdjustsFontSizeToFitWidth:NO];
    [playl setTag:0];
    [self.view addSubview:playl];
}


-(IBAction)clickPlay:(id)sender{
    SelectViewController* next = [[SelectViewController alloc] init];
    next.modalTransitionStyle=TRANSSTYLE;
    [self presentViewController:next animated:YES completion:nil];
}

-(void)displayRank{

    UIButton* playl=[UIButton buttonWithType: UIButtonTypeRoundedRect];
    [playl addTarget:self action:@selector(clickRank:) forControlEvents:UIControlEventTouchUpInside];
    [playl setFrame:CGRectMake(_menuView.origin.x+ _menuView.size.width/2-120,_menuView.origin.y+2*_menuView.size.height/MENUN,240,_menuIconSize)];
    [playl setTitle:@"ハイスコア" forState:UIControlStateNormal];
    [playl.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [playl.titleLabel setAdjustsFontSizeToFitWidth:NO];
    [playl setTag:0];
    [self.view addSubview:playl];
}

-(IBAction)clickRank:(id)sender{
    RankViewController* next = [[RankViewController alloc] init];
    next.modalTransitionStyle=TRANSSTYLE;
    [self presentViewController:next animated:YES completion:nil];
}

-(void)displayTutorial{
    UIButton* playl=[UIButton buttonWithType: UIButtonTypeRoundedRect];
    [playl addTarget:self action:@selector(clickTutorial:) forControlEvents:UIControlEventTouchUpInside];
    [playl setFrame:CGRectMake(_menuView.origin.x+ _menuView.size.width/2-120,_menuView.origin.y+1*_menuView.size.height/MENUN,240,_menuIconSize)];
    [playl setTitle:@"ゲームの再開" forState:UIControlStateNormal];
    [playl.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [playl.titleLabel setAdjustsFontSizeToFitWidth:NO];
    [playl setTag:0];
    [self.view addSubview:playl];
}

-(IBAction)clickTutorial:(id)sender{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path=[path stringByAppendingPathComponent:@"data"];
    if([manager fileExistsAtPath:path]==YES){
        MainViewController* next = [[MainViewController alloc] init];
        next.modalTransitionStyle=TRANSSTYLE;
        [next set_resume:YES];
        [self presentViewController:next animated:YES completion:nil];
    }else{
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil
                                                     message:@"中断データがありません"
                                                    delegate:self
                                           cancelButtonTitle:@"はい"
                                           otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
