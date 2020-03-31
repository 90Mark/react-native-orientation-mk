//
//  Orientation.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif
#import <CoreMotion/CoreMotion.h>

@interface Orientation : NSObject <RCTBridgeModule>

@property (nonatomic,strong) CMMotionManager *motionManager;
@property (nonatomic,assign) UIDeviceOrientation orientation;

+ (void)setOrientation: (UIInterfaceOrientationMask)orientation;

+ (UIInterfaceOrientationMask)getOrientation;

@end
