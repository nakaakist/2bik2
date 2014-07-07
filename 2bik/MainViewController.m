//
//  MainViewController.m
//  2bik2
//
//  Created by nariyuki on 6/3/14.
//  Copyright (c) 2014 Nariyuki Saito. All rights reserved.
//

#import "ViewControllers.h"

@interface MainViewController ()

@end


@implementation MainViewController

@synthesize _num,_resume;

- (void)viewDidLoad
{

    int i,j;
    
    [super viewDidLoad];
    
    [self initWindowSize];
    
    _image[0] = [UIImage imageNamed:@"red.png"];
    _image[1] = [UIImage imageNamed:@"blue.png"];
    _image[2] = [UIImage imageNamed:@"yellow.png"];
    _image[3] = [UIImage imageNamed:@"green.png"];
    _image[4] = [UIImage imageNamed:@"purple.png"];
    _image[5] = [UIImage imageNamed:@"orange.png"];
    
    _clearFlag = NO;
    _shuffleFlag = NO;

    //display of the background
    UIImageView* bg=[[UIImageView alloc]init];
    bg.image = [UIImage imageNamed:@"bg.png"];
    bg.frame = [[UIScreen mainScreen]bounds];
    [self.view addSubview:bg];
    
    //display of the frame
    UIImageView* fr=[[UIImageView alloc]init];
    fr.image = [UIImage imageNamed:@"frame.png"];
    fr.frame = CGRectMake(_gameWindow.origin.x-_gameWindow.size.width/59/2,
                          _gameWindow.origin.y-_gameWindow.size.height/59/2,
                          _gameWindow.size.width*6.0/5.90,
                          _gameWindow.size.height*6.0/5.90);
    [self.view addSubview:fr];
    
    if( _resume==YES ){
        [self loadData];
    }else{
        [self initData];
    }
    
    //display of the pieces
    for(i=0; i<_num;i++){
        for(j=0; j<_num; j++){
            _piece[i][j] = [[UIImageView alloc] init];
            [self.view addSubview:_piece[i][j]];
        }
    }
    
    [self changePiecesWithData];
    
    if( _resume== NO ){
        //display of the ready label
        _ready=[[UILabel alloc]initWithFrame:CGRectMake(_gameWindow.origin.x+_gameWindow.size.width/2-100,
                                                    _gameWindow.origin.y+_gameWindow.size.height/2-50,
                                                    200, 100)];
        [_ready setAdjustsFontSizeToFitWidth:YES];
        [_ready setFont:[UIFont systemFontOfSize:50.f]];
        [_ready setTextAlignment:NSTextAlignmentCenter];
        [_ready setText:@"Ready..."];
        [_ready setTextColor:[UIColor blackColor]];
        [self.view addSubview:_ready];
    
        //preparation for the start animation
        for(i=0; i<_num;i++){
            for(j=0; j<_num; j++){
                _piece[i][j].frame=CGRectOffset(_piece[i][j].frame, 0, 1000*(j+1));
            }
        }
        kaisuu=-1;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                      target:self
                                                    selector:@selector(startAnimation:)
                                                    userInfo:nil
                                                     repeats:YES];
        [timer fire];
    }else{
        [self displayQuitAndBack];
        _start=[NSDate dateWithTimeIntervalSinceNow:-_time];
        [self displayTime];
    }

}

-(void)startAnimation:(NSTimer*)timer{
    if( kaisuu<_num && kaisuu>=0){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7f];
        for(int j=0; j<_num; j++){
            _piece[kaisuu][j].frame = CGRectOffset(_piece[kaisuu][j].frame, 0, -1000*(j+1));
        }
        [UIView commitAnimations];
    }
    if( kaisuu==_num+1){
        [NSThread sleepForTimeInterval:0.7f];
        [timer invalidate];
        [self shuffle];
    }
    kaisuu++;
}

-(void)time:(NSTimer*)timer{
    if( _clearFlag==YES ){
        [timer invalidate];
        return;
    }
    _time=(int)[[NSDate date] timeIntervalSinceDate:_start];
    int h,m,s;
    h = _time/3600;
    m = (_time/60)%60;
    s = _time%60;
    time.text = [NSString stringWithFormat:@"%01d:%02d:%02d",h,m,s];
}

