//
//  CoordinateObject.h
//  WeatherNow
//
//  Created by Larry Herb on 3/19/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoordinateObject : NSObject{
    double latitude;
    double longitude;
}

-(id)init:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
