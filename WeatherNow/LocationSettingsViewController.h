//
//  LocationSettingsViewController.h
//  WeatherNow
//
//  Created by Larry Herb on 3/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationSettingsViewController : UIViewController <UITextFieldDelegate>{
    // Main Window
    IBOutlet UIView * mainView;
    UIView * locationTextboxContainerView;
    UILabel * indicatorCurrentLocationLabel;
    UILabel * indicatorTopLabel;
    UITextField * searchTextField;
}

@property (nonatomic, retain) IBOutlet UIView * mainView;
@property (nonatomic, retain) UIView * locationTextboxContainerView;
@property (nonatomic, retain) UILabel * indicatorCurrentLocationLabel;
@property (nonatomic, retain) UILabel * indicatorTopLabel;
@property (nonatomic, retain) UITextField * searchTextField;

@end

NS_ASSUME_NONNULL_END
