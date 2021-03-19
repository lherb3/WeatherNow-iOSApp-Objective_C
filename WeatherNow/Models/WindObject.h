//
//  WindObject.h
//  WeatherNow
//
//  Created by Larry Herb on 3/19/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindObject : NSObject{
    double speed;
    double degrees;
    double gust;
}
-(id)init:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
