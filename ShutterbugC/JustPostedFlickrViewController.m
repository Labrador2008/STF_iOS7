//
//  JustPostedFlickrViewController.m
//  ShutterbugC
//
//  Created by Lucky_Lay on 16/11/1.
//  Copyright © 2016年 Lay. All rights reserved.
//

#import "JustPostedFlickrViewController.h"
#import "FlickrFetcher.h"

@interface JustPostedFlickrViewController ()

@end

@implementation JustPostedFlickrViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}

- (void)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("flicker fetcher", NULL);
    
    dispatch_async(fetchQ, ^{
       
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
            NSLog(@"phtots : %@", self.photos);
        });
    });
}





@end
