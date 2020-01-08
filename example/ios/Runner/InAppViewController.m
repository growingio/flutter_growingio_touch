//
// Created by xiangyang on 2018/12/21.
// Copyright (c) 2018 com.growingio. All rights reserved.
//

#import "InAppViewController.h"


@implementation InAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
    [text setText:[NSString stringWithFormat:@"This in app page! key1 = %@, key2 = %@", self.key1, self.key2]];
    NSLog(text.text);
    [self.view addSubview:text];
}
@end