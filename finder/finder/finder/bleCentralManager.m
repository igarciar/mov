//
//  bleCentralManager.m
//  MonitoringCenter
//
//  Created by David ding on 13-1-10.
//
//

#import "bleCentralManager.h"

@implementation bleCentralManager{
    NSData *macDataBack;
}

@synthesize activeCentralManager;

@synthesize ScanPeripheralArray;
@synthesize blePeripheralArray;
@synthesize currentCentralManagerState;
@synthesize addAntilostPeripheralCount;

#pragma mark -
#pragma mark Init
/******************************************************/
//          类初始化                                   //
/******************************************************/
// 初始化蓝牙
-(id)init{
    self = [super init];
    if (self) {
        activeCentralManager = [[CBCentralManager alloc] initWithDelegate:(id<CBCentralManagerDelegate>)self queue:dispatch_get_main_queue()];
        [self initProperty];
    }
    return self;
}

-(void)initProperty{
    ScanPeripheralArray             = [[NSMutableArray alloc]init];
    blePeripheralArray              = [[NSMutableArray alloc]init];
    addAntilostPeripheralCount      = 0;
}

#pragma mark -
#pragma mark Scanning
/****************************************************************************/
/*						   		Scanning                                    */
/****************************************************************************/
// 按UUID进行扫描
-(void)startScanning{
	NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:kLinkServiceUUID], nil];
    // CBCentralManagerScanOptionAllowDuplicatesKey | CBConnectPeripheralOptionNotifyOnConnectionKey | CBConnectPeripheralOptionNotifyOnDisconnectionKey | CBConnectPeripheralOptionNotifyOnNotificationKey
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
	[activeCentralManager scanForPeripheralsWithServices:uuidArray options:options];
    macDataBack = nil;
}

// 停止扫描
-(void)stopScanning{
	[activeCentralManager stopScan];
}

-(void)resetScanning{
    [self stopScanning];
    [self startScanning];
}

#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
-(void)connectPeripheral:(CBPeripheral*)peripheral
{
	if (![peripheral isConnected]){
        // 连接设备
        [activeCentralManager connectPeripheral:peripheral options:nil];
	}
    else{
        // 检测已连接Peripherals
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 6.0){
            [activeCentralManager retrieveConnectedPeripherals];
        }
    }
}

-(void)disconnectPeripheral:(CBPeripheral*)peripheral
{
    // 主动断开
    if ([peripheral isConnected]){
        [activeCentralManager cancelPeripheralConnection:peripheral];
    }
}

-(void)removeConnectedPeripheral:(CBPeripheral*)peripheral{
    // 异常断开
    [self disconnectPeripheralFromBlePeripheralArray:peripheral];
    [self disconnectPeripheral:peripheral];
    [self resetScanning];
}

#pragma mark -
#pragma mark Management peripheral
/****************************************************************************/
/*				   		Management peripheral                               */
/****************************************************************************/
// 存取数据
-(void)SavePeripheralProperty{
    // 当前列表
    if (blePeripheralArray.count>0) {
        // 清空当前存储属性列表
        NSMutableArray *blePeripheralPropertyArray = [[NSMutableArray alloc]init];
        // 当前设备列表中设备不为空
        for (NSUInteger idx=0; idx<blePeripheralArray.count; idx++) {
            blePeripheral *bp = [blePeripheralArray objectAtIndex:idx];
            // 将当前设备属性打包到activeAntiLostProperty中
            [bp savedActiveAntiLostProperty];
            // 将打包好的属性存到设备列表中
            [blePeripheralPropertyArray addObject:bp.activeAntiLostProperty];
        }
        // 全部存储完成
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[pathArray objectAtIndex:0]stringByAppendingPathComponent:SavedList];
        [blePeripheralPropertyArray writeToFile:path atomically:YES];
        //NSLog(@"完成存储BLE属性数组:%@",blePeripheralPropertyArray);
    }
    else{
        // 如果没有设备则删除文件
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[pathArray objectAtIndex:0]stringByAppendingPathComponent:SavedList];
        [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
    }
}

-(void)ReadPeripheralProperty{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArray objectAtIndex:0]stringByAppendingPathComponent:SavedList];
    BOOL fileExists = [[NSFileManager defaultManager]fileExistsAtPath:path];
    if (fileExists){
        // 如果文件存在则恢复设备列表
        NSMutableArray *blePeripheralPropertyArray = [[NSMutableArray alloc]initWithContentsOfFile:path];
        //NSLog(@"成功取出BLE属性数组:%@",blePeripheralPropertyArray);
        
        if (blePeripheralPropertyArray.count>0) {
            // 如果读取的数组数量大于0则恢复到设备中
            for (NSUInteger idx=0; idx<blePeripheralPropertyArray.count; idx++) {
                blePeripheral *bp = [[blePeripheral alloc]initWithPeripheral];
                // 恢复数据
                bp.activeAntiLostProperty = [blePeripheralPropertyArray objectAtIndex:idx];
                [blePeripheralArray addObject:bp];
            }
            // 全部读取完成
            //NSLog(@"成功恢复BLE列表数组:%@",blePeripheralArray);
        }
    }
}

