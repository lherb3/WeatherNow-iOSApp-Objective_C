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

@synthesize mainView, blackOverlayView, currentConditionsDescLabel, currentConditionsLabelArray, currentConditionsLabelContainerArray, currentTemperatureLabel, locationNameLabel, openWeatherMapAPIKey, weatherConditionIcon, currentWeatherObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    //Begin by Loading the Location
    
    [mainView setAlpha:0.0];
    [self loadLocation];
}

-(void) displayLoadError{
    //Display an Error
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //Load Next Screen
        UIAlertController * alert = [UIAlertController
            alertControllerWithTitle:NSLocalizedString(@"mainView_loadCity_errorMessage_title", @"Error Title")
            message:NSLocalizedString(@"mainView_loadCity_errorMessage", @"Load City Error Message")
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"mainView_loadCity_errorMessage_okButton", @"OK Button") style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {
                NSLog(@"OK Button Pressed");
                [self performSegueWithIdentifier:@"locationSettings_segue" sender:self];
            }]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

-(void)loadLocation{
    //Load the Location via URL Session Data Task
    
    openWeatherMapAPIKey = [NSString stringWithFormat:@"%@", @"API_KEY_HERE"];
    NSString * languageCode = [NSString stringWithFormat:@"%@", [[NSLocale currentLocale] languageCode]];
    
    [locationNameLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"locationName"]];
    NSString * urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"https://api.openweathermap.org/data/2.5/weather?q=", [[[NSUserDefaults standardUserDefaults] objectForKey:@"locationName"] stringByReplacingOccurrencesOfString:@" " withString:@"+"], @"&appid=", openWeatherMapAPIKey, @"&lang=", languageCode];
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"Mozilla/4.0 (compatible; MSIE 5.23; Mac_PowerPC)" forHTTPHeaderField:@"User-Agent"];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            //Error Has Occured
            [self displayLoadError];
        }else{
            if(data==nil){
                //No Data Was returned
                [self displayLoadError];
            }else{
                NSError * jsonError = nil;
                NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if(!json){
                    //JSON is not a Valid Object
                    NSLog(@"Error: JSON Format cannot be parsed");
                    [self displayLoadError];
                }else{
                    //JSON is a Valid Object
                    
                    self->currentWeatherObject = [[CurrentWeatherObject alloc] init:json];
                    [self addDataToInterface];
                }
                
            }
        }
    }];
    [task resume];
}

-(double)convertKelvinToF:(double)originalValue{
    //Converts Kelvin Temperature to Fahrenheit
    
    double convertedValue = 0.0;
    convertedValue = originalValue*9/5-459.67;
    return convertedValue;
}

-(void)addDataToInterface{
    //Adds the Information to the UI Screen
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //Dispatch AJAX QUEUE
        if(self->currentWeatherObject->httpCode==200){
            //Everything is good url wise
            
            //Update Temperature
            NSString * tempString = [NSString stringWithFormat:@"%.0f", [self convertKelvinToF:self->currentWeatherObject->weatherOverview->temperatureKelvin]];
            [self->currentTemperatureLabel setText:[NSString stringWithFormat:@"%@°", tempString]];
            
            //Add Conditions Description Strings
            NSString * currentConditions = [NSString stringWithFormat:@""];
            int conditionPosition = 0;
            for (NSDictionary *condition in self->currentWeatherObject->weatherConditionsArray){
                NSString * startComma = [NSString stringWithFormat:@", "];
                if(conditionPosition==0){
                    //Add A Blank Start Comma and Load first Image Icon for Conditions
                    startComma = [NSString stringWithFormat:@""];
                    
                    //Create URL and Initate a HTTP Download Image Task
                    NSString * iconURL = [NSString stringWithFormat:@"%@%@%@", @"https://openweathermap.org/img/w/", [condition objectForKey:@"icon"], @".png"];
                    dispatch_async(dispatch_get_global_queue(0,0), ^{
                        NSURLSessionTask * downloadImageTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:iconURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                            if(data==nil){
                                NSLog(@"Error No Data");
                                return;
                            }else{
                                UIImage * image = [UIImage imageWithData:data];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self->weatherConditionIcon setImage:image];
                                    [self->weatherConditionIcon setAlpha:1.0];
                                });
                            }
                        }];
                        [downloadImageTask resume];
                    });
                }
                currentConditions = [NSString stringWithFormat:@"%@%@%@", currentConditions, startComma, [condition objectForKey:@"main"]];
                conditionPosition = conditionPosition + 1;
            }
            [self->currentConditionsDescLabel setText:currentConditions];
            
            //Add Humidity String
            [[self->currentConditionsLabelArray objectAtIndex:0] setText:[NSString stringWithFormat:@"%@ %@ %d%@", NSLocalizedString(@"mainView_currentConditions_humidityLabel", @"Humidity Label"), @": ", self->currentWeatherObject->weatherOverview->humidity, @"%"]];
            
            //Add Wind Info
            NSString * degreesString = [NSString stringWithFormat:@"%.1f", self->currentWeatherObject->wind->degrees];
            [[self->currentConditionsLabelArray objectAtIndex:1] setText:[NSString stringWithFormat:@"%@ %@ %.1f %@ %@ %@%@", NSLocalizedString(@"mainView_currentConditions_windLabel", @"Wind Label"), @": ", self->currentWeatherObject->wind->speed, NSLocalizedString(@"mainView_CurrentConditions_metersPerSecondLabel", @"Meters Per Second Label"), @"@", degreesString, @"°"]];
            
            //Add Pressure Info
            [[self->currentConditionsLabelArray objectAtIndex:2] setText:[NSString stringWithFormat:@"%@ %@ %d %@", NSLocalizedString(@"mainView_currentConditions_pressureLabel", @"Pressure Label"), @": ", self->currentWeatherObject->weatherOverview->pressure, @"mb"]];
            
            //Add Min Temperature Info
            [[self->currentConditionsLabelArray objectAtIndex:3] setText:[NSString stringWithFormat:@"%@ %@ %0.0f%@", NSLocalizedString(@"mainView_currentConditions_minLabel", @"Min Temp Label"), @": ", [self convertKelvinToF:self->currentWeatherObject->weatherOverview->temperatureKelvinMin], @"°"]];
            
            //Add Max Temperature Info
            [[self->currentConditionsLabelArray objectAtIndex:4] setText:[NSString stringWithFormat:@"%@ %@ %0.0f%@", NSLocalizedString(@"mainView_currentConditions_maxLabel", @"Max Temp Label"), @": ", [self convertKelvinToF:self->currentWeatherObject->weatherOverview->temperatureKelvinMax], @"°"]];
            
            //Update Temperature
            [self animateInterfaceIn];
        }else{
            [self displayLoadError];
        }
    });
}

