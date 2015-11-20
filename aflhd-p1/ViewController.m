//
//  ViewController.m
//  aflhd-p1
//
//  Created by KUMATA Tomokatsu on 11/10/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate>
{
    BOOL isConnected;
    UIButton *peeringButton;
    
    UILabel *shokuzaiKouho;
    UIButton *reloadShokuzaiButton;
    UIButton *sendShokuzaiButton;
    UILabel *voteResult;
    UIButton *recipeButton;
    NSString *selectedIngredient;
    
    NSMutableArray *shokuzai;
    NSArray *foodSeed;
    NSArray *foodSeed2;
    
    UIButton *sendKansouButton;
    UIButton *reloadKansouButton;
    NSArray *kansouSeed;
    NSMutableArray *kansou;
    UILabel *kansouLabel;
    
    int screenWidth, screenHeight;
}

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@end

@implementation ViewController
@synthesize segment;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // MARK: Init
    isConnected = NO;
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
    
    foodSeed = @[@"カレー", @"ハンバーグ", @"グラタン", @"スパゲッティ", @"シチュー", @"こんにゃく", @"こんぶ", @"だいこん", @"じゃが芋", @"たろ芋", @"さと芋", @"トマト", @"玉ネギ", @"長ネギ", @"エシャロット", @"ピーマン", @"にんじん", @"きゅうり", @"なす", @"しいたけ", @"鶏肉", @"豚肉", @"牛肉", @"セロリ", @"カリフラワー", @"ブロッコリー", @"ベビーコーン", @"わらび", @"チンゲンサイ", @"からし菜", @"あした葉", @"アーティチョーク", @"クウシンサイ", @"かぼちゃ", @"そら豆", @"えんどう豆", @"だだ茶豆", @"しめじ", @"キャベツ", @"ほうれん草", @"イワシ", @"アジ", @"サンマ", @"マグロ", @"サバ"];
    
    kansouSeed = @[@"びっくりした", @"おいしかった", @"また食べたい", @"同じ食材で他のが食べてみたい", @"ごちそうさま", @"ありがとう"];
    
    foodSeed2 = @[@"蒟蒻", @"昆布", @"大根", @"馬鈴薯", @"里芋", @"赤茄子", @"玉葱", @"長葱", @"人参", @"キャロット", @"胡瓜", @"茄子", @"花椰菜", @"芽花椰菜", @"蕨", @"青梗菜", @"芥子菜", @"明日葉", @"空芯菜", @"南瓜", @"蚕豆", @"豌豆豆", @"湿地", @"甘藍", @"菠薐草", @"鰯", @"秋刀魚", @"鮪", @"鯖"];
    
    // MARK: Setup some parts
    // ingredients label
    shokuzaiKouho = [[UILabel alloc] init];
    shokuzaiKouho.tag = 3;
    shokuzaiKouho.frame = CGRectMake(20, 70, screenWidth-40, 160);
    [[shokuzaiKouho layer] setBorderWidth:1.0];
    [[shokuzaiKouho layer] setCornerRadius:5.0];
    [[shokuzaiKouho layer] setBorderColor:[[UIColor grayColor] CGColor]];
    shokuzaiKouho.textAlignment = NSTextAlignmentCenter;
    shokuzaiKouho.numberOfLines = 6;
    
    // reload button
    reloadShokuzaiButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reloadShokuzaiButton.tag = 1;
    reloadShokuzaiButton.frame = CGRectMake(20, 240, screenWidth-40, 40);
    [[reloadShokuzaiButton layer] setBorderWidth:1.0];
    [[reloadShokuzaiButton layer] setCornerRadius:5.0];
    [[reloadShokuzaiButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [reloadShokuzaiButton setTitle:@"食材候補を変更する" forState:UIControlStateNormal];
    
    // send button
    sendShokuzaiButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendShokuzaiButton.tag = 2;
    sendShokuzaiButton.frame = CGRectMake(20, 310, screenWidth-40, 40);
    [[sendShokuzaiButton layer] setBorderWidth:1.0];
    [[sendShokuzaiButton layer] setCornerRadius:5.0];
    [[sendShokuzaiButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [sendShokuzaiButton setTitle:@"食材候補をおいしいウォッチへ送信する" forState:UIControlStateNormal];
    
    // vore result label
    voteResult = [[UILabel alloc] init];
    voteResult.tag = 4;
    voteResult.frame = CGRectMake(20, 70, screenWidth-40, 160);
    [[voteResult layer] setBorderWidth:1.0];
    [[voteResult layer] setCornerRadius:5.0];
    [[voteResult layer] setBorderColor:[[UIColor grayColor] CGColor]];
    voteResult.textAlignment = NSTextAlignmentCenter;
    voteResult.numberOfLines = 6;
    
    // recipe button
    recipeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recipeButton.tag = 5;
    recipeButton.frame = CGRectMake(20, 250, screenWidth-40, 40);
    [[recipeButton layer] setBorderWidth:1.0];
    [[recipeButton layer] setCornerRadius:5.0];
    [[recipeButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [recipeButton setTitle:@"この食材を使ったレシピ一覧" forState:UIControlStateNormal];
    // tap peering button
    [recipeButton addTarget:self action:@selector(toSecondVC:) forControlEvents:UIControlEventTouchUpInside];
    
    // ingredients label
    kansouLabel = [[UILabel alloc] init];
    kansouLabel.tag = 8;
    kansouLabel.frame = CGRectMake(20, 70, screenWidth-40, 160);
    [[kansouLabel layer] setBorderWidth:1.0];
    [[kansouLabel layer] setCornerRadius:5.0];
    [[kansouLabel layer] setBorderColor:[[UIColor grayColor] CGColor]];
    kansouLabel.textAlignment = NSTextAlignmentCenter;
    kansouLabel.numberOfLines = 6;

    // reload kansou button
    reloadKansouButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reloadKansouButton.tag = 6;
    reloadKansouButton.frame = CGRectMake(20, 240, screenWidth-40, 40);
    [[reloadKansouButton layer] setBorderWidth:1.0];
    [[reloadKansouButton layer] setCornerRadius:5.0];
    [[reloadKansouButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [reloadKansouButton setTitle:@"感想候補を変更する" forState:UIControlStateNormal];

    // send kansou button
    sendKansouButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendKansouButton.tag = 7;
    sendKansouButton.frame = CGRectMake(20, 310, screenWidth-40, 40);
    [[sendKansouButton layer] setBorderWidth:1.0];
    [[sendKansouButton layer] setCornerRadius:5.0];
    [[sendKansouButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [sendKansouButton setTitle:@"感想候補をおいしいウォッチへ送信する" forState:UIControlStateNormal];
    
    // peering button color
    peeringButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    peeringButton.tag = 101;
    peeringButton.frame = CGRectMake(20, screenHeight-70, screenWidth-40, 40);
    [[peeringButton layer] setBorderWidth:1.0];
    [[peeringButton layer] setCornerRadius:5.0];
    [[peeringButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [peeringButton setTitle:@"おいしいウォッチを探す" forState:UIControlStateNormal];
    [peeringButton addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:peeringButton];
    
    // MARK: Bluetooth Advertise Screen
    // Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    // Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    
    // Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"owatch" session:self.mySession];
    
    // Setup Advertiser
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
    
//    if ([_dismissKeyword isEqualToString:@"back1"]) {
//        NSLog(@"aaa");
//    } else {
//        [self makeScreenShokuzaiKouho];
////        [self makeScreenKansouKouho];
//    }
}

#pragma mark - Reload food ingredients

- (void)reloadFood {
    if (isConnected == YES) {
        dispatch_async(dispatch_get_main_queue(),^{
            [[self.view viewWithTag:3] removeFromSuperview];
            shokuzai = [[NSMutableArray array] init];
            
            int a[3];
            int x;
            for (int l = 0; l < 3; l++) {
                a[l] = arc4random_uniform((int)[foodSeed count]);
                x = a[l];
                for (l = 0; l < 3; l++) {
                    if (a[l] == x) break;
                }
            }
            [shokuzai addObject:[foodSeed objectAtIndex:a[0]]];
            [shokuzai addObject:[foodSeed objectAtIndex:a[1]]];
            [shokuzai addObject:[foodSeed objectAtIndex:a[2]]];
            [shokuzai addObject:@"__shokuzai__"];
            
            shokuzaiKouho.text = [NSString stringWithFormat:@"%@\n%@\n%@", shokuzai[0], shokuzai[1], shokuzai[2]];
            [self.view addSubview:shokuzaiKouho];
        });
    } else {
        [[self.view viewWithTag:3] removeFromSuperview];
    }
}

#pragma mark - Send message to peer device

- (void)sendData {
    // Convert to NSData
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:shokuzai];
    
    // Send data to connected peer
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
}

- (void)sendKansouData {
    // Convert to NSData
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:kansou];
    
    // Send data to connected peer
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
}

#pragma mark - Make screen 食材候補

- (void)makeScreenShokuzaiKouho {
    if (isConnected == YES) {
        [self clearScreenSubviews];
        [self reloadFood];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [reloadShokuzaiButton addTarget:self action:@selector(reloadFood) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:reloadShokuzaiButton];
            
            [sendShokuzaiButton addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:sendShokuzaiButton];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(),^{
            [[self.view viewWithTag:1] removeFromSuperview];
            [[self.view viewWithTag:2] removeFromSuperview];
        });
    }
}

//- (void)clearScreenSubviews {
//    dispatch_async(dispatch_get_main_queue(),^{
//        for (UIView *v in self.view.subviews) {
//            [v removeFromSuperview];
//        }
//    });
//}
- (void)clearScreenSubviews {
    dispatch_async(dispatch_get_main_queue(),^{
        [[self.view viewWithTag:1] removeFromSuperview];
        [[self.view viewWithTag:2] removeFromSuperview];
        [[self.view viewWithTag:3] removeFromSuperview];
        [[self.view viewWithTag:4] removeFromSuperview];
        [[self.view viewWithTag:5] removeFromSuperview];
        [[self.view viewWithTag:6] removeFromSuperview];
        [[self.view viewWithTag:7] removeFromSuperview];
        [[self.view viewWithTag:8] removeFromSuperview];
    });
}

#pragma mark - 食後の画面

- (void)makeScreenKansouKouho {
    if (isConnected == YES) {
        [self clearScreenSubviews];
        [self reloadKansou];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [reloadKansouButton addTarget:self action:@selector(reloadKansou) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:reloadKansouButton];
            
            [sendKansouButton addTarget:self action:@selector(sendKansouData) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:sendKansouButton];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(),^{
            [[self.view viewWithTag:6] removeFromSuperview];
            [[self.view viewWithTag:7] removeFromSuperview];
        });
    }
}

- (void)reloadKansou {
    if (isConnected == YES) {
        dispatch_async(dispatch_get_main_queue(),^{
            [[self.view viewWithTag:3] removeFromSuperview];
            kansou = [[NSMutableArray array] init];
            
            int a[3];
            int x;
            for (int l = 0; l < 3; l++) {
                a[l] = arc4random_uniform((int)[kansouSeed count]);
                x = a[l];
                for (l = 0; l < 3; l++) {
                    if (a[l] == x) break;
                }
            }
            [kansou addObject:[kansouSeed objectAtIndex:a[0]]];
            [kansou addObject:[kansouSeed objectAtIndex:a[1]]];
            [kansou addObject:[kansouSeed objectAtIndex:a[2]]];
            [kansou addObject:@"__kansou__"];
            
            kansouLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", kansou[0], kansou[1], kansou[2]];
            [self.view addSubview:kansouLabel];
        });
    } else {
        [[self.view viewWithTag:3] removeFromSuperview];
    }
}

#pragma mark - Bluetooth peering button

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
        if (segment.selectedSegmentIndex == 0) {
            [self makeScreenShokuzaiKouho];
        } else {
            [self makeScreenKansouKouho];
        }
    } else {
        isConnected = NO;
        [self clearScreenSubviews];
    }
}

// MARK: 食材候補選択結果の受信
// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    [self clearScreenSubviews];
    
    // append message to text box on main thread
    dispatch_async(dispatch_get_main_queue(),^{
        if (segment.selectedSegmentIndex == 0) {
            // Decode data back to NSString
            selectedIngredient = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            // 投票結果ラベル
            voteResult.text = [NSString stringWithFormat:@"「%@」が選ばれました。", selectedIngredient];
            [self.view addSubview:voteResult];
            // レシピ一覧画面遷移ボタン
            [self.view addSubview:recipeButton];
        } else {
            // Decode data back to NSString
            selectedIngredient = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            // 投票結果ラベル
            voteResult.text = [NSString stringWithFormat:@"「%@」", selectedIngredient];
            [self.view addSubview:voteResult];
        }
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

#pragma mark - Second View

- (void)toSecondVC:(UIButton*)button {
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.arg = selectedIngredient;
    [self presentViewController:secondVC animated:YES completion:nil];
}

- (IBAction)segmentControl:(id)sender {
    if (segment.selectedSegmentIndex == 0) {
        [self makeScreenShokuzaiKouho];
    } else {
        [self makeScreenKansouKouho];
    }
}
@end
