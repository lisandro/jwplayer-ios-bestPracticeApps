//
//  ViewController.m
//  DRMPlayer-ObjC
//
//  Created by David Almaguer on 06/08/21.
//

#import "ViewController.h"

static NSString *EZDRMLicenseAPIEndpoint = @"https://fps.ezdrm.com/api/licenses";
static NSString *EZDRMCertificateEndpoint = @"https://fps.ezdrm.com/demo/video/eleisure.cer";
static NSString *EZDRMVideoEndpoint = @"https://fps.ezdrm.com/demo/video/ezdrm.m3u8";

@interface ViewController () <JWDRMContentKeyDataSource>

@property (nonatomic, strong) NSString *contentUUID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up the player.
    [self setUpPlayer];
}

/**
 Sets up the player with a DRM configuration.
 */
- (void)setUpPlayer {
    NSURL *videoUrl = [NSURL URLWithString:EZDRMVideoEndpoint];

    // First, use the JWPlayerItemBuilder to create a JWPlayerItem that will be used by the player configuration.
    JWError *playerItemError;
    JWPlayerItemBuilder *playerItemBuilder = [[JWPlayerItemBuilder alloc] init];
    [playerItemBuilder file:videoUrl];
    JWPlayerItem *playerItem = [playerItemBuilder buildAndReturnError:&playerItemError];
    if (playerItemError != nil) {
        // Handle error
        return;
    }

    // Second, create a player config with the created JWPlayerItem.
    JWError *configError;
    JWPlayerConfigurationBuilder *configBuilder = [[JWPlayerConfigurationBuilder alloc] init];
    [configBuilder playlist:@[playerItem]];
    JWPlayerConfiguration *config = [configBuilder buildAndReturnError:&configError];
    if (configError != nil) {
        // Handle error
        return;
    }

    // Third, set the DRM data source class.
    self.player.contentKeyDataSource = self;

    // Lastly, use the created JWPlayerConfiguration to set up the player.
    [self.player configurePlayerWith:config];
}

#pragma mark - JWDRMContentKeyDataSource

/**
 When called, this delegate method requests the identifier for the protected content to be passed through the delegate method's completion block.
 */
- (void)appIdentifierForURL:(NSURL * _Nonnull)url completionHandler:(void (^ _Nonnull)(NSData * _Nullable))handler {
    NSString *contentUUID = @"content-uuid";
    NSData *uuidData = [contentUUID dataUsingEncoding:NSUTF8StringEncoding];
    handler(uuidData);
}

/**
 When called, this delegate method requests an Application Certificate binary which must be passed through the completion
 @Note The Application Certificate must be encoded with the X.509 standard with distinguished encoding rules (DER). It is obtained when registering an FPS playback app with Apple, by supplying an X.509 Certificate Signing Request linked to your private key.
 */
- (void)contentIdentifierForURL:(NSURL * _Nonnull)url completionHandler:(void (^ _Nonnull)(NSData * _Nullable))handler {
    NSURL *certURL = [NSURL URLWithString:EZDRMCertificateEndpoint];
    NSData *certData = [NSData dataWithContentsOfURL:certURL];
    handler(certData);
}

/**
 When the key request is ready, this delegate method provides the key request data (SPC - Server Playback Context message) needed to retrieve the Content Key Context (CKC) message from your key server. The CKC message must be returned via the completion block under the response parameter.

 After your app sends the request to the server, the FPS code on the server sends the required key to the app. This key is wrapped in an encrypted message. Your app provides the encrypted message to the JWPlayerKit. The JWPlayerKit unwraps the message and decrypts the stream to enable playback on an iOS device.

 @Note For resources that may expire, specify a renewal date and the content-type in the completion block.
 */
- (void)contentKeyWithSPCData:(NSData * _Nonnull)spcData completionHandler:(void (^ _Nonnull)(NSData * _Nullable, NSDate * _Nullable, NSString * _Nullable))handler {
    NSTimeInterval currentTime = [[NSDate alloc] timeIntervalSince1970];
    NSString *spcProcessURL = [EZDRMLicenseAPIEndpoint stringByAppendingFormat:@"/%@?p1=%li", self.contentUUID, (NSInteger)currentTime];
    NSMutableURLRequest *ckcRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:spcProcessURL]];
    [ckcRequest setHTTPMethod:@"POST"];
    [ckcRequest setHTTPBody:spcData];
    [ckcRequest addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:ckcRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error != nil || (httpResponse != nil && httpResponse.statusCode != 200)) {
            handler(nil, nil, nil);
            return;
        }

        handler(data, nil, nil);
    }] resume];
}

@end
