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
    recipeList.tag = 3;
    recipeList.frame = CGRectMake(0, 40, screenWidth, 40);
    [[recipeList layer] setBorderWidth:1.0];
    [[recipeList layer] setCornerRadius:5.0];
    [[recipeList layer] setBorderColor:[[UIColor grayColor] CGColor]];
    recipeList.textAlignment = NSTextAlignmentCenter;
    recipeList.numberOfLines = 2;
    recipeList.text = [NSString stringWithFormat:@"%@ のレシピ一覧", _arg];
    [self.view addSubview:recipeList];
    
    // dummy table view
    recipeButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recipeButton1.tag = 1;
    recipeButton1.frame = CGRectMake(0, 90, screenWidth, 60);
    [[recipeButton1 layer] setBorderWidth:1.0];
    [[recipeButton1 layer] setCornerRadius:5.0];
    [[recipeButton1 layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [recipeButton1 setTitle:[NSString stringWithFormat:@"%@ の料理1", _arg] forState:UIControlStateNormal];
    [recipeButton1 addTarget:self action:@selector(toRecipeVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recipeButton1];
    
    recipeButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recipeButton2.tag = 2;
    recipeButton2.frame = CGRectMake(0, 160, screenWidth, 60);
    [[recipeButton2 layer] setBorderWidth:1.0];
    [[recipeButton2 layer] setCornerRadius:5.0];
    [[recipeButton2 layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [recipeButton2 setTitle:[NSString stringWithFormat:@"%@ の料理2", _arg] forState:UIControlStateNormal];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
