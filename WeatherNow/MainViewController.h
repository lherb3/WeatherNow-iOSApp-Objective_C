//
//  ViewController.h
//  WeatherNow
//
//  Created by Larry Herb on 3/7/21.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController{
    // Main Window
    IBOutlet UIView * mainView;
    
    UIView * blackOverlayView;
    UIView * locationContainerView;
    NSMutableArray * currentConditionsLabelArray;
    NSMutableArray * currentConditionsLabelContainerArray;
    UILabel * locationNameLabel;
    UILabel * currentTemperatureLabel;
    UILabel * currentConditionsDescLabel;
    UIImageView * weatherConditionIcon;
    //currentWeatherObject
    NSString * openWeatherMapAPIKey; //Register for an API Key Here: https://openweathermap.org/api/
}

@property (nonatomic, retain) IBOutlet UIView * mainView;
@property (nonatomic, retain) UIView * blackOverlayView;
@property (nonatomic, retain) NSMutableArray * currentConditionsLabelArray;
@property (nonatomic, retain) NSMutableArray * currentConditionsLabelContainerArray;
@property (nonatomic, retain) UILabel * locationNameLabel;
@property (nonatomic, retain) UILabel * currentTemperatureLabel;
@property (nonatomic, retain) UILabel * currentConditionsDescLabel;
@property (nonatomic, retain) UIImageView * weatherConditionIcon;
// current weather object
@property (nonatomic, retain) NSString * openWeatherMapAPIKey;

@end