-(void) animateInterfaceIn{
    //Visual Effect for Loading the Interface In
    
    //Async Wrapper Needed Here
    [currentTemperatureLabel setAlpha:0.0];
    [currentTemperatureLabel setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
    [mainView setTransform:CGAffineTransformMakeScale(1.25, 1.25)];
    [mainView setAlpha:0.0];
    [weatherConditionIcon setAlpha:0.0];
    
    for (int i = 0; i <5; i++){
        [[self->currentConditionsLabelContainerArray objectAtIndex:i] setAlpha:0.0];
    }
    
    //Current Conditions Item Here set to 0.0 alpha
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
         animations:^{
            [self->mainView setAlpha:1.0];
            [self->mainView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
         }
         completion:^(BOOL finished){
            //Done Animating
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                 animations:^{
                    [self->currentTemperatureLabel setAlpha:1.0];
                    [self->currentTemperatureLabel setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                 }
                 completion:^(BOOL finished){
                    for (int i = 0; i <5; i++){
                        [UIView animateWithDuration:0.25 delay:0.25*i options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                [[self->currentConditionsLabelContainerArray objectAtIndex:i] setAlpha:1.0];
                             }
                             completion:^(BOOL finished){
                                //Done Animated
                            }
                         ];
                    }
                }
             ];
        }
     ];
}

- (void) buildLayout{
    //The Layout is Built Here
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.16 green:0.42 blue:0.67 alpha:1.0]];
    [mainView setBackgroundColor:[UIColor colorWithRed:0.16 green:0.42 blue:0.67 alpha:1.0]];
    
    //--- [Phone Status Bar] ---
    UIView * phoneStatusBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
    [phoneStatusBarBG setBackgroundColor:[UIColor blackColor]];
    [phoneStatusBarBG setAlpha:0.25];
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
    
    
    //Conditions Item View
    currentConditionsLabelArray = [[NSMutableArray alloc] init];
    currentConditionsLabelContainerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <5; i++){
        //Create 5 items
        UIView * conditionsItemView = [self generateCurrentConditionsInformation:i:conditionsContainer];
        [conditionsContainer addSubview:conditionsItemView];
    }
}

-(IBAction)locationbtnAction:(id)sender{
    //The Button Has Been Selected
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
         animations:^{
            [self->locationContainerView setTransform:CGAffineTransformMakeScale(0.90, 0.90)];
         }
         completion:^(BOOL finished){
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                 animations:^{
                    [self->locationContainerView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                 }
                 completion:^(BOOL finished){
                    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                            [self->mainView setAlpha:0.0];
                            [self.view setBackgroundColor:[UIColor blackColor]];
                         }
                         completion:^(BOOL finished){
                            //Segue Activated
                            [self performSegueWithIdentifier:@"locationSettings_segue" sender:self];
                            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                    [self->mainView setAlpha:1.0];
                                    [self.view setBackgroundColor:[UIColor colorWithRed:0.16 green:0.42 blue:0.67 alpha:1.0]];
                                 }
                                 completion:nil
                             ];
                        }
                     ];
                }
             ];
         }
     ];
}

-(UIView *)generateCurrentConditionsInformation:(int)position :(UIView *)parentView{
    //Generate A Current Conditions Information View
    
    UIView * generatedConditionsItemView = [[UIView alloc] initWithFrame:CGRectMake(0, position*40, parentView.frame.size.width, 40)];
    
    UIView * whiteBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, generatedConditionsItemView.frame.size.height-4, generatedConditionsItemView.frame.size.width, 1)];
    [whiteBorderView setBackgroundColor:[UIColor whiteColor]];
    [whiteBorderView setAlpha:0.25f];
    [generatedConditionsItemView addSubview:whiteBorderView];
    
    UILabel * currentConditionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, generatedConditionsItemView.frame.size.width, generatedConditionsItemView.frame.size.height-5)];
    [currentConditionsLabel setText:@"Loading..."];
    [currentConditionsLabel setTextColor:[UIColor whiteColor]];
    [currentConditionsLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [currentConditionsLabel setTextAlignment:NSTextAlignmentLeft];
    [generatedConditionsItemView addSubview:currentConditionsLabel];
    [currentConditionsLabelArray addObject:currentConditionsLabel];
    [currentConditionsLabelContainerArray addObject:generatedConditionsItemView];
    
    return generatedConditionsItemView;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    //Sets Light Themed Status Bar
    return UIStatusBarStyleLightContent;
}


@end
