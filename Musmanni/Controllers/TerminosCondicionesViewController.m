//
//  TerminosCondicionesViewController.m
//  Musmanni
//
//  Created by Erick Pac on 27/10/16.
//  Copyright © 2016 Florida Bebidas. All rights reserved.
//

#import "TerminosCondicionesViewController.h"

@interface TerminosCondicionesViewController ()

@end

@implementation TerminosCondicionesViewController
@synthesize webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Términos y condiciones";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void) viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    NSString *urlString = @"http://52.0.9.158/terminosycondiciones";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
