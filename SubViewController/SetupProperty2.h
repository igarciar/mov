//
//  SetupProperty.h
//  finder
//
//  Created by David ding on 13-3-18.
//  Copyright (c) 2013年 David ding. All rights reserved.
//

// 消息通知
//==============================================
// 发送消息
#define nSetupPropertyFromScanPeripherialToFinder   [[NSNotificationCenter defaultCenter]postNotificationName:@"CBSetupPropertyFromScanPeripherialToFinder"  object:nil];
// 接收消息
#define nCBSetupPropertyFromScanPeripherialToFinder [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBSetupPropertyFromScanPeripherialToFinder) name:@"CBSetupPropertyFromScanPeripherialToFinder" object:nil];

// 发送消息
#define nFinishSetupProperty    [[NSNotificationCenter defaultCenter]postNotificationName:@"nCBFinishSetupProperty"  object:nil];
// 接收消息
#define nCBFinishSetupProperty  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBFinishSetupProperty) name:@"nCBFinishSetupProperty" object:nil];

//==============================================

#import <UIKit/UIKit.h>
#import "finderAppDelegate.h"

@interface SetupProperty : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>


@property(nonatomic ,strong) IBOutlet UITableView *listView;
@property(nonatomic ,strong) IBOutlet UIButton    *hideKeyBoradBtn;
@property(nonatomic ,strong) UIProgressView       *backProgress;
@property(nonatomic ,strong) UISlider *sliderView;
@property(nonatomic , strong)     UISwitch    *switchView;

@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UIButton *pickerShowOrHideBtn;


- (IBAction)finishButtonEvent:(UIButton *)sender;
- (IBAction)chooseImageButtonEvent:(UIButton *)sender;
- (IBAction)backgroundEvent:(id)sender;
- (IBAction)enabelAntilostWorkEvent:(UISwitch *)sender;
- (IBAction)autosetButtonEvent:(UIButton *)sender;
- (IBAction)toogleRssiValueSliderEvent:(UISlider *)sender;


@property (nonatomic) blePeripheral *currentPeripheral;
@property (readwrite) BOOL  backMainViewController;


/////////////////////////////////////////////////////////
//                       CUSTOM                        //
/////////////////////////////////////////////////////////

@property (weak, nonatomic) IBOutlet UIView *contenedor;
@property (weak, nonatomic) IBOutlet UILabel *tituloPersonalizar;
@property (weak, nonatomic) IBOutlet UIButton *imagen;
@property (weak, nonatomic) IBOutlet UITextField *nombre;
@property (weak, nonatomic) IBOutlet UISegmentedControl *onOff;

- (IBAction)enabelAntilostWorkEventSegmentedControl:(UISegmentedControl *)sender ;
- (IBAction)chooseRingToneButtonEvent:(UIButton *)sender ;

@property (weak, nonatomic) IBOutlet UIProgressView *distanciaActual;
@property (weak, nonatomic) IBOutlet UISlider *distanciaAviso;


@property (weak, nonatomic) IBOutlet UIButton *tono;

@property (weak, nonatomic) IBOutlet UIPickerView *alarmasList;

@end

@interface Item : NSObject   //第四个cell中的数据

@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *detail;
@end