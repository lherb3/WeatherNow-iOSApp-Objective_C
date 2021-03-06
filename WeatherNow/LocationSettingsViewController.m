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

-(void)viewWillAppear:(BOOL)animated{
    //View is about to appear
    [self animateInterfaceIn];
}

-(void)validateTextEntry{
    //Validate Text Entry
    [searchTextField resignFirstResponder];
    if([searchTextField.text length]==0){
        //Empty Textbox
        UIAlertController * alert = [UIAlertController
            alertControllerWithTitle:NSLocalizedString(@"locationSettingsView_popupMessage_enterCityTitle", @"Please Enter A City Title")
            message:NSLocalizedString(@"locationSettingsView_popupMessage_enterCity", @"Enter City Name")
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"locationSettingsView_popupMessage_okBtn", @"OK Button") style:UIAlertActionStyleDefault
            handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        //Text Box Has Text
        [[NSUserDefaults standardUserDefaults] setValue:searchTextField.text forKey:@"locationName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self closeScreen];
    }
}

-(void)closeScreen{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
         animations:^{
            [self->mainView setAlpha:0.0];
         }
         completion:^(BOOL finished){
            //Done Animating
            [self dismissViewControllerAnimated:NO completion:nil];
        }
     ];
}

-(void)animateInterfaceIn{
    //Visual Effect for Loading the Interface In
    [indicatorTopLabel setAlpha:0.0];
    [indicatorCurrentLocationLabel setAlpha:0.0];
    [indicatorCurrentLocationLabel setTransform:CGAffineTransformMakeScale(1.25, 1.25)];
    [locationTextboxContainerView setAlpha:0.0];
    [mainView setAlpha:1.0];
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
         animations:^{
            [self->indicatorTopLabel setAlpha:1.0];
         }
         completion:^(BOOL finished){
            [UIView animateWithDuration:0.75 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                 animations:^{
                    [self->indicatorCurrentLocationLabel setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                    [self->indicatorCurrentLocationLabel setAlpha:1.0];
                 }
                 completion:^(BOOL finished){
                    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                            [self->locationTextboxContainerView setAlpha:1.0];
                         }
                         completion:nil
                     ];
                
                }
             ];
        
        }
     ];
}

-(void) buildLayout {
    //The Layout is Built Here
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [mainView setBackgroundColor:[UIColor blackColor]];
    [mainView setAlpha:0.0];
    
    //--- [Phone Status Bar] ---
    UIView * phoneStatusBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
    [phoneStatusBarBG setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:phoneStatusBarBG];
    
    //===================================
    //= TOP HALF
    //===================================
    
    //High Level Information Container
    UIView * topHalfView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, mainView.frame.size.width, ((mainView.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)/2))];
    [mainView addSubview:topHalfView];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    [backButton setTitle:NSLocalizedString(@"locationSettingsView_backBtn", @"Back Button Text") forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [backButton addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topHalfView addSubview:backButton];
    
    //-----------------------------------
    //- Location Textbox Container
    //-----------------------------------
    //Location Container
    locationTextboxContainerView = [[UIView alloc] initWithFrame:CGRectMake(15, topHalfView.frame.size.height-60, topHalfView.frame.size.width-30, 60)];
    [topHalfView addSubview:locationTextboxContainerView];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, locationTextboxContainerView.frame.size.width, locationTextboxContainerView.frame.size.height-4)];
    [searchTextField setFont:[UIFont systemFontOfSize:20.0f]];
    [searchTextField setTextColor:[UIColor whiteColor]];
    [searchTextField setBackground:nil];
    [searchTextField setDelegate:self];
    [searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    NSAttributedString * placeholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"locationSettingsView_enterCity", @"Enter City Name Here Text") attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [searchTextField setAttributedPlaceholder:placeholder];
    [locationTextboxContainerView addSubview:searchTextField];
    
    //Add Gesture Recognizer to remove keyboard
    UITapGestureRecognizer * elsewhereTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard:)];
    [elsewhereTap setNumberOfTapsRequired:1];
    [elsewhereTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:elsewhereTap];
    
    UIView * locationSelectorWhiteBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, locationTextboxContainerView.frame.size.height-4, locationTextboxContainerView.frame.size.width, 4)];
    [locationSelectorWhiteBorderView setBackgroundColor:[UIColor whiteColor]];
    [locationTextboxContainerView addSubview:locationSelectorWhiteBorderView];
    
    UIButton * applyButton = [[UIButton alloc] initWithFrame:CGRectMake(locationTextboxContainerView.frame.size.width-40, 0, 40, 60-4)];
    UIImage * locationIconImage = [UIImage imageNamed:@"search_icon.png"];
    [applyButton setImage:locationIconImage forState:UIControlStateNormal];
    [applyButton setContentMode:UIViewContentModeScaleAspectFit];
    [applyButton addTarget:self action:@selector(applyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [locationTextboxContainerView addSubview:applyButton];
    
    //-----------------------------------
    //- Set To Indicator Code
    //-----------------------------------
    UIView * setToIndicatorContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, topHalfView.frame.size.width, (topHalfView.frame.size.height-60)-50)];
    [topHalfView addSubview:setToIndicatorContainerView];
    
    //Center It
    UIView * indicatorTextContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, (setToIndicatorContainerView.frame.size.height-80)/2, setToIndicatorContainerView.frame.size.width, 70)];
    [setToIndicatorContainerView addSubview:indicatorTextContainerView];
    
    //Top Indicator Label
    indicatorTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, indicatorTextContainerView.frame.size.width, 20)];
    [indicatorTopLabel setText:NSLocalizedString(@"locationSettingsView_currentlySetToLabel", @"Currently Set to Label")];
    [indicatorTopLabel setTextColor:[UIColor whiteColor]];
    [indicatorTopLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [indicatorTopLabel setTextAlignment:NSTextAlignmentCenter];
    [indicatorTextContainerView addSubview:indicatorTopLabel];
    
    //Bottom Indicator Label
    indicatorCurrentLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, indicatorTopLabel.frame.origin.y+indicatorTopLabel.frame.size.height+10, indicatorTextContainerView.frame.size.width, 40)];
    [indicatorCurrentLocationLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"locationName"]];
    [indicatorCurrentLocationLabel setTextColor:[UIColor whiteColor]];
    [indicatorCurrentLocationLabel setFont:[UIFont systemFontOfSize:36.0f]];
    [indicatorCurrentLocationLabel setTextAlignment:NSTextAlignmentCenter];
    [indicatorTextContainerView addSubview:indicatorCurrentLocationLabel];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //Text Field Should End Editing
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //Text Field Should Return Delegate Industry
    [searchTextField resignFirstResponder];
    [self.view endEditing:true];
    [self validateTextEntry];
    return true;
}

-(void)removeKeyboard:(id)iSender {
    //Removes the keyboard from view.
    [searchTextField resignFirstResponder];
}

-(IBAction)backBtnAction:(id)sender{
    //The Back Button was selected
    [self closeScreen];
}

-(IBAction)applyBtnAction:(id)sender{
    //The Apply Button was Selected
    [self.view endEditing:true];
    [searchTextField resignFirstResponder];
    [self validateTextEntry];
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
