//
//  ViewController.m
//  aflhd-p1
//
//  Created by KUMATA Tomokatsu on 11/10/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate>
{
    BOOL isConnected;
    UIButton *peeringButton;
    
    UILabel *shokuzaiKouho;
    UIButton *reloadButton;
    UIButton *sendButton;
    UILabel *voteResult;
    UILabel *reciepButtonLabel;
    
    NSMutableArray *shokuzai;
    NSArray *foodSeed;
    NSArray *foodSeed2;
}

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // MARK: Init
//    [self clearScreenSubviews];
    isConnected = NO;
    
    foodSeed = @[@"こんにゃく", @"こんぶ", @"だいこん", @"じゃが芋", @"たろ芋", @"さと芋", @"トマト", @"玉ネギ", @"長ネギ", @"エシャロット", @"ピーマン", @"にんじん", @"きゅうり", @"なす", @"しいたけ", @"鶏肉", @"豚肉", @"牛肉", @"セロリ", @"カリフラワー", @"ブロッコリー", @"ベビーコーン", @"わらび", @"チンゲンサイ", @"からし菜", @"あした葉", @"アーティチョーク", @"クウシンサイ", @"かぼちゃ", @"そら豆", @"えんどう豆", @"だだ茶豆", @"しめじ", @"キャベツ", @"ほうれん草", @"アジ", @"サンマ", @"マグロ", @"サバ"];
    
    foodSeed2 = @[@"蒟蒻", @"昆布", @"大根", @"馬鈴薯", @"里芋", @"赤茄子", @"玉葱", @"長葱", @"人参", @"キャロット", @"胡瓜", @"茄子", @"花椰菜", @"芽花椰菜", @"蕨", @"青梗菜", @"芥子菜", @"明日葉", @"空芯菜", @"南瓜", @"蚕豆", @"豌豆豆", @"湿地", @"甘藍", @"菠薐草", @"鰯", @"秋刀魚", @"鮪", @"鯖"];
    
    // MARK: Setup some parts
    // reload button
    reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reloadButton.tag = 1;
    reloadButton.frame = CGRectMake(20, 210, 280, 40);
    [[reloadButton layer] setBorderWidth:1.0];
    [[reloadButton layer] setCornerRadius:5.0];
    [[reloadButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [reloadButton setTitle:@"食材候補を変更する" forState:UIControlStateNormal];
    
    // send button
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.tag = 2;
    sendButton.frame = CGRectMake(20, 280, 280, 40);
    [[sendButton layer] setBorderWidth:1.0];
    [[sendButton layer] setCornerRadius:5.0];
    [[sendButton layer] setBorderColor:[[UIColor redColor] CGColor]];
    [sendButton setTitle:@"食材候補をおいしいウォッチへ送信する" forState:UIControlStateNormal];
    
    // ingredients label
    shokuzaiKouho = [[UILabel alloc] init];
    shokuzaiKouho.tag = 3;
    shokuzaiKouho.frame = CGRectMake(20, 40, 280, 160);
    [[shokuzaiKouho layer] setBorderWidth:2.0];
    [[shokuzaiKouho layer] setCornerRadius:5.0];
    [[shokuzaiKouho layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    shokuzaiKouho.textAlignment = NSTextAlignmentCenter;
    shokuzaiKouho.numberOfLines = 6;
    
    // vore result label
    voteResult = [[UILabel alloc] init];
    voteResult.tag = 4;
    voteResult.frame = CGRectMake(20, 40, 280, 160);
    [[voteResult layer] setBorderWidth:2.0];
    [[voteResult layer] setCornerRadius:5.0];
    [[voteResult layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    voteResult.textAlignment = NSTextAlignmentCenter;
    voteResult.numberOfLines = 6;
    
    // reciep button
    reciepButtonLabel = [[UILabel alloc] init];
    reciepButtonLabel.tag = 5;
    reciepButtonLabel.frame = CGRectMake(20, 220, 280, 40);
    [[reciepButtonLabel layer] setBorderWidth:1.0];
    [[reciepButtonLabel layer] setCornerRadius:5.0];
    [[reciepButtonLabel layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    reciepButtonLabel.textAlignment = NSTextAlignmentCenter;
    reciepButtonLabel.numberOfLines = 1;
    
    // peering button color
    peeringButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    peeringButton.tag = 101;
    peeringButton.frame = CGRectMake(20, 548, 180, 40);
    [[peeringButton layer] setBorderWidth:1.0];
    [[peeringButton layer] setCornerRadius:5.0];
    [[peeringButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [peeringButton setTitle:@"おいしいウォッチを探す" forState:UIControlStateNormal];
    // tap peering button
    [peeringButton addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:peeringButton];
    
    // MARK: Bluetooth Advertise
    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"owatch" session:self.mySession];
    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"owatch" discoveryInfo:nil session:self.mySession];
    
    self.browserVC.delegate = self;
    self.mySession.delegate = self;
    [self.advertiser start];
    
    // MARK: hoge
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self makeScreenShokuzaiKouho];
}

#pragma mark Reload food ingredients
- (void)reloadFood {
    if (isConnected == YES) {
        dispatch_async(dispatch_get_main_queue(),^{
            int i;
            [[self.view viewWithTag:3] removeFromSuperview];
            shokuzai = [[NSMutableArray array] init];
            
            for (i = 0; i < 3; i++) {
                NSUInteger randomIndex = arc4random() % [foodSeed count];
                NSString *tmp = [foodSeed objectAtIndex:randomIndex];
                [shokuzai addObject:tmp];
            }
            
            shokuzaiKouho.text = [NSString stringWithFormat:@"%@\n%@\n%@\n", shokuzai[0], shokuzai[1], shokuzai[2]];
            [self.view addSubview:shokuzaiKouho];
        });
    } else {
        [[self.view viewWithTag:3] removeFromSuperview];
    }
}

#pragma mark Send message to peer device
- (void)sendData {
    // Convert to NSData
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:shokuzai];
    
    // Send data to connected peer
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
}

#pragma mark Make screen 食材候補
- (void)makeScreenShokuzaiKouho {
    if (isConnected == YES) {
        [self clearScreenSubviews];
        [self reloadFood];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [reloadButton addTarget:self action:@selector(reloadFood) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:reloadButton];
            
            [sendButton addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:sendButton];
        });
    } else {
        [[self.view viewWithTag:1] removeFromSuperview];
        [[self.view viewWithTag:2] removeFromSuperview];
    }
}

- (void)clearScreenSubviews {
    dispatch_async(dispatch_get_main_queue(),^{
        [[self.view viewWithTag:1] removeFromSuperview];
        [[self.view viewWithTag:2] removeFromSuperview];
        [[self.view viewWithTag:3] removeFromSuperview];
        [[self.view viewWithTag:4] removeFromSuperview];
        [[self.view viewWithTag:5] removeFromSuperview];
    });
}

//- (void)makeScreenVoteResult {
//    
//}

#pragma mark Bluetooth peering button
//- (IBAction)peeringButton:(id)sender {
//}

- (void) showBrowserVC {
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

//
- (void) dismissBrowserVC {
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserVC];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserVC];
}

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        isConnected = YES;
        [self makeScreenShokuzaiKouho];
    } else {
        isConnected = NO;
        [self clearScreenSubviews];
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    [self clearScreenSubviews];
    
    // append message to text box on main thread
    dispatch_async(dispatch_get_main_queue(),^{
        //  Decode data back to NSString
        NSString *tmp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        voteResult.text = [NSString stringWithFormat:@"「%@」が選ばれました。", tmp];;
        [self.view addSubview:voteResult];
        
        reciepButtonLabel.text = @"この食材を使ったレシピ一覧 (予定)";
        [self.view addSubview:reciepButtonLabel];
    });
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
}

#pragma mark Second View?

@end
