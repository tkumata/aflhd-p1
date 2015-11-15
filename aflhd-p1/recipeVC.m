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
    UIWebView *recipeDetail;
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
    recipeNameLabel.tag = 3;
    recipeNameLabel.frame = CGRectMake(0, 0, screenWidth, 40);
    recipeNameLabel.textAlignment = NSTextAlignmentCenter;
    recipeNameLabel.numberOfLines = 2;
    recipeNameLabel.text = [NSString stringWithFormat:@"%@ のレシピ", _arg];
    [self.view addSubview:recipeNameLabel];
    
    recipeDetail = [[UIWebView alloc] init];
    recipeDetail.delegate = self;
    recipeDetail.tag = 1;
    recipeDetail.frame = CGRectMake(0, 40, screenWidth, screenHeight-40);
    [self.view addSubview:recipeDetail];
    NSURL *url = [NSURL URLWithString:@"http://cookpad.com/recipe/2204111"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [recipeDetail loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