#pragma mark -
#pragma mark Management peripheral
/****************************************************************************/
/*				   		Management peripheral                               */
/****************************************************************************/
// 载入设备
-(BOOL)checkPeripheralFromPeripheralPropertStroedArray:(CBPeripheral*)peripheral withmacData:(NSData *)data{
    BOOL checkout = NO;
    if (blePeripheralArray.count >0) {
        for (NSUInteger idx=0; idx<blePeripheralArray.count; idx++) {
            // 从存储号数组中
            blePeripheral *bp = [blePeripheralArray objectAtIndex:idx];
            if ([bp.macData isEqualToData:data]) {
                // 比较mac数据、如果相同则为直接连设备
                bp.activePeripheral = peripheral;
                [self connectPeripheral:bp.activePeripheral];
                //NSLog(@"findConnectedPeripheral");
                break;
            }
        }
    }
    return checkout;
}

-(void)discoverPeripheralServices:(CBPeripheral*)peripheral{
    // 发现服务
    if (blePeripheralArray.count>0) {
        for (NSUInteger idx=0; idx<blePeripheralArray.count; idx++) {
            blePeripheral *bp = [blePeripheralArray objectAtIndex:idx];
            if ([bp.activePeripheral isEqual:peripheral]) {
                if ([bp.activePeripheral isConnected]) {
                    // 如果当前设备是已连接设备开始扫描服务
                    CBUUID  *ALSerUUID   = [CBUUID UUIDWithString:kAntilostServiceUUID];
                    NSArray	*serviceArray = [NSArray arrayWithObjects: ALSerUUID, nil];
                    [bp startPeripheral:bp.activePeripheral DiscoverServices:serviceArray];
                    // 将当前设备移动到列表第一个
                    if ([blePeripheralArray containsObject:bp]) {
                        [blePeripheralArray removeObject:bp];
                        [blePeripheralArray insertObject:bp atIndex:0];
                    }
                    //NSLog(@"blePeripheralArray:%@",blePeripheralArray);
                }
                else{
                    // 如果还没有连接则再次连接、一般不会到这里来
                    [self connectPeripheral:bp.activePeripheral];
                }
            }
        }
    }
}

-(void)disconnectPeripheralFromBlePeripheralArray:(CBPeripheral*)peripheral{
    // 断片连接、清除blePeripheral的相关信息
    if (blePeripheralArray.count>0) {
        for (NSUInteger idx=0; idx<blePeripheralArray.count; idx++) {
            blePeripheral *bp = [blePeripheralArray objectAtIndex:idx];
            if ([bp.activePeripheral isEqual:peripheral]) {
                [bp disconnectPeripheral:peripheral];
                // 将当前设备移动到列表最后一个
                //NSLog(@"blePeripheralArray:%@",blePeripheralArray);
                [blePeripheralArray removeObject:bp];
                [blePeripheralArray insertObject:bp atIndex:blePeripheralArray.count];
                //NSLog(@"blePeripheralArray:%@",blePeripheralArray);
            }
        }
    }
}

-(void)addNewConnectPeripheralToBlePeripheralArrayFromScanPeripheralArrayAtInteger:(NSUInteger)integer{
    if (ScanPeripheralArray.count > integer) {
        NSDictionary *ad = [ScanPeripheralArray objectAtIndex:integer];
        CBPeripheral *cp = [ad objectForKey:kPeripheralKey];
        NSData *macdata = [ad objectForKey:kMacdataKey];
        blePeripheral *bp = [[blePeripheral alloc]initWithPeripheralwithMacData:macdata];
        bp.activePeripheral = cp;
        //bp.macData = macdata;
        if (![blePeripheralArray containsObject:bp]) {
            [blePeripheralArray insertObject:bp atIndex:0];
            //NSLog(@"addNewblePeripheralArray.count:%d",blePeripheralArray.count);
            //NSLog(@"addNewblePeripheralArray:%@",blePeripheralArray);
        }
        // 开始连接
        [self connectPeripheral:bp.activePeripheral];
    }
}

-(void)disconnectPeripheralFromBlePeripheralArrayAtInteger:(NSUInteger)integer{
    if (blePeripheralArray.count > integer) {
        blePeripheral *bp = [blePeripheralArray objectAtIndex:integer];
        [self disconnectPeripheralFromBlePeripheralArray:bp.activePeripheral];
    }
}

