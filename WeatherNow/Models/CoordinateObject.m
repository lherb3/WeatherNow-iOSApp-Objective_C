//
//  CoordinateObject.m
//  WeatherNow
//
//  Created by Larry Herb on 3/19/21.
//

#import "CoordinateObject.h"

@implementation CoordinateObject

-(id)init:(NSDictionary *)dictionary{
    //Initiate Object with Default Values
    
    latitude = [[dictionary objectForKey:@"lat"] doubleValue];
    longitude = [[dictionary objectForKey:@"lon"] doubleValue];
    return self;
}

@end
