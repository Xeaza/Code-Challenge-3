//
//  Station.h
//  CodeChallenge3
//
//  Created by Taylor Wright-Sanson on 10/17/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Station : NSObject

@property (readonly) NSString *name;
@property (readonly) NSString *numberOfAvailableBikes;
@property (readonly) CLLocationCoordinate2D coordinate;
@property NSInteger distanceFromYou;
@property (readonly) NSString *address;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
