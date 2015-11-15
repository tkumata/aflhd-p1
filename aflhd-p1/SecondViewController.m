//
//  SecondViewController.m
//  aflhd-p1
//
//  Created by KUMATA Tomokatsu on 11/11/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"
#import "recipeVC.h"

@interface SecondViewController ()
{
    UILabel *recipeList;
    int screenWidth, screenHeight;
    
    UIButton *recipeButton1;
    UIButton *recipeButton2;
    UIButton *recipeButton3;
    
    UIButton *backButton;
}

@end

@implementation SecondViewController

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
    
    // ingredients label
    recipeList = [[UILabel alloc] init];
    recipeList.tag = 11;
    recipeList.frame = CGRectMake(0, 20, screenWidth, 60);
    recipeList.textAlignment = NSTextAlignmentCenter;
    recipeList.numberOfLines = 2;
    recipeList.text = [NSString stringWithFormat:@"%@ のレシピ一覧", _arg];
    [self.view addSubview:recipeList];
    
    // back button
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.tag = 12;
    backButton.frame = CGRectMake(10, 20, 50, 60);
    [backButton setTitle:[NSString stringWithFormat:@"戻る"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // dummy table view
    recipeButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recipeButton1.tag = 21;
    recipeButton1.frame = CGRectMake(0, 80, screenWidth, 60);
    [[recipeButton1 layer] setBorderWidth:1.0];
    [[recipeButton1 layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [recipeButton1 setTitle:[NSString stringWithFormat:@"%@ の料理 1", _arg] forState:UIControlStateNormal];
    [recipeButton1 addTarget:self action:@selector(toRecipeVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recipeButton1];
    
    recipeButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recipeButton2.tag = 22;
    recipeButton2.frame = CGRectMake(0, 150, screenWidth, 60);
    [[recipeButton2 layer] setBorderWidth:1.0];
    [[recipeButton2 layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [recipeButton2 setTitle:[NSString stringWithFormat:@"%@ の料理 2", _arg] forState:UIControlStateNormal];
    [recipeButton2 addTarget:self action:@selector(toRecipeVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recipeButton2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - move to recipe View

- (void)toRecipeVC:(UIButton*)button {
    recipeVC *recipeV = [[recipeVC alloc] init];
    recipeV.arg = _arg;
    [self presentViewController:recipeV animated:YES completion:nil];
}

#pragma mark - Back

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
