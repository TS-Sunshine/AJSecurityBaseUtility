//
//  ViewController.m
//  SecurityBaseUtility
//
//  Created by 安静的为你歌唱 on 2019/7/4.
//  Copyright © 2019 安静的为你歌唱. All rights reserved.
//

#import "ViewController.h"
#import "Utility/SecurityBaseUtility.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)typeAction:(id)sender {
    if ([[SecurityBaseUtility sharedInstance] isFaceID]) {
        NSLog(@"是FaceID");
    }else{
        NSLog(@"是TouchID");
    }
}

@end
