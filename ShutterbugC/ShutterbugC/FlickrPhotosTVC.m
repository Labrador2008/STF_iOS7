//
//  FlickrPhotosTVC.m
//  ShutterbugC
//
//  Created by Lucky_Lay on 16/11/1.
//  Copyright © 2016年 Lay. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"


@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *photo = self.photos[indexPath.row];
    
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //work for ipda  and  forget what they do...
    id detail = self.splitViewController.viewControllers[1];
    
    if ([detail isKindOfClass:[UINavigationController class]])
    {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
        
    }
    
    if ([detail isKindOfClass:[ImageViewController class]])
    {
        [self prepareImageViewController:detail toDisplayphoto:self.photos[indexPath.row]];
    }
    
    
}

# pragma mrak - Navigation

- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayphoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender ];
        
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Display Photo"])
            {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]])
                {
                    [self prepareImageViewController:segue.destinationViewController toDisplayphoto:self.photos[indexPath.row]];
                }
            }
        }
    }
}
@end
