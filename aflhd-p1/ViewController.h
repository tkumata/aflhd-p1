//
//  ViewController.h
//  aflhd-p1
//
//  Created by KUMATA Tomokatsu on 11/10/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//- (IBAction)peeringButton:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *peeringButtonLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)segmentControl:(id)sender;

@property (nonatomic, strong) UIViewController *secondVC;
@property (nonatomic, strong) NSString *dismissKeyword;

@end

