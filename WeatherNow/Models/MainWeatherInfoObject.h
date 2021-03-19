//
//  MainWeatherInfoObject.h
//  WeatherNow
//
//  Created by Larry Herb on 3/19/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWeatherInfoObject : NSObject{
    @public double temperatureKelvin;
    @public int pressure;
    @public int humidity;
    @public double temperatureKelvinMin;
    @public double temperatureKelvinMax;
}

-(id)init:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