-(void)initWindowSize{
    //initialization of the game window
    CGSize screenSize=[[UIScreen mainScreen] bounds].size;
    int w=300; //width of the window
    int h=300; //height of the window
    int left=(screenSize.width-w)/2;
    int top =(screenSize.height-h)/2;
    _gameWindow = CGRectMake(left, top, w, h);
}

-(void)shuffle{
    _shuffleFlag=YES;
    kaisuu = 0;
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                        target:self
                                                    selector:@selector(sc:)
                                                    userInfo:nil
                                                        repeats:YES];
    [timer fire];
}

-(void)sc:(NSTimer*)timer{
    if( kaisuu < 20){
       [self movePieceWithIndex:abs(arc4random())%_num
                            Axis:(BOOL)abs(arc4random())%2
                       Direction:(BOOL)abs(arc4random())%2
                        Duration:0.05f];
    }
    if( kaisuu == 25){
        _shuffleFlag=NO;
        _start = [NSDate date];
        [self displayTime];
        [self displayQuitAndBack];
        [_ready setText:@"START!"];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    if( kaisuu == 30){
        [timer invalidate];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7f];
        [_ready setAlpha:0.0f];
        [UIView commitAnimations];
    }
    kaisuu ++;
}

-(void)displayQuitAndBack{
    //display of the back button
    UIButton* back=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back setFrame:CGRectMake(_gameWindow.origin.x+_gameWindow.size.width-100, _gameWindow.origin.y+_gameWindow.size.height+25, 100, 50)];
    [back setTitle:@"諦める" forState:UIControlStateNormal];
    [back.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [back.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [back setTag:0];
    [back addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIButton* quit=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [quit setFrame:CGRectMake(_gameWindow.origin.x, _gameWindow.origin.y+_gameWindow.size.height+25, 100, 50)];
    [quit setTitle:@"中断" forState:UIControlStateNormal];
    [quit.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [quit.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [quit setTag:0];
    [quit addTarget:self action:@selector(clickQuit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quit];
}

-(void)displayTime{
    //display of the time
    time=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    time.textColor = [UIColor whiteColor];
    time.font = [UIFont systemFontOfSize:35.0f];
    time.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:time];
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(time:)
                                                    userInfo:nil
                                                     repeats:YES];
    [timer fire];
}

-(void)changePiecesWithData{
    //change the frame and image of each piece by the data
    int i,j;
    int pw = _gameWindow.size.width/_num;
    int ph = _gameWindow.size.height/_num;
    
    for(i=0; i<_num; i++){
        for(j=0; j<_num; j++){
            _piece[i][j].frame = CGRectMake(_gameWindow.origin.x+pw*i,
                                            _gameWindow.origin.y+ph*j, pw, ph);
            _piece[i][j].image = _image[_data[i][j]];
        }
    }
    
}

-(void)initData{
    //initialization of the data

    int i,j;
    for(i=0; i<_num; i++){
        for(j=0; j<_num; j++){
            _data[i][j]=i;
        }
    }
    for(i=_num; i<5; i++){
        for(j=_num; j<5; j++){
            _data[i][j]=0;
        }
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touchBegan = [touches anyObject];
    _tBegan = [ touchBegan locationInView: self.view ];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touchEnded = [touches anyObject];
    _tEnded = [ touchEnded locationInView: self.view ];
    
    int left,top,width,height;
    left   = _gameWindow.origin.x;
    top    = _gameWindow.origin.y;
    width  = _gameWindow.size.width;
    height = _gameWindow.size.height;
    
    if( _tBegan.x<left || _tBegan.x>left+width || _tBegan.y<top || _tBegan.y>top+height ){
        return;
    }else if( abs(_tBegan.x-_tEnded.x)<20 && abs(_tBegan.y-_tEnded.y)<20){
        return;
    }else{
        int j=(_tBegan.x-left)/(width/_num);
        int i=(_tBegan.y-top)/(height/_num);
        BOOL direction; //YES: increment NO: decrement
        BOOL axis;      //YES: x NO: y
        if( abs(_tBegan.x-_tEnded.x)>abs(_tBegan.y-_tEnded.y) ){
            axis = YES;
            if(_tBegan.x<_tEnded.x){
                direction=YES;
            }else{
                direction=NO;
            }
            [self movePieceWithIndex:i Axis:axis Direction:direction Duration:0.3f];
        }else{
            axis =NO;
            if(_tBegan.y<_tEnded.y){
                direction=YES;
            }else{
                direction=NO;
            }
            [self movePieceWithIndex:j Axis:axis Direction:direction Duration:0.3f];
        }
    }
}

-(void)movePieceWithIndex:(int)index Axis:(BOOL)axis Direction:(BOOL)direction Duration:(NSTimeInterval)duration{
    //shifting the pieces
    //axis YES:x NO:y
    //direction YES:increment NO:decrement
    
    int tempdata,i,j;
    CGRect fr, tempframe;
    
    [self changePiecesWithData];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    
    if( axis ){
        if(direction){
            j   = index;
            tempframe = _piece[0][j].frame;
            tempdata  = _data[_num-1][j];
            
            for(i=_num-1; i>0; i--){
                _data[i][j] = _data[i-1][j];
            }
            for(i=0; i<_num-1; i++){
                fr = _piece[i+1][j].frame;
                _piece[i][j].frame =fr;
            }
            _data[0][j]=tempdata;
            _piece[_num-1][j].frame=tempframe;
        }else{
            j = index;
            tempframe = _piece[_num-1][j].frame;
            tempdata  = _data[0][j];
            for(i=0; i<_num-1; i++){
                _data[i][j] = _data[i+1][j];
            }
            for(i=_num-1; i>0; i--){
                fr = _piece[i-1][j].frame;
                _piece[i][j].frame =fr;
            }
            _data[_num-1][j]=tempdata;
            _piece[0][j].frame=tempframe;
        }
    }else{
        if(direction){
            i   = index;
            tempframe = _piece[i][0].frame;
            tempdata  = _data[i][_num-1];
            
            for(j=_num-1; j>0; j--){
                _data[i][j] = _data[i][j-1];
            }
            for(j=0; j<_num-1; j++){
                fr = _piece[i][j+1].frame;
                _piece[i][j].frame =fr;
            }
            _data[i][0]=tempdata;
            _piece[i][_num-1].frame=tempframe;
        }else{
            i   = index;
            tempframe = _piece[i][_num-1].frame;
            tempdata  = _data[i][0];
        
            for(j=0; j<_num-1; j++){
                _data[i][j] = _data[i][j+1];
            }
            for(j=_num-1; j>0; j--){
                fr = _piece[i][j-1].frame;
                _piece[i][j].frame =fr;
            }
            _data[i][_num-1]=tempdata;
            _piece[i][0].frame=tempframe;
        }
    }
    [UIView commitAnimations];
    if( _shuffleFlag==NO )
        [self checkCleared];
}

-(void)checkCleared{
    int _lClear=1;
    int _cClear=1;
    
    for(int i=1; i<_num; i++){
        for(int j=1; j<_num; j++){
            _lClear *= (_data[i][j]==_data[i][0]);
            _cClear *= (_data[i][j]==_data[0][j]);
        }
    }
    
    if( _lClear==1 || _cClear==1 ){
        _clearFlag=YES;
        [self cleared];
    }
}

-(void)cleared{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    time.textColor=[UIColor yellowColor];
    kaisuu = -4;
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                      target:self
                                                    selector:@selector(clearAnimation:)
                                                    userInfo:nil
                                                     repeats:YES];
    [timer fire];
}

-(void)clearAnimation:(NSTimer*)timer{
    if(kaisuu==-1){
        [self changePiecesWithData];
    }else if(kaisuu>=0 && kaisuu<_num*4+2){
        int i=kaisuu%(_num*2-1);
        if( kaisuu<_num*4-2){
            if( i<_num){
                for(int j=0; j<=i; j++){
                    _piece[j][i-j].alpha=0.4f;
                }
            }else{
                for(int j=i-_num+1; j<_num; j++){
                    _piece[j][i-j].alpha=0.4f;
                }
            }
        }
        i=(kaisuu-2)%(_num*2-1);
        if( i<_num){
            for(int j=0; j<=i; j++){
                _piece[j][i-j].alpha=1.0f;
            }
        }else{
            for(int j=i-_num+1; j<_num; j++){
                _piece[j][i-j].alpha=1.0f;
            }
        }
        [UIView commitAnimations];
     }else if( kaisuu==_num*4+2 ){
         UILabel* cleared=[[UILabel alloc]init];
         [cleared setText:@"CLEARED!"];
         [cleared setTextColor:[UIColor blackColor]];
         [cleared setAdjustsFontSizeToFitWidth:YES];
         [cleared setFont:[UIFont systemFontOfSize:50.0f]];
         [cleared setTextAlignment:NSTextAlignmentCenter];
         [cleared setFrame:CGRectMake(_gameWindow.origin.x+_gameWindow.size.width/2-120,
                                      _gameWindow.origin.y+_gameWindow.size.height/2-50, 240, 100)];
         [self.view addSubview:cleared];
     }else if( kaisuu>=_num*4+20 && kaisuu<_num*5+20 ){
         int screenedge = [UIScreen mainScreen].bounds.origin.y+
         [UIScreen mainScreen].bounds.size.height;
         
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:0.7f];
         
         int i=kaisuu-_num*4-20;
         for(int j=0; j<_num; j++){
             _piece[i][j].frame = CGRectMake(_piece[i][j].frame.origin.x,
                                                  screenedge+1000*j, _piece[i][j].frame.size.width,
                                                  _piece[i][j].frame.size.height);
         }
         [UIView commitAnimations];
     }else if( kaisuu >_num*5+22){
        [timer invalidate];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        ClearViewController* next=[[ClearViewController alloc]init];
        [next set_clearTime:_time];
        [next set_num:_num];
        next.modalTransitionStyle=TRANSSTYLE;
        [self presentViewController:next animated:YES completion:nil];
    }


    kaisuu ++;
}

-(IBAction)clickQuit:(id)sender{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil
                                                 message:@"現在のゲームをセーブして中断しますか？"
                                                delegate:self
                                       cancelButtonTitle:@"いいえ"
                                       otherButtonTitles:@"はい", nil];
    alert.tag=0;
    [alert show];
}


-(IBAction)clickBack:(id)sender{
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil
                                                 message:@"現在のゲームを破棄してもよろしいですか？"
                                                delegate:self
                                       cancelButtonTitle:@"いいえ"
                                       otherButtonTitles:@"はい", nil];
    alert.tag=1;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if( buttonIndex==1 ){
        if( alertView.tag==0 ){
            [self saveData];
        }
        MenuViewController* next=[[MenuViewController alloc]init];
        next.modalTransitionStyle=TRANSSTYLE;
        [self presentViewController:next animated:YES completion:nil];
    }
}

