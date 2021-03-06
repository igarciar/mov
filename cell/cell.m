//
//  iPadCell.m
//  testiPadCell
//
//  Created by Ignacio Garcia on 13-1-14.
//  Copyright (c) 2016 Ignacio Garcia. All rights reserved.
//

#import "cell.h"
#import "Radar.h"
#import "finderAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation cell{
    NSTimer     *flashFindkeyTimer;
}

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        self.onOffBUttons.tintColor = [UIColor lightGrayColor];
        self.onOffBUttons.layer.cornerRadius=0;
    }
    
    return self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    nCBCentralStateChange
    nCBTxRssi
    // Configure the view for the selected state
}

-(void)refreshCurrentShow {
    [self.onOffBUttons setSelectedSegmentIndex:_currentPeripheral.enabelAlarmTimer?0:1];
    [self CBCentralStateChange];
}

- (IBAction)enabelAntilostWorkEvent:(UISegmentedControl *)sender {
    
    BOOL state=sender.selectedSegmentIndex==0;

    [_currentPeripheral setEnabelAlarmTimer:state];
    [_currentPeripheral setEnabelAntilostWork:state];
    
    [_parent savePerifical];
    
    NSLog(@"setEnabelAlarmTimer.on:%d",state);
    
}


- (IBAction)FindKeyPressedEvent:(UIButton *)sender {
    if (_currentPeripheral.enabelFlashLabel == YES) {
        if (flashFindkeyTimer != nil) {
            [flashFindkeyTimer invalidate];
            flashFindkeyTimer = nil;
            _NameLabel.hidden = NO;
        }
        _currentPeripheral.enabelFlashLabel= NO;
        _currentPeripheral.cv.alarmSoundState = kStopAlarmState;
        [_currentPeripheral sendControlValueEvent];
        [_currentPeripheral setEnabelAntilostWork:NO];
    }
    else{
        //NSLog(@"currentPeripheral:%@",currentPeripheral);
        if (_currentPeripheral.cv.alarmSoundState != kStopAlarmState) {
            _currentPeripheral.cv.alarmSoundState = kStopAlarmState;
            [_currentPeripheral sendControlValueEvent];
        }
        else{
            _currentPeripheral.cv.alarmSoundState = kWarningValueState;
            [_currentPeripheral sendControlValueEvent];
        }
    }
}

-(void)setCurrentPeripheral:(blePeripheral *)CP{
    _currentPeripheral = CP;
    [self CBCentralStateChange];
}

-(void)CBTxRssi{
    [self CBCentralStateChange];
}

