//
//  RecorderModel.m
//  finder
//  录音和播放功能
//  Created by Ignacio Garcia on 13-7-16.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "RecorderModel.h"

@implementation RecorderModel
{
    NSString           *recorderNameStr;
    
       Boolean                         notifiticationBoolean;  //为真时不弹消息
}
- (id)init
{
    self = [super init];
    if (self) {
        
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        
        notifiticationBoolean = YES;  //判断 是否为真，真时推送消息
        _sampleRate  = 44100;
        _quality     = AVAudioQualityLow;
        _formatIndex = kAudioFormatLinearPCM;
        _recording = _playing = _hasCAFFile = NO;
        
        if(session == nil)
        {
            NSLog(@"Error creating session: %@", [sessionError description]);
        } else{
            [session setActive:YES error:nil];
        }
    }
    return self;
}
-(void)startRecordEvent  //开始录音
{
    recorderNameStr = [NSTemporaryDirectory() stringByAppendingString:[self getCurrentTime]];
    _recordedFile = [NSURL fileURLWithPath:recorderNameStr];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: _sampleRate],                  AVSampleRateKey,
                              [NSNumber numberWithInt: (int)_formatIndex],                   AVFormatIDKey,
                              [NSNumber numberWithInt: 2],                              AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: _quality],                       AVEncoderAudioQualityKey,
                              nil];
    
  
    NSError* error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:_recordedFile settings:settings error:&error];
    NSLog(@"%@", [error description]);
    if (error)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"your device doesn't support your setting"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    _recording = YES;
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    [_recorder record];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                              target:self
                                            selector:@selector(timerUpdate)
                                            userInfo:nil
                                             repeats:YES];
}
-(void)stopRecordEvent //结束录音
{
    _recording = NO;
    
    [_timer invalidate];
    _timer = nil;
    
    if (_recorder != nil )
    {
        _hasCAFFile = YES;
    }
    [_recorder stop];
    _recorder = nil;
}
-(void)cancelRecordEvent  //取消录音
{
    _recording = NO;
    
    [_timer invalidate];
    _timer = nil;
    
    if (_recorder != nil )
    {
        _hasCAFFile = YES;
    }
    [_recorder stop];
    [_recorder deleteRecording];
    _recorder = nil;
}
- (void) timerUpdate
{
    if (_recording)
    {
        int m = _recorder.currentTime / 60;
        int s = ((int) _recorder.currentTime) % 60;
        //        int ss = (_recorder.currentTime - ((int) _recorder.currentTime)) * 100;
        
        timeString = [NSString stringWithFormat:@"%.2d:%.2d", m, s];
        NSInteger fileSize =  [self getFileSize:recorderNameStr];
        
        sizeString = [NSString stringWithFormat:@"%ld kb", fileSize/1024];
        [_delegateRecord updateTime:timeString size:sizeString];
        NSLog(@" time %@",timeString);
    }
}
- (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else
    {
        return -1;
    }
}

-(void)playRecordEvent:(NSString *)tmpRecordeNameStr isLoop:(Boolean)loop
{
    if (_playing)
    {
        [_timer invalidate];
        _playing = NO;
        [_player stop];
        _player = nil;
    }
    _recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:tmpRecordeNameStr]];
    if([self existRecordFile:tmpRecordeNameStr])
    {
        if (_player == nil)
        {
            NSError *playerError;
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
            _player.meteringEnabled = YES;
            if (_player == nil)
            {
                NSLog(@"ERror creating player: %@", [playerError description]);
            }
            _player.delegate = self;
        } 
        _playing = YES;
        if(loop)
        {
                _player.numberOfLoops = -1; //重复播放
        }else{
                _player.numberOfLoops = 0;
        }
        OSStatus rror;
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        rror = AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
        if (rror) printf("couldn't set audio speaker!");
        [_player play];
    }else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Please Record a File First"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles: nil];
        [alert show];

    }
}
-(void)stopPlayRecordEvent
{
    if (_playing)
    {
        [_timer invalidate];
        _playing = NO;
        [_player stop];
        notifiticationBoolean = YES;
         _player = nil;
    }
}
-(Boolean)playing
{
    return _playing;
}
-(BOOL)existRecordFile:(NSString *)recorderNameFile // 判断是否存在录音文件
{
    NSInteger fileSize =  [self getFileSize:[NSTemporaryDirectory() stringByAppendingString:recorderNameFile]];
    if(fileSize >0)
    {
        return YES;
    }
    return NO;
}
-(NSMutableArray *)getRecordArray
{
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    NSMutableArray *directoryContents;
    directoryContents = [NSMutableArray arrayWithArray:[myFileManager  subpathsAtPath:NSTemporaryDirectory()]];
    NSLog(@"用directoryContentsAtPath:显示目录%@的内容：",NSTemporaryDirectory());
    //    NSLog(@"文件directory count: %d %@:",directoryContents.count,directoryContents[0]);
    for (int position = 0; position <directoryContents.count; position++) {
        NSLog(@"目录文件： %@ ",directoryContents[position]);
    }
    return directoryContents;
}
-(void)deleteRecorderFile:(NSString *)tmpRecorderName
{
    NSLog(@"delete  %@ ",[NSTemporaryDirectory() stringByAppendingString:tmpRecorderName]);
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    [myFileManager removeItemAtURL:[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:tmpRecorderName]] error:nil];
}
-(NSString *)getCurrentTime
{
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    [dateformat setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSLog(@"request start time%@",newDateOne);
    return newDateOne;
}
-(void)setNotifitcationBoolean:(Boolean) boo
{
    notifiticationBoolean = boo;
}
-(Boolean)getNotificationBoolean
{
    return notifiticationBoolean;
}
@end
