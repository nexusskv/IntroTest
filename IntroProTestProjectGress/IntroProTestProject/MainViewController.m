//
//  MainViewController.m
//  IntroProTestProject
//
//  Created by rost on 20.11.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "MainViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface MainViewController () <UIWebViewDelegate>
{
    UIWebView *mainWebView;
}
@end


@implementation MainViewController


#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test Page";
    
    mainWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    mainWebView.delegate = self;
    [self.view addSubview:mainWebView];

    mainWebView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"webView" : mainWebView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self loadPage];
}
#pragma mark -


#pragma mark - Selectors
- (void)loadPage {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSString *urlString = [[NSBundle mainBundle] bundlePath];
    NSURL *htmlUrl = [NSURL fileURLWithPath:[urlString stringByAppendingPathComponent:@"test.html"]];
    
    [mainWebView loadRequest:[NSURLRequest requestWithURL:htmlUrl]];
}

- (void)getRandomImage {
    ALAssetsLibrary *photosLibrary = [[ALAssetsLibrary alloc] init];
    __block NSMutableArray *imagesArray = [[NSMutableArray alloc] init];

    [photosLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
            if (asset)
                [imagesArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"User did not allow access to library!");
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([imagesArray count] > 0)
            [self saveImage:imagesArray[arc4random_uniform((uint32_t)[imagesArray count])]];
    });
}

- (void)saveImage:(UIImage *)image {
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"test_photo.png"];
    NSData *imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:imagePath atomically:YES];
    
    [self showImage:imagePath];
}

- (void)showImage:(NSString *)imagePath {
    [UIView transitionWithView:mainWebView
                      duration:0.4f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        
                        self.title = @"Photo";
                        
                        [mainWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"changeFunction('%@')", imagePath]];
                        
                        /*      // THIS CODE HERE -- FOR CHECK FINAL HTML PAGE ONLY
                         NSString *html = [mainWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
                         NSLog(@"HTML >>> %@", html);
                         */
                    }
                    completion:nil];
}
#pragma mark -


#pragma mark - WebView Delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSRange UrlInRequestRange = [[request.URL.absoluteString lowercaseString] rangeOfString:[@"linkTag" lowercaseString]];
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked && UrlInRequestRange.location != NSNotFound)
    {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
            [self getRandomImage];
        #endif
        
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
#pragma mark -


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
