//
//  Station.m
//  CodeChallenge3
//
//  Created by Taylor Wright-Sanson on 10/17/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Station.h"

@implementation Station
{
    NSDictionary *jsonDictionary;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        jsonDictionary = dictionary;
    }
    return self;
}

- (NSString *)name
{
    return jsonDictionary[@"stAddress1"];
}

- (NSString *)numberOfAvailableBikes
{
    return [jsonDictionary[@"availableBikes"] stringValue];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coord;
    coord.latitude = [jsonDictionary[@"latitude"] floatValue];
    coord.longitude = [jsonDictionary[@"longitude"] floatValue];
    return coord;
}

- (NSString *)address
{
    return jsonDictionary[@"location"];
}


@end
