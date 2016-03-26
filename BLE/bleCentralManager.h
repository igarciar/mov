//
//  bleCentralManager.h
//  MonitoringCenter
//
//  Created by Ignacio Garcia on 13-1-10.
//
//

#define kMacdataKey                         @"macData"
#define kPeripheralKey                      @"peripheral"
#define kNameStringKey                      @"nameString"

#define SavedList                           @"AntilostSavedPropertist.plist"


#import <CoreBluetooth/CoreBluetooth.h>
#import "blePeripheral.h"

/****************************************************************************/
/*                      CentralDelegateState的类型                           */
/****************************************************************************/
enum {
    // 中心设备事件状态
    bleCentralManagerStateInit = 0,
    bleCentralManagerStateDiscoverPeripheral,
    bleCentralManagerStateConnected,
    bleCentralManagerStateDisconnected,
};
typedef NSInteger bleCentralDelegateState;

// 消息通知
//==============================================
// 发送消息
#define nCentralStateChange                     [[NSNotificationCenter defaultCenter] postNotificationName:@"CBCentralStateChange"  object:nil];
// 接收消息
#define nCBCentralStateChange                   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBCentralStateChange) name:@"CBCentralStateChange" object:nil];
//==============================================

@interface bleCentralManager : NSObject
//======================================================
// CBCentralManager
@property(strong, nonatomic)    CBCentralManager        *activeCentralManager;
//======================================================
// NSMutableArray
@property(strong, nonatomic)    NSMutableArray          *ScanPeripheralArray;           // NSDictionary -> (peripheral & macData & nameString)
@property(strong, nonatomic)    NSMutableArray          *blePeripheralArray;            // blePeripheral
//======================================================
// Property
@property(readonly)             NSInteger               currentCentralManagerState;
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


