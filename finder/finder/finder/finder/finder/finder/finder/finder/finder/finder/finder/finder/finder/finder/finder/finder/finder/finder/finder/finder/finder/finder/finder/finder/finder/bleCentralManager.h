//
//  bleCentralManager.h
//  MonitoringCenter
//
//  Created by David ding on 13-1-10.
//
//

#define kMacdataKey                         @"macData"
#define kPeripheralKey                      @"peripheral"

#define SavedList                           @"AntilostSavedPropertist.plist"


#import <CoreBluetooth/CoreBluetooth.h>
#import "blePeripheral.h"

@class blePeripheral;
/****************************************************************************/
/*                      CentralDelegateState的类型                           */
/****************************************************************************/
enum {
    // 中心设备事件状态
    bleCentralDelegateStateRetrievePeripherals = 0,
    bleCentralDelegateStateRetrieveConnectedPeripherals,
    bleCentralDelegateStateDiscoverPeripheral,
    bleCentralDelegateStateConnectPeripheral,
    bleCentralDelegateStateFailToConnectPeripheral,
    bleCentralDelegateStateDisconnectPeripheral,
    // 中心设备当前状态
    bleCentralDelegateStateCentralManagerResetting,
    bleCentralDelegateStateCentralManagerUnsupported,
    bleCentralDelegateStateCentralManagerUnauthorized,
    bleCentralDelegateStateCentralManagerUnknown,
    bleCentralDelegateStateCentralManagerPoweredOn,
    bleCentralDelegateStateCentralManagerPoweredOff,
};
typedef NSInteger bleCentralDelegateState;

// 消息通知
//==============================================
// 发送消息
#define nCentralStateChange                     [[NSNotificationCenter defaultCenter] postNotificationName:@"nCBCentralStateChange"  object:nil];
// 接收消息
#define nCBCentralStateChange                   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBCentralStateChange) name:@"nCBCentralStateChange" object:nil];
//==============================================

@interface bleCentralManager : NSObject
//======================================================
// CBCentralManager
@property(strong, nonatomic)    CBCentralManager        *activeCentralManager;
//======================================================
// NSMutableArray
@property(strong, nonatomic)    NSMutableArray          *ScanPeripheralArray;           // NSDictionary -> (peripheral & macData)
@property(strong, nonatomic)    NSMutableArray          *blePeripheralArray;            // blePeripheral
//======================================================
// Property
@property(readonly)             NSInteger               currentCentralManagerState;
@property(readonly)             Byte                    addAntilostPeripheralCount;
//======================================================
// method
-(void)startScanning;
-(void)stopScanning;
-(void)resetScanning;
-(void)SavePeripheralProperty;
-(void)ReadPeripheralProperty;

-(void)disconnectPeripheralFromBlePeripheralArray:(CBPeripheral*)peripheral;
-(void)disconnectPeripheralFromBlePeripheralArrayAtInteger:(NSUInteger)integer;
-(void)addNewConnectPeripheralToBlePeripheralArrayFromScanPeripheralArrayAtInteger:(NSUInteger)integer;
@end


