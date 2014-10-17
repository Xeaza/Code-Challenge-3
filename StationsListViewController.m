//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "Station.h"
#import "MapViewController.h"

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *bikeStations;


@end

@implementation StationsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadJSON:[NSURL URLWithString:@"http://www.divvybikes.com/stations/json/"]];
}

- (void)loadJSON: (NSURL *)jsonURL
{
    self.bikeStations = [[NSMutableArray alloc] init];

    NSURLRequest *request = [NSURLRequest requestWithURL:jsonURL];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSError *jsonError;
         // Get json as string and print it
         //NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         //NSLog(@"%@", jsonString);

         if (connectionError != nil)
         {
             NSLog(@"Connection error: %@", connectionError.localizedDescription);
         }
         if (jsonError != nil)
         {
             NSLog(@"JSON error: %@", jsonError.localizedDescription);
         }

         if (data)
         {
             NSDictionary *stationsJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

             NSArray *arrayOfStationsDictionaries =  [stationsJson objectForKey:@"stationBeanList"];

             for (NSDictionary *stationDictionary in arrayOfStationsDictionaries)
             {
                 Station *station = [[Station alloc] initWithDictionary:stationDictionary];
                 [self.bikeStations addObject:station];
             }

             [self.tableView reloadData];
         }
         else
         {
             NSLog(@"Divvy bike data fail");
         }
     }];
}



#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bikeStations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Station *station = [self.bikeStations objectAtIndex:indexPath.row];
    cell.textLabel.text = station.name;
    cell.detailTextLabel.text = station.numberOfAvailableBikes;
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if ([segue.identifier isEqualToString:@"ToMapSegue"])
    {
        MapViewController *mapViewController = segue.destinationViewController;
        mapViewController.station = [self.bikeStations objectAtIndex:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
