//
//  CurrentWeatherObject.h
//  WeatherNow
//
//  Created by Larry Herb on 3/19/21.
//

#import <Foundation/Foundation.h>
#import "CoordinateObject.h"
#import "MainWeatherInfoObject.h"
#import "WindObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrentWeatherObject : NSObject{
    //Declare Variable Here
    
    CoordinateObject * coordinate;
    NSMutableArray * weatherConditionsArray;
    NSString * base;
    MainWeatherInfoObject * weatherOverview;
    int visibility;
    WindObject * wind;
    int identifier;
    int dt;
    NSString * cityName;
    int httpCode;
}

@property (nonatomic, retain) CoordinateObject * coordinate;
@property (nonatomic, retain) NSMutableArray * weatherConditionsArray;
@property (nonatomic, retain) NSString * base;
@property (nonatomic, retain) WindObject * wind;
@property (nonatomic, retain) MainWeatherInfoObject * weatherOverview;
@property (nonatomic, retain) NSString * cityName;

-(id)init:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
