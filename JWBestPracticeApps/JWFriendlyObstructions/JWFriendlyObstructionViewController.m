//
//  JWFriendlyObstructionViewController.m
//  JWFriendlyObstructions
//
//  Created by karim on 5/13/19.
//  Copyright © 2019 Karim Mourra. All rights reserved.
//

#import "JWFriendlyObstructionViewController.h"

#define sampleAdTag @"https://pubads.g.doubleclick.net/gampad/ads?iu=/124319096/external/omid_google_samples&env=vp&gdfp_req=1&output=vast&sz=640x480&description_url=http%3A%2F%2Ftest_site.com%2Fhomepage&tfcd=0&npa=0&vpmute=0&vpa=0&vad_format=linear&url=http%3A%2F%2Ftest_site.com&vpos=preroll&unviewed_position_start=1&correlator="

#define playIconName @"play-button.png"
#define pauseIconName @"pause-button.png"

@interface JWFriendlyObstructionViewController ()

@property (nonatomic) UIButton *playbackToggle;

@end

@implementation JWFriendlyObstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player.delegate = self;
    self.playbackToggle = [UIButton new];
    self.playbackToggle.frame = CGRectMake(100, 100, 100, 100);
    [self.playbackToggle setImage:[UIImage imageNamed:playIconName] forState:UIControlStateNormal];
    //[[UIImageView alloc]initWithImage:[UIImage imageNamed:playIconName]];
    [self.player.view addSubview:self.playbackToggle];
    
    [self.player.experimentalAPI registerFriendlyAdObstruction:self.playbackToggle];
    
}

- (JWConfig *)createConfig
{
    JWConfig *config = [super createConfig];
    config.controls = NO;
    
    JWAdConfig *advertising = [JWAdConfig new];
    advertising.client = JWAdClientGoogima;
    advertising.schedule = @[[JWAdBreak adBreakWithTag:sampleAdTag offset:@"10"]];
    
    config.advertising = advertising;
    
    return config;
}

- (void)addCustomControl
{
    
}

- (void)registerFriendlyObstruction
{
    
}

#pragma Mark - Player Delegate methods

- (void)onPlay:(JWEvent<JWStateChangeEvent> *)event
{
    
}

- (void)onPause:(JWEvent<JWStateChangeEvent> *)event
{
    
}

- (void)onAdPlay:(JWAdEvent<JWAdStateChangeEvent> *)event
{
    
}

- (void)onAdPause:(JWAdEvent<JWAdStateChangeEvent> *)event
{
    
}

@end
