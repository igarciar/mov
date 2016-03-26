//
//  blePeripheral.h
//  MonitoringCenter
//
//  Created by Ignacio Garcia on 13-1-10.
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>  
#import "controlValue.h"

extern NSString *kAntilostServiceUUID;

#define kLinkServiceUUID                        @"FE20"

// connectionInterval
#define kHighRssiResponseRate                   20
#define kNormolHRssiResponseRate                33
#define kSlowRssiResponseRate                   49

// rssi
#define MaxRssiABS                              5
#define kDefaultAlarmRssi                       80
//#define kStopAlarmRxRssi                        55.0f
#define kStopAlarmRxRssi                        37.0f
#define kMinResponseRssiValue                   30.0f
#define kMinSetResponseRssiValue                60.0f
#define kMaxSetResponseRssiValue                85.0f
#define kRssiResponseRate                       8
#define CheckOutrangeTime                       0.5

// alarmSoundState 
#define kStopAlarmState                         0
#define kSetupValueState                        1
#define kWarningValueState                      2
#define kAlarmValueState                        3

// holdKeyPressedFunctions
#define kHoldKeyDisabel                         0x00
#define kHoldKeySetupDistance                   0x01
#define kHoldKeyWorkOnOff                       0x02

// flashLight
#define kFlashLightFrg                          3

#define BUILD_UINT16(loByte, hiByte) \
((UInt16)(((loByte) & 0x00FF) + (((hiByte) & 0x00FF) << 8)))

// 消息通知
//==============================================
// 发送消息
#define nTxRssi                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"CBTxRssi" object:nil];
#define nPeripheralStateChange                  [[NSNotificationCenter defaultCenter]postNotificationName:@"CBPeripheralStateChange"  object:nil];
//#define nPlayAlarmStopPost                  [[NSNotificationCenter defaultCenter]postNotificationName:@"CBStopPlay"  object:nil];
// 接收消息
#define nCBTxRssi                               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBTxRssi) name:@"CBTxRssi" object:nil];
#define nCBPeripheralStateChange                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBPeripheralStateChange) name:@"CBPeripheralStateChange" object:nil];

//#define nPlayAlarmStopCreate                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nStopPlay) name:@"CBStopPlay" object:nil];
//==============================================
// 发送消息
#define nEnterBackground                        [[NSNotificationCenter defaultCenter]postNotificationName:@"CBEnterBackground" object:nil];
#define nEnterForeground                        [[NSNotificationCenter defaultCenter]postNotificationName:@"CBEnterForeground" object:nil];

// 接收消息
#define nCBEnterBackground                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBEnterBackground ) name:@"CBEnterBackground" object:nil];
#define nCBEnterForeground                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBEnterForeground ) name:@"CBEnterForeground" object:nil];
//==============================================


// 定义报警声音
//==============================================
#define audioArray                              [[NSArray alloc] initWithObjects:@"music01", @"music02", @"music03", @"music04",@"dgjd", @"bjs", @"BeatPlucker", @"Bollywood", @"LeisureTime", @"LoveFlute", @"Orange", @"Simple_World", @"Third_Eye", @"World", @"belove",  @"dzjb",@"Error", @"119jd", @"jlyx", @"ls", @"Alarm_Beep_01", @"Alarm_Beep_02", @"Alarm_Rooster_02", @"Alarm_Classic", @"Alarm_Buzzer", @"Finish", @"pixiedust", nil]

#define audioName                               [[NSArray alloc] initWithObjects:@"Cool music01", @"Cool music02", @"Cool music03", @"Cool music04",@"Dj alarm", @"Alarm", @"BeatPlucker", @"Bollywood", @"LeisureTime", @"LoveFlute", @"Orange", @"Simple_World", @"Third_Eye", @"World", @"Belove",  @"Electronic alarms",@"Error", @"Fire alarm", @"Ambulance alarm", @"Thunder", @"Beep01", @"Beep02", @"Rooster", @"Classic", @"Buzzer", @"Finish", @"Pixiedust", nil]
//==============================================

// 系统音量
//==============================================
#define AlarmVolume                             1.f
#define MuteVolume                              0.f
#define SystemVolume                            [MPMusicPlayerController iPodMusicPlayer].volume
#define SystemVibrate                           AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);


#define InitAlarmPlayer                         alarmPlayer = [self setPlayer:alarmPlayer AtIndex:_alarmSoundID WithLoop:-1];
#define InitConnectPlayer                       connectPlayer = [self setPlayer:connectPlayer AtIndex:26 WithLoop:0];
//#define InitDisconnectPlayer                    disconnectPlayer = [self setPlayer:alarmPlayer AtIndex:_alarmSoundID WithLoop:-1];//[self setPlayer:keyPlayer AtIndex:16 WithLoop:3];
#define InitKeyPlayer                           keyPlayer = [self setPlayer:keyPlayer AtIndex:23 WithLoop:3];
#define InitAutoSetupFinishPlayer               autoSetupFinishPlayer = [self setPlayer:autoSetupFinishPlayer AtIndex:25 WithLoop:0];
//==============================================

// 录音存储
//==============================================
#define kRecordPathList                         @"antiRecordPathList.plist"
#define kRecordSoundID                          0xFF
#define kMaxChooseSoundID                       24
//==============================================


// 加密使能
#define ENABLE_AUTO_TERMINATE                   NO // YES | NO
#define ENABLE_ENCODE                           YES // YES | NO
#define CRCPASSWORD                             { 'A','n','t','i','l','o','s','t' }

