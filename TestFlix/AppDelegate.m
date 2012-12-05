//
//  AppDelegate.m
//  TestFlix
//
//  Created by Joshua Palermo on 9/9/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import "AppDelegate.h"
#import "CatalogTitles.h"
#import "CatalogTitle.h"
#import "Link.h"
#import "Category.h"
#import <RestKit/RestKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:@"http://api-public.netflix.com"];
    objectManager.client.OAuth1ConsumerKey = @"62q3pac4cjd25uybzk2ym88n";
    objectManager.client.OAuth1ConsumerSecret = @"RNJyuPbYze";
    objectManager.client.authenticationType = RKRequestAuthenticationTypeOAuth1;
    
    RKObjectMapping* linkMapping = [RKObjectMapping mappingForClass:[Link class]];
    [linkMapping mapKeyPath:@"href" toAttribute:@"href"];
    [linkMapping mapKeyPath:@"rel" toAttribute:@"rel"];
    [linkMapping mapKeyPath:@"title" toAttribute:@"title"];
    [linkMapping mapKeyPath:@"synopsis" toAttribute:@"synopsis"];
    
    RKObjectMapping* categoryMapping = [RKObjectMapping mappingForClass:[Category class]];
    [categoryMapping mapKeyPath:@"scheme" toAttribute:@"scheme"];
    [categoryMapping mapKeyPath:@"label" toAttribute:@"label"];
    
    RKObjectMapping* catalogTitleMapping = [RKObjectMapping mappingForClass:[CatalogTitle class]];
    [catalogTitleMapping mapKeyPath:@"title.regular" toAttribute:@"regularTitle"];
    [catalogTitleMapping mapKeyPath:@"box_art.small" toAttribute:@"smallBoxArtUrl"];
    [catalogTitleMapping mapKeyPath:@"box_art.medium" toAttribute:@"mediumBoxArtUrl"];
    [catalogTitleMapping mapKeyPath:@"box_art.large" toAttribute:@"largeBoxArtUrl"];
    [catalogTitleMapping mapKeyPath:@"id" toAttribute:@"titleIdUrl"];
    [catalogTitleMapping mapKeyPath:@"release_year" toAttribute:@"releaseYear"];
    [catalogTitleMapping mapKeyPath:@"average_rating" toAttribute:@"averageRating"];
    [catalogTitleMapping mapKeyPath:@"link" toRelationship:@"link" withMapping:linkMapping];
    [catalogTitleMapping mapKeyPath:@"category" toRelationship:@"category" withMapping:categoryMapping];

    
    RKObjectMapping* catalogTitlesMapping = [RKObjectMapping mappingForClass:[CatalogTitles class]];
    [catalogTitlesMapping mapKeyPath:@"number_of_results" toAttribute:@"numberOfResults"];
    [catalogTitlesMapping mapKeyPath:@"start_index" toAttribute:@"startIndex"];
    [catalogTitlesMapping mapKeyPath:@"catalog_title" toRelationship:@"catalogTitle" withMapping:catalogTitleMapping];
    
    [objectManager.mappingProvider setObjectMapping:catalogTitlesMapping forKeyPath:@"catalog_titles"];
    

    //RKObjectMapping* testMapping = [RKObjectMapping mappingForClass:[test class]];
   // [testMapping mapKeyPath:@"" toAttribute:@"testStr"];
    
   // [objectManager.mappingProvider setObjectMapping:testMapping forKeyPath:@"synopsis"];
    
    /* NSURL *baseURL = [NSURL URLWithString:@"http://api-public.netflix.com"];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    // objectManager.client.baseURL = [RKURL URLWithBaseURLString:@"http://api-public.netflix.com"];
    objectManager.client.OAuth1ConsumerKey = @"62q3pac4cjd25uybzk2ym88n";
    objectManager.client.OAuth1ConsumerSecret = @"RNJyuPbYze";
    // objectManager.client.OAuth1AccessToken = @"YOUR ACCESS TOKEN";
    //objectManager.client.OAuth1AccessTokenSecret = @"YOUR ACCESS TOKEN SECRET";
    objectManager.client.authenticationType = RKRequestAuthenticationTypeOAuth1;
    
    NSMutableString *searchUrl = [[NSMutableString alloc] initWithString:@"/catalog/titles?term="];
    [searchUrl appendString:self.searchField.text];
    NSString *url = [[RKURL URLWithBaseURL:[objectManager baseURL] resourcePath:searchUrl] description];
    
    RKObjectMapping* catalogTitleMapping = [RKObjectMapping mappingForClass:[CatalogTitle class]];
    [catalogTitleMapping mapKeyPath:@"title.regular" toAttribute:@"regularTitle"];
    
    RKObjectMapping* catalogTitlesMapping = [RKObjectMapping mappingForClass:[CatalogTitles class]];
    [catalogTitlesMapping mapKeyPath:@"number_of_results" toAttribute:@"numberOfResults"];
    [catalogTitlesMapping mapKeyPath:@"catalog_title" toRelationship:@"catalogTitle" withMapping:catalogTitleMapping];
    
    [objectManager.mappingProvider setObjectMapping:catalogTitlesMapping forKeyPath:@"catalog_titles"];
    [objectManager loadObjectsAtResourcePath:searchUrl  delegate:self];
    
    //[catalogMapping mapKeyPath:@"start_index" toAttribute:@"startIndex"];
    // [catalogMapping mapKeyPath:@"results_per_page" toAttribute:@"resultsPerPage"];
    //    [catalogMapping mapKeyPath:@"catalog_title.box_art.small" toAttribute:@"smallBoxArtUrl"];
    
    
    
    
    //  RKObjectManager* objectManager = [RKObjectManager sharedManager];
    /* objectManager.client.baseURL = @"YOUR_BASE_URL";
     objectManager.client.OAuth1ConsumerKey = @"YOUR CONSUMER KEY";
     objectManager.client.OAuth1ConsumerSecret = @"YOUR CONSUMER SECRET";
     objectManager.client.OAuth1AccessToken = @"YOUR ACCESS TOKEN";
     objectManager.client.OAuth1AccessTokenSecret = @"YOUR ACCESS TOKEN SECRET";
     objectManager.client.authenticationType = RKRequestAuthenticationTypeOAuth1;*/
    //RKObjectManager *objectManager = [[RKObjectManager alloc] initWithBaseURL:[[RKURL alloc] initWithString:<#(NSString *)#>];
    
    
    
    
    
    
    
    // http://stackoverflow.com/questions/11746317/post-from-ios-for-insert-using-rkobjectmanager
    //  NSURL *url = [NSURL URLWithString:@"http://api-public.netflix.com"];
    //  RKClient* client = [RKClient clientWithBaseURL:url];
    //  client.OAuth1ConsumerKey = @"62q3pac4cjd25uybzk2ym88n";
    // client.OAuth1ConsumerSecret = @"RNJyuPbYze";
    // client.authenticationType = RKRequestAuthenticationTypeOAuth1;     */
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
