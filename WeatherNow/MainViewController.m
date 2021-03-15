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
    //[mainView setAlpha:0.0];
    
    //--- [Phone Status Bar] ---
    UIView * phoneStatusBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
    [phoneStatusBarBG setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:phoneStatusBarBG];
    
    //===================================
    //= TOP HALF
    //===================================
    
    UIView * topHalfView = [[UIView alloc] initWithFrame:CGRectMake(15, [UIApplication sharedApplication].statusBarFrame.size.height, mainView.frame.size.width-30, ((mainView.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)/2))];
    [mainView addSubview:topHalfView];
    
    //-----------------------------------
    //- Location Selector
    //-----------------------------------
    locationContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, topHalfView.frame.size.width, 60)];
    [topHalfView addSubview:locationContainerView];
    
    UIImageView * locationIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    UIImage * locationIconImage = [UIImage imageNamed:@"location_icon.png"];
    [locationIconImageView setImage:locationIconImage];
    [locationIconImageView setContentMode:UIViewContentModeScaleAspectFit];
    [locationContainerView addSubview:locationIconImageView];
    
    UIView * locationSelectorWhiteBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, locationContainerView.frame.size.height-4, locationContainerView.frame.size.width, 4)];
    [locationSelectorWhiteBorderView setBackgroundColor:[UIColor whiteColor]];
    [locationContainerView addSubview:locationSelectorWhiteBorderView];
    
    locationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, (locationContainerView.frame.size.height-20)/2, locationContainerView.frame.size.width, 20)];
    [locationNameLabel setText:@"Loading..."];
    [locationNameLabel setTextColor:[UIColor whiteColor]];
    [locationNameLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [locationNameLabel setTextAlignment:NSTextAlignmentLeft];
    [locationContainerView addSubview:locationNameLabel];
    
    UIButton * buttonOverlay = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, locationContainerView.frame.size.width, locationContainerView.frame.size.height)];
    [buttonOverlay addTarget:self action:@selector(locationbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [locationContainerView addSubview:buttonOverlay];
    
    //-----------------------------------
    //- Temperature Code
    //-----------------------------------
    
    //Temperature Container
    UIView * temperatureContainer = [[UIView alloc] initWithFrame:CGRectMake(0, locationContainerView.frame.origin.y+locationContainerView.frame.size.height, locationContainerView.frame.size.width, (topHalfView.frame.size.height-locationContainerView.frame.size.height)-30)];
    [topHalfView addSubview:temperatureContainer];
    
    //Current Temp Text
    currentTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, temperatureContainer.frame.size.width, (temperatureContainer.frame.size.height/3)*2)];
    [currentTemperatureLabel setText:@"-°"];
    [currentTemperatureLabel setTextColor:[UIColor whiteColor]];
    [currentTemperatureLabel setTextAlignment:NSTextAlignmentCenter];
    [currentTemperatureLabel setFont:[UIFont systemFontOfSize:80.0f]];
    [temperatureContainer addSubview:currentTemperatureLabel];
    
    UIView * currentConditionsSummaryView = [[UIView alloc] initWithFrame:CGRectMake(0, currentTemperatureLabel.frame.origin.y+currentTemperatureLabel.frame.size.height, temperatureContainer.frame.size.width, (temperatureContainer.frame.size.height/3)*1)];
    [temperatureContainer addSubview:currentConditionsSummaryView];
    
    //Weather Condition Icon
    weatherConditionIcon = [[UIImageView alloc] initWithFrame:CGRectMake((currentConditionsSummaryView.frame.size.width-40)/2, 0, 40, currentConditionsSummaryView.frame.size.height/2)];
    UIImage * weatherConditionIconImage = [UIImage imageNamed:@"location_icon.png"]; // http://openweathermap.org/img/w/10n.png
    [weatherConditionIcon setImage:weatherConditionIconImage];
    [weatherConditionIcon setContentMode:UIViewContentModeScaleAspectFit];
    [currentConditionsSummaryView addSubview:weatherConditionIcon];
    
    //Current Conditions Desc Text
    currentConditionsDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentConditionsSummaryView.frame.size.height/2, temperatureContainer.frame.size.width, currentConditionsSummaryView.frame.size.height/2)];
    [currentConditionsDescLabel setText:@"Loading..."];
    [currentConditionsDescLabel setTextColor:[UIColor whiteColor]];
    [currentConditionsDescLabel setTextAlignment:NSTextAlignmentCenter];
    [currentConditionsDescLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [currentConditionsSummaryView addSubview:currentConditionsDescLabel];
    
    //===================================
    //= BOTTOM HALF
    //===================================
    UIView * bottomHalfView = [[UIView alloc] initWithFrame:CGRectMake(15, topHalfView.frame.origin.y + topHalfView.frame.size.height, mainView.frame.size.width - 30, ((mainView.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)/2)-15)];
    [mainView addSubview:bottomHalfView];
    
    UIView * currentConditionsHeaderContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomHalfView.frame.size.width, 60)];
    [bottomHalfView addSubview:currentConditionsHeaderContainerView];
    
    UIView * whiteBorderCurrentConditionsView = [[UIView alloc] initWithFrame:CGRectMake(0, currentConditionsHeaderContainerView.frame.size.height-4, currentConditionsHeaderContainerView.frame.size.width, 2)];
    [whiteBorderCurrentConditionsView setBackgroundColor:[UIColor whiteColor]];
    [currentConditionsHeaderContainerView addSubview:whiteBorderCurrentConditionsView];
    
    UILabel * currentConditionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (locationContainerView.frame.size.height-20)/2, locationContainerView.frame.size.width, 20)];
    [currentConditionsLabel setText:NSLocalizedString(@"mainView_currentConditions_titleLabel", @"Current Condition Header Label")];
    [currentConditionsLabel setTextColor:[UIColor whiteColor]];
    [currentConditionsLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [currentConditionsLabel setTextAlignment:NSTextAlignmentLeft];
    [currentConditionsHeaderContainerView addSubview:currentConditionsLabel];
    
    UIView * conditionsContainer = [[UIView alloc] initWithFrame:CGRectMake(0, currentConditionsHeaderContainerView.frame.origin.y + currentConditionsHeaderContainerView.frame.size.height, bottomHalfView.frame.size.width, ((mainView.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)/2)-15)];
    [bottomHalfView addSubview:conditionsContainer];
    
    //Conditins Item View (add code Later)
    
}

-(IBAction)locationbtnAction:(id)sender{
    //The Button Has Been Selected
    [self performSegueWithIdentifier:@"locationSettings_segue" sender:self];
    NSLog(@"Location Button Tested");
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    //Sets Light Themed Status Bar
    return UIStatusBarStyleLightContent;
}


@end
