//
//  Radar.h
//  finder
//
//  Created by Ignacio Garcia on 13-3-18.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//



//==============================================

#import <UIKit/UIKit.h>
#import "finderAppDelegate.h"

@interface Radar : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>


@property(nonatomic ,strong) IBOutlet UITableView *listView;
@property(nonatomic ,strong) UIProgressView       *backProgress;
@property(nonatomic ,strong) UISlider *sliderView;
@property(nonatomic , strong)     UISwitch    *switchView;





@property (nonatomic) blePeripheral *currentPeripheral;
@property (readwrite) BOOL  backMainViewController;
/////////////////////////////////////////////////////////
//                       CUSTOM                        //
/////////////////////////////////////////////////////////

@property (weak, nonatomic) IBOutlet UIView *contenedor;
@property (weak, nonatomic) IBOutlet UILabel *tituloPersonalizar;


- (IBAction)enabelAntilostWorkEventSegmentedControl:(UISegmentedControl *)sender ;
- (IBAction)chooseRingToneButtonEvent:(UIButton *)sender ;

@property (weak, nonatomic) IBOutlet UIProgressView *distanciaActual;
@property (weak, nonatomic) IBOutlet UIProgressView *distanciaAviso;



@end