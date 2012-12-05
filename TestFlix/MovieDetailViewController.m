//
//  MovieDetailViewController.m
//  TestFlix
//
//  Created by Joshua Palermo on 10/9/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import "MovieDetailViewController.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *movieBoxArtImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieSynopsisTextView;
@property (weak, nonatomic) IBOutlet UIWebView *movieSynopsisWebView;
@end

@implementation MovieDetailViewController

@synthesize movieBoxArtImageView = _movieBoxArtImageView;
@synthesize movieTitleLabel = _movieTitleLabel;
@synthesize catalogTitle = _catalogTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *) stripTagsFrom:(NSString *)aString {
    NSRange r;
    while ((r = [aString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        aString = [aString stringByReplacingCharactersInRange:r withString:@""];
    return aString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.movieTitleLabel.numberOfLines = 0;
    self.movieTitleLabel.text = self.catalogTitle.regularTitle;
    [self.movieTitleLabel sizeToFit];
    
    self.movieSynopsisTextView.text = self.catalogTitle.synopsis;
    [self.movieSynopsisTextView sizeToFit];
    [self.movieSynopsisWebView loadHTMLString: [self stripTagsFrom: self.catalogTitle.synopsis] baseURL:nil];


   // [self.movieSynopsisWebView loadHTMLString:synopsisText baseURL: nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
        NSData *imageData = [NSData dataWithContentsOfURL: self.catalogTitle.largeBoxArtUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Maybe correct the frame too
            //[self.view addSubview:imageView];
            UIImage *image = [UIImage imageWithData:imageData];
            self.movieBoxArtImageView.image = image;
        });
    });
    
    self.movieSynopsisWebView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setMovieBoxArtImageView:nil];
    [self setMovieTitleLabel:nil];
    [super viewDidUnload];
}
@end
