#import "SWXSettingsUsecase.h"

#define AUTO_OPEN_ENABLED_KEY @"SWXAutoOpenEnabled"


@interface SWXSettingsUsecase()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation SWXSettingsUsecase

+ (instancetype)sharedUsecase {
    static dispatch_once_t onceToken;
    static SWXSettingsUsecase *usecase;
    dispatch_once(&onceToken, ^{
        usecase = [[SWXSettingsUsecase alloc] init];
    });
    return usecase;
}

- (instancetype)init {
    if (self = [super init]) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.turboSvennen.WeChatEnvelope"];
        _autoOpenEnvelopesEnabled = [_userDefaults boolForKey:AUTO_OPEN_ENABLED_KEY];
    }
    return self;
}

- (void)setAutoOpenEnvelopesEnabled:(BOOL)autoOpenEnvelopesEnabled {
    _autoOpenEnvelopesEnabled = autoOpenEnvelopesEnabled;
    [_userDefaults setBool:autoOpenEnvelopesEnabled forKey:AUTO_OPEN_ENABLED_KEY];
}

- (void)dealloc {
    [_userDefaults synchronize];
}

@end
