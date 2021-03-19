//
//  CurrentWeatherObject.m
//  WeatherNow
//
//  Created by Larry Herb on 3/19/21.
//

#import "CurrentWeatherObject.h"

@implementation CurrentWeatherObject

@synthesize base, cityName, weatherConditionsArray, coordinate, weatherOverview, wind;

-(id)init:(NSDictionary *)dictionary{
    //Initiate Object with Default Values
    
    weatherConditionsArray = [[NSMutableArray alloc] init];
    coordinate = [[CoordinateObject alloc] init:[dictionary objectForKey:@"coord"]];
    NSArray * weatherJSON = [dictionary objectForKey:@"weather"];
    if([weatherJSON count]==0){
        //Nothing in Conditions
    }else{
        if(weatherJSON==nil){
            //Nothing in Conditions
        }else{
            //Look through
            for (int i = 0; i < [weatherJSON count]; i++)
            {
                [weatherConditionsArray addObject:[weatherJSON objectAtIndex:i]];
            }
        }
    }
    base = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"base"]];
    weatherOverview = [[MainWeatherInfoObject alloc] init:[dictionary objectForKey:@"main"]];
    visibility = [[dictionary objectForKey:@"visibility"] intValue];
    wind = [[WindObject alloc] init:[dictionary objectForKey:@"wind"]];
    identifier = [[dictionary objectForKey:@"id"] intValue];
    dt = [[dictionary objectForKey:@"dt"] intValue];
    cityName = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"name"]];
    httpCode = [[dictionary objectForKey:@"cod"] intValue];
    
    //coordinate object here
    NSLog(@"Object Recieved");
    NSLog(@"%@", dictionary);
    //NSLog(@"Coordinate %@", [dictionary objectForKey:@"coord"]);
    return self;
}

@end
