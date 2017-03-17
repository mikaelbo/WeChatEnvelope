// Overriding some simple jailbreak checks which removes WeChat's restriction of TouchID usage for 
// jailbroken devices. They most likely have more advanced methods for actually detecting jailbroken 
// devices, but have for some reason decided to rely on these calls for restricting TouchID.


%hook WCPayTouchIDAuthHelper

+ (BOOL)isDeviceJailBreak {
	return NO;
}

%end


%hook JailBreakHelper

- (BOOL)isJailBreak {
	return NO;
}

%end


%hook KSSystemInfo

+ (BOOL)isJailbroken {
	return NO;
}

%end


%hook MMUploadDataViewController

- (BOOL)isJailbreak {
	return NO;
}

%end
