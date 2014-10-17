//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.station.name;

    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;

    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;

    [self addStationPin];

    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;

    [self setRegionForSpan:span];

}

- (void)addStationPin
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];

    annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = self.station.coordinate;
    annotation.title = self.station.name;
    annotation.subtitle = [NSString stringWithFormat:@"%@ bikes available", self.station.numberOfAvailableBikes];
    [self.mapView addAnnotation:annotation];
}

- (void)setRegionForSpan: (MKCoordinateSpan)span
{
    MKCoordinateRegion region;
    region.center = self.station.coordinate;
    region.span = span;

    [self.mapView setRegion:region animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.image = [UIImage imageNamed:@"bikeImage"];

    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    //alertView.title = @"Directions...";

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.station.address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
        {
            // Handle error
            NSLog(@"error");
        }
        else
        {
            MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
            MKPlacemark *placemark = placemarks.firstObject;
            [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
            [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
            directionsRequest.transportType = MKDirectionsTransportTypeWalking;
            MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
            [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                if (error) {
                    NSLog(@"Error %@", error.description);
                } else {
                    MKRoute *route = response.routes.lastObject;
//                    MKRouteStep *route = response.routes.lastObject;
                    alertView.message = route.name;

                    [alertView addButtonWithTitle:@"Damn couldn't get MKRouteStep to work..."];
                    [alertView show];
                    //[self.mapView addOverlay:self.route.polyline];
                }
            }];


        }
    }];



}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder geocodeAddressString:self.station.name completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error)
//        {
//            // Handle error
//        }
//        else
//        {
//            MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
//            MKPlacemark *placemark = placemarks.firstObject;
//            [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
//            [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
//            directionsRequest.transportType = MKDirectionsTransportTypeWalking;
//            MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
////            [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
////                if (error) {
////                    NSLog(@"Error %@", error.description);
////                } else {
////                    self.route = response.routes.lastObject;
////                    [self.mapView addOverlay:self.route.polyline];
////                }
////            }];
//
//        }
//    }];
//
//
//}

@end
