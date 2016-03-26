//
//  RecorderModel.h
//  finder
//
//  Created by Ignacio Garcia on 13-7-16.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
//#import "lame.h"
@protocol RecorderModelDelegate <NSObject>

-(void)updateTime:(NSString *)recordTime   size:(NSString*)recordSize;   //更新时间

@end

@interface RecorderModel : NSObject <AVAudioPlayerDelegate>

{
    AVAudioRecorder                *_recorder;
    
    AVAudioPlayer*                  _player;

    BOOL                            _hasCAFFile;
    BOOL                            _recording;
    BOOL                            _playing;
    
    NSURL*                          _recordedFile;
    CGFloat                         _sampleRate;
    AVAudioQuality                  _quality;
    NSInteger                       _formatIndex;
    NSTimer*                        _timer;
    UIAlertView*                    _alert;
    NSDate*                         _startDate;
    
    
    NSString                         *timeString;
    NSString                        *sizeString;
    
 
}
@property(assign,nonatomic) id<RecorderModelDelegate> delegateRecord;

-(void)startRecordEvent;
-(void)stopRecordEvent;
-(void)playRecordEvent:(NSString *)tmpRecordeNameStr isLoop:(Boolean)loop;
-(void)stopPlayRecordEvent;
-(void)cancelRecordEvent;
-(BOOL)existRecordFile:(NSString *) recorderNameFile;
-(Boolean)playing;

-(void)deleteRecorderFile:(NSString *)tmpRecorderName;
-(NSMutableArray *)getRecordArray;  //反回所有录音文件


-(void)setNotifitcationBoolean:(Boolean) boo;
-(Boolean)getNotificationBoolean;
@end