#pragma mark -
#pragma mark CBCentralManager
/****************************************************************************/
/*							CBCentralManager								*/
/****************************************************************************/
// 中心设备状态更新
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    //activeCentralManager = central;
    if ([activeCentralManager isEqual:central]) {
        switch ([central state]){
                // 掉电状态
            case CBCentralManagerStatePoweredOff:
            {
                // 更新状态
                currentCentralManagerState = bleCentralDelegateStateCentralManagerPoweredOff;
                nCentralStateChange
                [self resetScanning];
                NSLog(@"CBCentralManagerStatePoweredOff\n");
                break;
            }
                
                // 未经授权的状态
            case CBCentralManagerStateUnauthorized:
            {
                /* Tell user the app is not allowed. */
                // 更新状态
                currentCentralManagerState = bleCentralDelegateStateCentralManagerUnauthorized;
                nCentralStateChange
                [self resetScanning];
                NSLog(@"CBCentralManagerStateUnauthorized\n");
                break;
            }
                
                // 未知状态
            case CBCentralManagerStateUnknown:
            {
                /* Bad news, let's wait for another event. */
                // 更新状态
                currentCentralManagerState = bleCentralDelegateStateCentralManagerUnknown;
                nCentralStateChange
                [self resetScanning];
                NSLog(@"CBCentralManagerStateUnknown\n");
                break;
            }
                
            case CBCentralManagerStateUnsupported:
            {
                // 更新状态
                currentCentralManagerState = bleCentralDelegateStateCentralManagerUnsupported;
                nCentralStateChange
                [self resetScanning];
                NSLog(@"CBCentralManagerStateUnsupported\n");
                break;
            }
                
                // 上电状态
            case CBCentralManagerStatePoweredOn:
            {
                // 更新状态
                currentCentralManagerState = bleCentralDelegateStateCentralManagerPoweredOn;
                nCentralStateChange
                [self startScanning];
                NSLog(@"CBCentralManagerStatePoweredOn\n");
                break;
            }
                
                // 重置状态
            case CBCentralManagerStateResetting:
            {
                // 更新状态
                currentCentralManagerState = bleCentralDelegateStateCentralManagerResetting;
                nCentralStateChange
                [self resetScanning];
                NSLog(@"CBCentralManagerStateResetting\n");
                break;
            }
        }
    }
}
// 中心设备检索外围设备
//-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals{}

// 中心设备连接检索到的外围设备
-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
    if ([activeCentralManager isEqual:central]) {
        for (CBPeripheral *aPeripheral in peripherals){
            [central connectPeripheral:aPeripheral options:nil];
        }
        // 更新状态
        currentCentralManagerState = bleCentralDelegateStateRetrieveConnectedPeripherals;
        nCentralStateChange
    }
}

// 中心设备扫描外围
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if ([activeCentralManager isEqual:central]) {
        NSData *macData = [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
        NSLog(@"macData:%@",macData);
        if (![macDataBack isEqualToData:macData]) {
            macDataBack = macData;
            
            BOOL checkout = [self checkPeripheralFromPeripheralPropertStroedArray:peripheral withmacData:macData];
            // 不是已存储设备
            if (checkout == NO) {
                // 未存储则添加到扫描列表
                NSDictionary *ad = [[NSDictionary alloc]initWithObjectsAndKeys:peripheral, kPeripheralKey, macData, kMacdataKey, nil];
                if (![ScanPeripheralArray containsObject:ad]) {
                    // 发现广播的设备则添加到扫描列表
                    [ScanPeripheralArray addObject:ad];
                    //NSLog(@"ScanPeripheralArray:%@",ScanPeripheralArray);
                }
            }
            // 更新状态
            currentCentralManagerState = bleCentralDelegateStateDiscoverPeripheral;
            nCentralStateChange
        }
    }
}

// 中心设备连接外围设备
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    if ([activeCentralManager isEqual:central]) {
        [self discoverPeripheralServices:peripheral];
        // 更新状态
        currentCentralManagerState = bleCentralDelegateStateConnectPeripheral;
        nCentralStateChange
    }
}

// 中心设备连接失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if ([activeCentralManager isEqual:central]) {
        [self removeConnectedPeripheral:peripheral];
    }
    // 更新状态
    currentCentralManagerState = bleCentralDelegateStateFailToConnectPeripheral;
    nCentralStateChange
}

// 中心设备断开连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if ([activeCentralManager isEqual:central]) {
        [self removeConnectedPeripheral:peripheral];
    }
    // 更新状态
    NSLog(@"domain:%@\nuserInfo:%@",error.domain, error.userInfo);
    currentCentralManagerState = bleCentralDelegateStateDisconnectPeripheral;
    nCentralStateChange
    
}

#pragma mark -
#pragma mark Set property
/****************************************************************************/
/*                              属性操作函数                                   */
/****************************************************************************/


/****************************************************************************/
/*                                  END                                     */
/****************************************************************************/
@end
