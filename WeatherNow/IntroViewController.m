//
//  IntroViewController.m
//  WeatherNow
//
//  Created by Larry Herb on 3/8/21.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

@synthesize mainView, brandBoxView, weatherNowTitleLabel, copyrightContainerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildLayout];
    
    // User Defaults Code will Go Here Later
    
}

- (void)buildLayout{
    //The Layout is Built Here
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.16 green:0.42 blue:0.67 alpha:1.0]];
    [mainView setBackgroundColor:[UIColor colorWithRed:0.16 green:0.42 blue:0.67 alpha:1.0]];
    
    //--- [Phone Status Bar] ---
    UIView * phoneStatusBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
    [phoneStatusBarBG setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:phoneStatusBarBG];
    
    //===================================
    //= TOP HALF
    //===================================
    // Brand Layout
    brandBoxFinalPosition = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, mainView.frame.size.width, (mainView.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)/2);
    brandBoxStartPosition= CGRectMake(brandBoxFinalPosition.size.width, brandBoxFinalPosition.origin.y, brandBoxFinalPosition.size.width, brandBoxFinalPosition.size.height);
    brandBoxView = [[UIView alloc] initWithFrame:brandBoxStartPosition];
    [mainView addSubview:brandBoxView];
    
    //Weather Now Logo
    UIImageView * weatherNowLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((brandBoxView.frame.size.width-200)/2, (brandBoxView.frame.size.height-245), 200, 175)];
    UIImage * weatherImage = [UIImage imageNamed:@"weather_launch_image.png"];
    [weatherNowLogoImageView setImage:weatherImage];
    [weatherNowLogoImageView setContentMode:UIViewContentModeScaleAspectFit];
    [brandBoxView addSubview:weatherNowLogoImageView];
    
    //Weather Now Text
    weatherNowTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, weatherNowLogoImageView.frame.size.height + weatherNowLogoImageView.frame.origin.y + 30, brandBoxView.frame.size.width - 60, 40)];
    [weatherNowTitleLabel setText:@"Weather Now!"];
    [weatherNowTitleLabel setTextColor:[UIColor whiteColor]];
    [weatherNowTitleLabel setAlpha:1.0];
    [weatherNowTitleLabel setFont:[UIFont systemFontOfSize:36.0f]];
    [weatherNowTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [brandBoxView addSubview:weatherNowTitleLabel];
    
    //===================================
    //= BOTTOM HALF
    //===================================
    //Copyright Container
    copyrightFinalPosition = CGRectMake(30, mainView.frame.size.height-60, mainView.frame.size.width-60, 60);
    copyrightStartPosition = CGRectMake(copyrightFinalPosition.origin.x, mainView.frame.size.height, copyrightFinalPosition.size.width, copyrightFinalPosition.size.height);
    copyrightContainerView = [[UIView alloc] initWithFrame:copyrightStartPosition];
    [mainView addSubview:copyrightContainerView];
    
    //Copyright Container White
    UIView * whiteBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, copyrightContainerView.frame.size.width, 1)];
    [whiteBorderView setAlpha:0.25];
    [whiteBorderView setBackgroundColor:[UIColor whiteColor]];
    [copyrightContainerView addSubview:whiteBorderView];
    
    //Copyright Text View
    UILabel * copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, copyrightContainerView.frame.size.width, copyrightContainerView.frame.size.height-1)];
    [copyrightLabel setText:@"Copyright 2021 Larry Herb"];
    [copyrightLabel setTextColor:[UIColor whiteColor]];
    [copyrightLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [copyrightLabel setTextAlignment:NSTextAlignmentCenter];
    [copyrightContainerView addSubview:copyrightLabel];
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