-(void)CBCentralStateChange{
    _NameLabel.text = _currentPeripheral.nameString;
    
    
    _OnOffAntilostLabel.text = [[NSString alloc]initWithFormat:@"ON:%d:%02d OFF:%d:%02d",_currentPeripheral.timerOnHour, _currentPeripheral.timerOnMinute, _currentPeripheral.timerOffHour, _currentPeripheral.timerOffMinute];
    _OnOffAntilostLabel.hidden = _currentPeripheral.enabelAlarmTimer^YES;
    
    _antilostWorkImageView.hidden = YES;
    
    if (_currentPeripheral.connectedFinish == YES) {
        if (_currentPeripheral.cv.EnabelAntilostWork == YES) {
            _antilostWorkImageView.hidden = NO;
        }
        
        if (_currentPeripheral.enabelFlashLight == YES) {
            [_flashImageView setImage:[UIImage imageNamed:@"flash.png"]];
        }
        else{
             [_flashImageView setImage:[UIImage imageNamed:@"flash_black.png"]];
        }
        
        if (_currentPeripheral.enabelVibrate == YES) {
            [_vibrateImageView setImage:[UIImage imageNamed:@"vibrate.png"]];
        }
        else{
            [_vibrateImageView setImage:[UIImage imageNamed:@"vibrate_balck.png"]];
        }
        
        if (_currentPeripheral.enabelPushMsg == YES) {
            [_msgImageView setImage:[UIImage imageNamed:@"msg.png"]];
        }
        else{
            [_msgImageView setImage:[UIImage imageNamed:@"msg_black.png"]];
        }
        
        if (_currentPeripheral.enabelMute == YES) {
            [_muteImageView setImage:[UIImage imageNamed:@"mute.png"]];
        }
        else{
            [_muteImageView setImage:[UIImage imageNamed:@"mute_black.png"]];
        }
        
        if (_currentPeripheral.currentBattery >= 0 && _currentPeripheral.currentBattery < 20) {
            [_BatteryImageView setImage:[UIImage imageNamed:@"BT0.png"]];
        }
        else if (_currentPeripheral.currentBattery >= 20 && _currentPeripheral.currentBattery < 50){
            [_BatteryImageView setImage:[UIImage imageNamed:@"BT1.png"]];
        }
        else if (_currentPeripheral.currentBattery >= 50 && _currentPeripheral.currentBattery < 80){
            [_BatteryImageView setImage:[UIImage imageNamed:@"BT2.png"]];
        }
        else{
            [_BatteryImageView setImage:[UIImage imageNamed:@"BT3.png"]];
        }
        
        if      (_currentPeripheral.currentTxRssi > 0  && _currentPeripheral.currentTxRssi <= 55){
            [_RssiImageView setImage:[UIImage imageNamed:@"Rssi4.png"]];
        }
        else if (_currentPeripheral.currentTxRssi > 55 && _currentPeripheral.currentTxRssi <= 65){
            [_RssiImageView setImage:[UIImage imageNamed:@"Rssi3.png"]];
        }
        else if (_currentPeripheral.currentTxRssi > 65 && _currentPeripheral.currentTxRssi <= 75){
            [_RssiImageView setImage:[UIImage imageNamed:@"Rssi2.png"]];
        }
        else if (_currentPeripheral.currentTxRssi > 75 && _currentPeripheral.currentTxRssi <= 85) {
            [_RssiImageView setImage:[UIImage imageNamed:@"Rssi1.png"]];
        }
        else{
            [_RssiImageView setImage:[UIImage imageNamed:@"Rssi0.png"]];
        }
        
    }
    else{
        
        [_flashImageView setImage:[UIImage imageNamed:@"flash_black.png"]];
        
        [_vibrateImageView setImage:[UIImage imageNamed:@"vibrate_balck.png"]];
        
        [_msgImageView setImage:[UIImage imageNamed:@"msg_black.png"]];
        
        [_muteImageView setImage:[UIImage imageNamed:@"mute_black.png"]];
        
        [_BatteryImageView setImage:[UIImage imageNamed:@"BT_black.png"]];
        
        [_RssiImageView setImage:[UIImage imageNamed:@"Rssi_black.png"]];
        
    }
    //NSLog(@"_currentPeripheral.choosePicture:%@",_currentPeripheral.choosePicture);
    _FindKeyButton.layer.borderWidth = 1.0;
    _FindKeyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;

    
    if (_currentPeripheral.choosePicture != nil) {
        [_imagen2 setImage:_currentPeripheral.choosePicture];
    }else{
        [_imagen2 setImage:[UIImage imageNamed:@"bolso_amarillo.png"]];
    }
    
    if (_currentPeripheral.enabelFlashLabel == YES) {
        if (flashFindkeyTimer == nil) {
            flashFindkeyTimer = [NSTimer scheduledTimerWithTimeInterval:0.33f target:self selector:@selector(flashFindkeyEvent) userInfo:nil repeats:YES];
        }
    }else{
        if (flashFindkeyTimer != nil) {
            [flashFindkeyTimer invalidate];
            flashFindkeyTimer = nil;
            _NameLabel.hidden = NO;
        }
    }
    

   
}

-(void)flashFindkeyEvent{
    if (_NameLabel.hidden == YES) {
        _NameLabel.hidden = NO;
    }
    else{
        _NameLabel.hidden = YES;
    }
}

- (IBAction)radarButtonEvent:(UIButton *)sender
{
    
    Radar *svc;//
    
    // 4寸
    svc = [[Radar alloc]initWithNibName:@"Radar" bundle:nil];
    
    
    svc.currentPeripheral = _currentPeripheral;
    svc.backMainViewController = YES;
    //    [AddObjects ViewControllerTransition:self presentModalVC:svc duration:DurationTime withTyte:kCATransitionPush andSubtype:kCATransitionFromTop];
    //[self setHidesBottomBarWhenPushed:YES];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    //[self.parent  presentViewController: svc animated:NO completion:nil];
    [self.parent.navigationController pushViewController:svc animated:YES];

}


@end
