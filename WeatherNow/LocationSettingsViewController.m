//
//  LocationSettingsViewController.m
//  WeatherNow
//
//  Created by Larry Herb on 3/8/21.
//

#import "LocationSettingsViewController.h"

@interface LocationSettingsViewController ()

@end

@implementation LocationSettingsViewController

@synthesize mainView, indicatorCurrentLocationLabel, indicatorTopLabel, locationTextboxContainerView, searchTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildLayout];
}

-(void) buildLayout {
    //The Layout is Built Here
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [mainView setBackgroundColor:[UIColor blackColor]];
    
    //--- [Phone Status Bar] ---
    UIView * phoneStatusBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
    [phoneStatusBarBG setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:phoneStatusBarBG];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    //Sets Light Themed Status Bar
    return UIStatusBarStyleLightContent;
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