-(void)saveData{
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSData* data;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    path=[path stringByAppendingPathComponent:@"data"];
    [manager removeItemAtPath:path error:NULL];
    [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    
    data = [NSData dataWithBytes:&_num length:sizeof(_num)];
    [data writeToFile:[path stringByAppendingPathComponent:@"num"] atomically:YES];
    
    data = [NSData dataWithBytes:&_time length:sizeof(_time)];
    [data writeToFile:[path stringByAppendingPathComponent:@"time"] atomically:YES];
    
    for(int i=0; i<_num; i++){
        for(int j=0; j<_num; j++){
            data = [NSData dataWithBytes:&_data[i][j] length:sizeof(_data[i][j])];
            [data writeToFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d%d",i,j]] atomically:YES];
        }
    }
}

-(void)loadData{
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSData* data;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    path=[path stringByAppendingPathComponent:@"data"];
    
    data = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"num"]];
    [data getBytes:&_num length:sizeof(_num)];
    
    data = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"time"]];
    [data getBytes:&_time length:sizeof(_time)];
    
    for(int i=0; i<_num; i++){
        for(int j=0; j<_num; j++){
            data=[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d%d",i,j]]];
            [data getBytes:&_data[i][j] length:sizeof(_data[i][j])];
        }
    }
    [manager removeItemAtPath:path error:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end