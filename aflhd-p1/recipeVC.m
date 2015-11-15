//
//  recipeVC.m
//  aflhd-p1
//
//  Created by KUMATA Tomokatsu on 11/15/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import "recipeVC.h"

@interface recipeVC () {
    int screenWidth, screenHeight;
    UILabel *recipeNameLabel;
    UIWebView *recipeDetailWV;
    UIButton *backButton;
}

@end

@implementation recipeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
    
    recipeNameLabel = [[UILabel alloc] init];
    recipeNameLabel.tag = 11;
    recipeNameLabel.frame = CGRectMake(0, 20, screenWidth, 60);
    recipeNameLabel.textAlignment = NSTextAlignmentCenter;
    recipeNameLabel.numberOfLines = 2;
    recipeNameLabel.text = [NSString stringWithFormat:@"%@ のレシピ", _arg];
    [self.view addSubview:recipeNameLabel];
    
    // back button
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.tag = 12;
    backButton.frame = CGRectMake(10, 20, 50, 60);
    [backButton setTitle:[NSString stringWithFormat:@"戻る"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    recipeDetailWV = [[UIWebView alloc] init];
    recipeDetailWV.delegate = self;
    recipeDetailWV.tag = 21;
    recipeDetailWV.frame = CGRectMake(0, 80, screenWidth, screenHeight-80);
    [self.view addSubview:recipeDetailWV];
    NSURL *url = [NSURL URLWithString:@"http://cookpad.com/recipe/2204111"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [recipeDetailWV loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
