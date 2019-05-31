//
//  JWCastingViewController.m
//  JWBestPracticeApps
//
//  Created by Karim Mourra on 3/16/16.
//  Copyright © 2016 Karim Mourra. All rights reserved.
//

#import "JWCastingViewController.h"
#import <GoogleCast/GoogleCast.h>

@interface JWCastingViewController ()<UIActionSheetDelegate>

@property (nonatomic) UIButton *castingButton;
@property (nonatomic) UIBarButtonItem *castingItem;
@property (nonatomic) BOOL casting;

@end

@implementation JWCastingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor =[UIColor grayColor];
    [self setUpCastController];
}

- (void)setUpCastController
{
    self.castController = [[JWCastController alloc]initWithPlayer:self.player];
    self.castController.chromeCastReceiverAppID = kGCKDefaultMediaReceiverApplicationID;
    self.castController.delegate = self;
    [self.castController scanForDevices];
}

#pragma Mark - Casting delegate methods

-(void)onCastingDevicesAvailable:(NSArray *)devices
{
    self.availableDevices = devices;
    if(devices.count > 0 && !self.castingItem) {
        [self setUpCastingButton];
        [self updateForCastDeviceDisconnection];
    } else if(devices.count == 0) {
        self.navigationItem.rightBarButtonItems = nil;
    }
}

-(void)onConnectedToCastingDevice:(JWCastingDevice *)device
{
    [self updateForCastDeviceConnection];
}

-(void)onDisconnectedFromCastingDevice:(NSError *)error
{
    [self updateForCastDeviceDisconnection];
}

-(void)onConnectionTemporarilySuspended
{
    [self updateWhenConnectingToCastDevice];
}

-(void)onConnectionRecovered
{
    [self updateForCastDeviceConnection];
}

-(void)onConnectionFailed:(NSError *)error
{
    if(error) {
        NSLog(@"Connection Error: %@", error);
    }
    [self updateForCastDeviceDisconnection];
}

-(void)onCasting
{
    [self updateForCasting];
}

-(void)onCastingEnded:(NSError *)error
{
    if(error) {
        NSLog(@"Casting Error: %@", error);
    }
    [self updateForCastingEnd];
}

-(void)onCastingFailed:(NSError *)error
{
    if(error) {
        NSLog(@"Casting Error: %@", error);
    }
    [self updateForCastingEnd];
}

#pragma Mark - Casting Status Helpers

- (void)updateWhenConnectingToCastDevice
{
    [self.castingButton setTintColor:[UIColor whiteColor]];
    [self.castingButton.imageView startAnimating];
}

- (void)updateForCastDeviceConnection
{
    [self.castingButton.imageView stopAnimating];
    [self.castingButton setImage:[[UIImage imageNamed:@"cast_on"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                        forState:UIControlStateNormal];
    [self.castingButton setTintColor:[UIColor blueColor]];
}

- (void)updateForCastDeviceDisconnection
{
    [self.castingButton.imageView stopAnimating];
    [self.castingButton setImage:[[UIImage imageNamed:@"cast_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                        forState:UIControlStateNormal];
    [self.castingButton setTintColor:[UIColor whiteColor]];
}

- (void)updateForCasting
{
    self.casting = YES;
    [self.castingButton setTintColor:[UIColor greenColor]];
}

- (void)updateForCastingEnd
{
    self.casting = NO;
    [self.castingButton setTintColor:[UIColor blueColor]];
}

#pragma Mark - Cast Button

- (void)setUpCastingButton
{
    CGRect castingButtonFrame = CGRectMake(0, 0, 22, 22);
    self.castingButton = [[UIButton alloc]initWithFrame:castingButtonFrame];
    [self.castingButton addTarget:self action:@selector(castButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self prepareCastingButtonAnimation];
    self.castingItem = [[UIBarButtonItem alloc] initWithCustomView:self.castingButton];
    self.navigationItem.rightBarButtonItem = self.castingItem;
}

- (void)prepareCastingButtonAnimation
{
    NSArray *connectingImages = @[[[UIImage imageNamed:@"cast_connecting0"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],
                                  [[UIImage imageNamed:@"cast_connecting1"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],
                                  [[UIImage imageNamed:@"cast_connecting2"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],
                                  [[UIImage imageNamed:@"cast_connecting1"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    self.castingButton.imageView.animationImages = connectingImages;
    self.castingButton.imageView.animationDuration = 2;
}

- (void)castButtonTapped
{
    __weak JWCastingViewController *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.barButtonItem = self.castingItem;
    
    if (self.castController.connectedDevice == nil) {
        alertController.title = @"Connect to";
        
        [self.castController.availableDevices enumerateObjectsUsingBlock:^(JWCastingDevice  *_Nonnull device, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *deviceSelected = [UIAlertAction actionWithTitle:device.name
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                       [weakSelf.castController connectToDevice:device];
                                                                       [weakSelf updateWhenConnectingToCastDevice];
                                                                   }];
            [alertController addAction:deviceSelected];
        }];
    } else {
        alertController.title = self.castController.connectedDevice.name;
        alertController.message = @"Select an action";
        
        UIAlertAction *disconnect = [UIAlertAction actionWithTitle:@"Disconnect"
                                                             style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [weakSelf.castController disconnect];
                                                           }];
        [alertController addAction:disconnect];
        
        UIAlertAction *castControl;
        if (self.casting) {
            castControl = [UIAlertAction actionWithTitle:@"Stop Casting"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [weakSelf.castController stopCasting];
                                                 }];
        } else {
            castControl = [UIAlertAction actionWithTitle:@"Cast"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [weakSelf.castController cast];
                                                 }];
        }
        [alertController addAction:castControl];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                            style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

@end
