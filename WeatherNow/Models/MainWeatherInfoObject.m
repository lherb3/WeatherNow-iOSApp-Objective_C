//
//  MainWeatherInfoObject.m
//  WeatherNow
//
//  Created by Larry Herb on 3/19/21.
//

#import "MainWeatherInfoObject.h"

@implementation MainWeatherInfoObject

-(id)init:(NSDictionary *)dictionary{
    //Initiate Object with Default Values
    
    temperatureKelvin = [[dictionary objectForKey:@"temp"] doubleValue];
    pressure = [[dictionary objectForKey:@"pressure"] intValue];
    humidity = [[dictionary objectForKey:@"humidity"] intValue];
    temperatureKelvinMin = [[dictionary objectForKey:@"temp_min"] doubleValue];
    temperatureKelvinMax = [[dictionary objectForKey:@"temp_max"] doubleValue];
    
    return self;
}

@end
