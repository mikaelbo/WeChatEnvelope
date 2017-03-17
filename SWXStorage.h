#import <UIKit/UIKit.h>

@interface SWXStorage : NSObject

+ (instancetype)sharedStorage;
- (void)addPackageID:(NSNumber *)packageID;
- (BOOL)containsPackageID:(NSNumber *)packageID;
- (void)synchronize;

@end
