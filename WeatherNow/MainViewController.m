//
//  ViewController.m
//  WeatherNow
//
//  Created by Larry Herb on 3/7/21.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize mainView, blackOverlayView, currentConditionsDescLabel, currentConditionsLabelArray, currentConditionsLabelContainerArray, currentTemperatureLabel, locationNameLabel, openWeatherMapAPIKey, weatherConditionIcon;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildLayout];
}

- (void) buildLayout{
    //The Layout is Built Here
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.16 green:0.42 blue:0.67 alpha:1.0]];
    [mainView setBackgroundColor:[UIColor colorWithRed:0.16 green:0.42 blue:0.67 alpha:1.0]];
    
    //--- [Phone Status Bar] ---
    UIView * phoneStatusBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
    [phoneStatusBarBG setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:phoneStatusBarBG];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    //Sets Light Themed Status Bar
    return UIStatusBarStyleLightContent;
}


@end