#define DefaultControlValue                     { NO, NO, 0x00, 0x0A }
#define DefaultNameValue                        { 'A','n','t','i','l','o','s','t' }
#define DefaultKeypressedValue                  { 0x00 }
#define DefaultRssiValue                        { 0x00 }
#define DefaultBatteryValue                     { 0x64 }


// Data definition
#define ANTILOST_RW_CONTROL_VALUE_LENGTH        4   // InstantDisconnect, Enabelwork, AlarmSoundState, ConnectionInterval
                                                    // InstantDisconnect     >>> Default is 0.  user set value is 0 -> Do Nothing | 1 -> Instant Disconnect Link.
                                                    // Enabelwork            >>> Default is 0.  user set value is 0 -> Stop Anti | 1 -> Start Anti.
                                                    // AlarmSoundState       >>> Default is 0.           0 -> Stop | 1 -> Warning | 2 -> Alarm | 3 -> Constantly alarm.
                                                    // ConnectionInterval    >>> Default is 0x0A(10).    10*10mS = 100mS. user set value is 1~200.

#define ANTILOST_RW_NAME_LENGTH                 19  // ANTILOST

#define ANTILOST_RN_KEYPRESSED_LENGTH           1   // KeyPressed            >>> Default is 0.           user set value is 0x00(0) ~ 0x01(1).

#define ANTILOST_RN_CURRENT_RSSI_LENGTH         1   // RSSI, EnabelAnti == 1 -> Read | Notification

#define ANTILOST_RN_CURRENT_BATTERY_LENGTH      1   // Battery               >>> Default is 100.         user set value is 0x00(0) ~ 0x64(100).

/****************************************************************************/
/*                      PeripheralDelegateState的类型                        */
/****************************************************************************/
// Peripheral的消息类型
enum {
    blePeripheralStateInit = 0,
    blePeripheralStateConnected,
    blePeripheralStateDisconnected,
    blePeripheralStateSearchPhoneStart,
    blePeripheralStateSearchPhoneStop,
    blePeripheralStateHoldKeypressed,
    blePeripheralStateAlarm,
    blePeripheralStateStopAlarm,
};
typedef NSInteger blePeripheralDelegateState;

// callState的类型
enum {
    callStateDialing = 0,
    callStateIncoming,
    callStateConnected,
    callStateDisconnected,
};
typedef NSInteger callState;



@interface blePeripheral : NSObject
//======================================================
// CBPeripheral
@property(strong, nonatomic)    CBPeripheral            *activePeripheral;
@property(nonatomic)            NSDictionary            *activeAntiLostProperty;
//======================================================
// CBService and CBCharacteristic
@property(readonly)             CBService               *AntilostServiceService;
@property(readonly)             CBCharacteristic        *AntilostRWControlValueCharateristic;
@property(readonly)             CBCharacteristic        *AntilostRWNameCharateristic;
@property(readonly)             CBCharacteristic        *AntilostRNKeypressedValueCharateristic;
@property(readonly)             CBCharacteristic        *AntilostRNCurrentRssiCharateristic;
@property(readonly)             CBCharacteristic        *AntilostRNBatteryCharateristic;
//======================================================
// 状态属性
@property(readonly)             NSUInteger              currentPeripheralState;
@property(readonly)             BOOL                    connectedFinish;
@property(readonly)             BOOL                    antilostAlarmWorkStart;
@property(readonly)             Byte                    autoReconnectCount;
// 需要存储属性
@property(readwrite)            NSData                  *macData;
@property(readwrite)            NSString                *uuidString;
@property(readwrite)            UIImage                 *choosePicture;
@property(readwrite)            NSString                *nameString;
@property(readwrite)            Byte                    toggleAlarmValue;           // 60 ~ 85

@property(readwrite)            BOOL                    enabelFlashLabel;
@property(readwrite)            BOOL                    enabelFlashLight;
@property(readwrite)            BOOL                    enabelVibrate;
@property(readwrite)            BOOL                    enabelPushMsg;
@property(readwrite)            BOOL                    enabelMute;
@property(readwrite)            NSString                *recordID;
@property(readwrite)            Byte                    alarmSoundID;               // 0~24 | 0xFF -> Record
@property(readwrite)            AVAudioRecorder         *recorderPlayer;
@property(nonatomic)            BOOL                    enabelAntilostWork;
@property(nonatomic)            BOOL                    enabelAlarmTimer;
@property(readwrite)            Byte                    timerOnHour;
@property(readwrite)            Byte                    timerOnMinute;
@property(readwrite)            Byte                    timerOffHour;
@property(readwrite)            Byte                    timerOffMinute;
@property(readwrite)            Byte                    holdKeyPressedFunctions;    // 0 -> disabel | 1 -> Setup distance 2 -> Setup Lost alarm On/Off

// 控制属性
@property(readwrite)            controlValue            *cv;

// 防丢参数
@property(readonly)             Byte                    currentTxRssi;
@property(readonly)             Byte                    TxFilteringValue;
@property(readonly)             NSMutableArray          *txRssiArray;
//@property(readonly)             Byte                    currentRxRssi;
@property(readonly)             Byte                    currentBattery;


-(id)initWithPeripheral;
-(id)initWithPeripheralwithMacData:(NSData *)data;
-(void)startPeripheral:(CBPeripheral *)peripheral DiscoverServices:(NSArray *)services;
-(void)disconnectPeripheral:(CBPeripheral *)peripheral;
-(void)autoSetupToggleAlarmValue;
-(void)savedActiveAntiLostProperty;
-(void)sendControlValueEvent;
-(void)startAlarm;
-(void)stopAlarm;
@end
