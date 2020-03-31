//
//  OrientationViewController.m
//  DewesStudentApp
//
//  Created by Mark on 2020/3/31.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "OrientationViewController.h"
#import "Orientation.h"

@interface OrientationViewController ()

@end

@implementation OrientationViewController

- (id)initWithOrientation:(UIInterfaceOrientationMask) orientation {
    if (self = [super init]) {
        [Orientation setOrientation:orientation];
    }
    return self;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [Orientation getOrientation];
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
