//
//  IntroViewController.h
//  WeatherNow
//
//  Created by Larry Herb on 3/8/21.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntroViewController : UIViewController{
    
    // Main Window
    IBOutlet UIView * mainView;
    
    // Animation Positions
    CGRect brandBoxStartPosition;
    CGRect brandBoxFinalPosition;
    CGRect copyrightStartPosition;
    CGRect copyrightFinalPosition;
    
    //UI Elements
    UIView * brandBoxView;
    UILabel * weatherNowTitleLabel;
    UIView * copyrightContainerView;
    
}

@property (nonatomic, retain) IBOutlet UIView * mainView;
@property (nonatomic, retain) UIView * brandBoxView;
@property (nonatomic, retain) UILabel * weatherNowTitleLabel;
@property (nonatomic, retain) UIView * copyrightContainerView;

@end

NS_ASSUME_NONNULL_END
