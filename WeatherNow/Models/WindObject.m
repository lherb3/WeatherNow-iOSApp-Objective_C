//
//  WindObject.m
//  WeatherNow
//
//  Created by Larry Herb on 3/19/21.
//

#import "WindObject.h"

@implementation WindObject

-(id)init:(NSDictionary *)dictionary{
    //Initiate Object with Default Values
    
    speed = [[dictionary objectForKey:@"speed"] doubleValue];
    degrees = [[dictionary objectForKey:@"deg"] doubleValue];
    gust = [[dictionary objectForKey:@"gust"] doubleValue];
    
    return self;
}

@end
