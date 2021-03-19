//
//  MainWeatherInfoObject.h
//  WeatherNow
//
//  Created by Larry Herb on 3/19/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWeatherInfoObject : NSObject{
    double temperatureKelvin;
    int pressure;
    int humidity;
    double temperatureKelvinMin;
    double temperatureKelvinMax;
}

-(id)init:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
