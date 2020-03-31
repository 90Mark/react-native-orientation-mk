//
//  Orientation.m
//

#import "Orientation.h"
#if __has_include(<React/RCTEventDispatcher.h>)
#import <React/RCTEventDispatcher.h>
#else
#import "RCTEventDispatcher.h"
#endif

#define TAG @"Orientation"

@implementation Orientation

@synthesize bridge = _bridge;

static UIInterfaceOrientationMask _orientation = UIInterfaceOrientationMaskAllButUpsideDown;
+ (void)setOrientation:(UIInterfaceOrientationMask)orientation {
    _orientation = orientation;
}
+ (UIInterfaceOrientationMask)getOrientation {
    return _orientation;
}

- (instancetype)init
{
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
        if (_motionManager == nil) {
            _motionManager = [[CMMotionManager alloc] init];
        }
        if ([_motionManager isAccelerometerAvailable]) {
            _motionManager.accelerometerUpdateInterval = 0.2f;
            [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                [self outputAccelertionData:accelerometerData.acceleration];
            }];
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([_motionManager isAccelerometerActive] == YES) {
        [_motionManager stopAccelerometerUpdates];
    }
}

- (void)outputAccelertionData:(CMAcceleration)acceleration{
    double x = acceleration.x;
    if (fabs(x) >= 0.1f) {
        if (x >= 0) {
            self.orientation = UIDeviceOrientationLandscapeRight;
        } else {
            self.orientation = UIDeviceOrientationLandscapeLeft;
        }
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"specificOrientationDidChange"
                                                    body:@{@"specificOrientation": [self getSpecificOrientationStr:orientation]}];
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"orientationDidChange"
                                                    body:@{@"orientation": [self getOrientationStr:orientation]}];
}

- (NSString *)getOrientationStr:(UIDeviceOrientation)orientation {
    NSString *orientationStr;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            orientationStr = @"PORTRAIT";
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            orientationStr = @"LANDSCAPE";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientationStr = @"PORTRAITUPSIDEDOWN";
            break;
        default:
            // orientation is unknown, we try to get the status bar orientation
            switch ([[UIApplication sharedApplication] statusBarOrientation]) {
                case UIInterfaceOrientationPortrait:
                    orientationStr = @"PORTRAIT";
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    orientationStr = @"LANDSCAPE";
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    orientationStr = @"PORTRAITUPSIDEDOWN";
                    break;
                default:
                    orientationStr = @"UNKNOWN";
                    break;
            }
            break;
    }
    return orientationStr;
}

- (NSString *)getSpecificOrientationStr:(UIDeviceOrientation)orientation {
    NSString *orientationStr;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            orientationStr = @"PORTRAIT";
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientationStr = @"LANDSCAPE-LEFT";
            break;
        case UIDeviceOrientationLandscapeRight:
            orientationStr = @"LANDSCAPE-RIGHT";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientationStr = @"PORTRAITUPSIDEDOWN";
            break;
        default:
            // orientation is unknown, we try to get the status bar orientation
            switch ([[UIApplication sharedApplication] statusBarOrientation]) {
                case UIInterfaceOrientationPortrait:
                    orientationStr = @"PORTRAIT";
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    orientationStr = @"LANDSCAPE";
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    orientationStr = @"PORTRAITUPSIDEDOWN";
                    break;
                default:
                    orientationStr = @"UNKNOWN";
                    break;
            }
            break;
    }
    return orientationStr;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getOrientation:(RCTResponseSenderBlock)callback)
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSString *orientationStr = [self getOrientationStr:orientation];
    callback(@[[NSNull null], orientationStr]);
}

RCT_EXPORT_METHOD(getSpecificOrientation:(RCTResponseSenderBlock)callback)
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSString *orientationStr = [self getSpecificOrientationStr:orientation];
    callback(@[[NSNull null], orientationStr]);
}

RCT_EXPORT_METHOD(lockToPortrait)
{
    [Orientation setOrientation:UIInterfaceOrientationMaskPortrait];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationPortraitUpsideDown] forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationPortrait] forKey:@"orientation"];
    }];
}

RCT_EXPORT_METHOD(lockToLandscape)
{
    [Orientation setOrientation:UIInterfaceOrientationMaskLandscape];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationPortrait] forKey:@"orientation"];
        switch (self.orientation) {
            case UIDeviceOrientationLandscapeLeft:
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
                break;
            case UIDeviceOrientationLandscapeRight:
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
                break;
            default:
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
                break;
        }
    }];
}

RCT_EXPORT_METHOD(lockToLandscapeLeft)
{
    [Orientation setOrientation:UIInterfaceOrientationMaskLandscapeLeft];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationPortrait] forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    }];
}

RCT_EXPORT_METHOD(lockToLandscapeRight)
{
    [Orientation setOrientation:UIInterfaceOrientationMaskLandscapeRight];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationPortrait] forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
    }];
}

RCT_EXPORT_METHOD(unlockAllOrientations)
{
    [Orientation setOrientation:UIInterfaceOrientationMaskAllButUpsideDown];
}

- (NSDictionary *)constantsToExport
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSString *orientationStr = [self getOrientationStr:orientation];
    
    return @{@"initialOrientation": orientationStr};
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
