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
#import "OAuthStore.h"
#import <RestKit/RestKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if (!url) {  return NO; }
    
    NSString *URLString = [url absoluteString];
    if([URLString rangeOfString: @"goBack"].length != NSNotFound) {

        NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
        NSArray *components = [URLString componentsSeparatedByString:@"&"];
        
        for (NSString *component in components) {
            NSArray *pair = [component componentsSeparatedByString:@"="];
            [queryParams setObject:[[pair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding: NSMacOSRomanStringEncoding]
                            forKey:[pair objectAtIndex:0]];
        }
        
        //  self.oauthToken = [queryParams objectForKey:@"oauth_token"];
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        [(UINavigationController*)tabBarController.selectedViewController popViewControllerAnimated:YES];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    OAuthStore *auth = [OAuthStore sharedSingleton];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:[auth baseURL]];
    objectManager.client.OAuth1ConsumerKey = [auth consumerKey];
    objectManager.client.OAuth1ConsumerSecret = [auth consumerSecret];
    objectManager.client.authenticationType = RKRequestAuthenticationTypeOAuth1;
    
    RKObjectMapping* linkMapping = [RKObjectMapping mappingForClass:[Link class]];
    [linkMapping mapKeyPath:@"href" toAttribute:@"href"];
    [linkMapping mapKeyPath:@"rel" toAttribute:@"rel"];
    [linkMapping mapKeyPath:@"title" toAttribute:@"title"];
    [linkMapping mapKeyPath:@"synopsis" toAttribute:@"synopsis"];
    [linkMapping mapKeyPath:@"delivery_formats" toAttribute:@"deliveryFormats"];
    
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
    
    
    //  RKObjectManager* objectManager = [RKObjectManager sharedManager];
    /* objectManager.client.baseURL = @"YOUR_BASE_URL";
     objectManager.client.OAuth1ConsumerKey = @"YOUR CONSUMER KEY";
     objectManager.client.OAuth1ConsumerSecret = @"YOUR CONSUMER SECRET";
     objectManager.client.OAuth1AccessToken = @"YOUR ACCESS TOKEN";
     objectManager.client.OAuth1AccessTokenSecret = @"YOUR ACCESS TOKEN SECRET";
     objectManager.client.authenticationType = RKRequestAuthenticationTypeOAuth1;*/
    //RKObjectManager *objectManager = [[RKObjectManager alloc] initWithBaseURL:[[RKURL alloc] initWithString:<#(NSString *)#>];
    
    return YES;
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
        
    } else if ([request isPOST]) {
        
        // Handling POST /other.json
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    RKLogInfo(@"Load collection of Articles: %@", objects);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Encountered an error: %@", error);
    /* open an alert with an OK button */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"There seems to be a problem connecting to netflix!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
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
