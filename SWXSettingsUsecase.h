#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SWXSettingsUsecase : NSObject

@property (nonatomic) BOOL autoOpenEnvelopesEnabled;

+ (instancetype)sharedUsecase;

@end
