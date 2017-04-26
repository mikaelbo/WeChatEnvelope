#import "BaseMsgContentViewController.h"
#import "SWXStorage.h"
#import "SWXSettingsUsecase.h"
#import "ClassDeclarations.h"

BOOL isOpeningPackage;
BOOL canOpenPackage;
NSNumber *currentSvrID;


%hook BaseMsgContentViewController

- (void)dealloc {
    isOpeningPackage = NO;
    currentSvrID = nil;
    %orig;
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    isOpeningPackage = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    canOpenPackage = YES;
    if (![SWXSettingsUsecase sharedUsecase].autoOpenEnvelopesEnabled) { return; }
    UITableView *tableView = [self visibleTableView];
    if (!tableView) { return; }
    for (UITableViewCell *cell in tableView.visibleCells) {
        [self openCellIfNeeded:cell];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig;
    canOpenPackage = NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    %orig;
    if (![SWXSettingsUsecase sharedUsecase].autoOpenEnvelopesEnabled) { return; }
    [self openCellIfNeeded:cell];
}

- (void)openCellIfNeeded:(UITableViewCell *)cell {
    if (!canOpenPackage || isOpeningPackage || ![SWXSettingsUsecase sharedUsecase].autoOpenEnvelopesEnabled) { 
        return; 
    }

    if (![cell isKindOfClass:NSClassFromString(@"ChatTableViewCell")]) { return; }
    ChatTableViewCell *chatCell = (ChatTableViewCell *)cell;
    if (![chatCell respondsToSelector:@selector(cellView)]) { return; }
    if (![chatCell.cellView isKindOfClass:NSClassFromString(@"WCPayC2CMessageCellView")]) { return; }
    WCPayC2CMessageCellView *cellView = (WCPayC2CMessageCellView *)chatCell.cellView;
    if (![cellView respondsToSelector:@selector(viewModel)]) { return; }
    if (![cellView.viewModel isKindOfClass:NSClassFromString(@"WCPayC2CMessageViewModel")]) { return; }
    WCPayC2CMessageViewModel *viewModel = (WCPayC2CMessageViewModel *)cellView.viewModel;
    if (![viewModel respondsToSelector:@selector(isSender)] || ![viewModel respondsToSelector:@selector(msgStatus)]) { 
        return; 
    }
    if (viewModel.isSender) { return; }

    BOOL shoulSelectCell = YES;
    NSNumber *messageSvrID;

    if ([viewModel respondsToSelector:@selector(messageWrap)]) {
        CMessageWrap *messageWrap = viewModel.messageWrap;
        if ([messageWrap respondsToSelector:@selector(m_n64MesSvrID)]) {
            unsigned int svrID = messageWrap.m_n64MesSvrID;
            NSNumber *svrNumber = @(svrID);
            if ([[SWXStorage sharedStorage] containsPackageID:svrNumber]) {
                shoulSelectCell = NO;
            } else {
                messageSvrID = svrNumber;
            }
        }
    }

    if (shoulSelectCell && [cellView respondsToSelector:@selector(onTouchUpInside)]) {
        currentSvrID = messageSvrID;
        [self openRedPackageForCellView:cellView];
    }
}

- (void)openRedPackageForCellView:(WCPayC2CMessageCellView *)cellView {
    isOpeningPackage = YES;
    NSInteger randomNumber = (arc4random() % 89) + 1;
    NSTimeInterval time = 0.25 + (randomNumber * 0.001);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([cellView respondsToSelector:@selector(delegate)]) {
            if ([cellView.delegate respondsToSelector:@selector(onHideKeyboard)]) {
                [cellView.delegate onHideKeyboard];
            }
        }
        [cellView onTouchUpInside];
    }); 
}

// NOTE: After a package has been opened, a WCRedEnvelopesRedEnvelopesDetailViewController will be presented.
// For some reason, two instances of this controller are created, but only one will be presented, whereas the 
// other will be instantly deallocated.
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    %orig;

    __weak __typeof(self) weakSelf = self;
    void (^dismissBlock)() = ^void() {
        NSInteger randomNumber = (arc4random() % 89) + 1;
        NSTimeInterval time = 0.6 + (randomNumber * 0.001);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    };

    if ([SWXSettingsUsecase sharedUsecase].autoOpenEnvelopesEnabled && 
        [viewControllerToPresent isKindOfClass:NSClassFromString(@"UIAlertController")]) {
        // Would be used in the future for showing package opening error
        // when they finally remove the deprecated UIAlertView 
        if (isOpeningPackage) {
            dismissBlock();
        }
        isOpeningPackage = NO;
        currentSvrID = nil;
        return;
    }

    if (![SWXSettingsUsecase sharedUsecase].autoOpenEnvelopesEnabled || 
        ![viewControllerToPresent isKindOfClass:NSClassFromString(@"UINavigationController")]) { 
        return; 
    }

    UINavigationController *navVC = (UINavigationController *)viewControllerToPresent;
    if (![navVC.visibleViewController isKindOfClass:NSClassFromString(@"WCRedEnvelopesRedEnvelopesDetailViewController")]) { 
        return; 
    }

    dismissBlock();
}

%end


// Open Package after delay
%hook WCRedEnvelopesReceiveHomeView

- (id)initWithFrame:(CGRect)arg1 andData:(id)arg2 delegate:(id)arg3 {
    self = %orig;

    BOOL shouldOpen = YES;

    UIButton *openButton = MSHookIvar<UIButton *>(self, "openRedEnvelopesButton");
    if (openButton && openButton.hidden) {
        shouldOpen = NO;
    }

    if ([SWXSettingsUsecase sharedUsecase].autoOpenEnvelopesEnabled) { 
        NSInteger randomNumber = (arc4random() % 89) + 1;
        NSTimeInterval time = 0.35 + (randomNumber * 0.001);

        __weak __typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (shouldOpen) {
                if ([weakSelf respondsToSelector:@selector(OnOpenRedEnvelopes)]) {
                    [weakSelf OnOpenRedEnvelopes];
                }
            } else if ([weakSelf respondsToSelector:@selector(OnCancelButtonDone)]) {
                [weakSelf OnCancelButtonDone];
                isOpeningPackage = NO;
                if (currentSvrID) {
                    [[SWXStorage sharedStorage] addPackageID:currentSvrID];
                }
                currentSvrID = nil;
            }
        });
    }
    return self;
}

%end


// Make sure that SVR gets added even if auto open is disabled
%hook WCPayC2CMessageCellView

- (void)onTouchUpInside {
    %orig;
    if (currentSvrID) { return; }
    if (![self respondsToSelector:@selector(viewModel)]) { return; }
    if (![self.viewModel isKindOfClass:NSClassFromString(@"WCPayC2CMessageViewModel")]) { return; }
    WCPayC2CMessageViewModel *viewModel = (WCPayC2CMessageViewModel *)self.viewModel;
    if (![viewModel respondsToSelector:@selector(isSender)] || ![viewModel respondsToSelector:@selector(msgStatus)]) { return; }
    if (viewModel.isSender) { return; }
    if (![viewModel respondsToSelector:@selector(messageWrap)]) { return; }
    CMessageWrap *messageWrap = viewModel.messageWrap;
    if (![messageWrap respondsToSelector:@selector(m_n64MesSvrID)]) { return; }

    unsigned int svrID = messageWrap.m_n64MesSvrID;
    NSNumber *svrNumber = @(svrID);
    if (![[SWXStorage sharedStorage] containsPackageID:svrNumber]) {
        currentSvrID = svrNumber;
    }
}

%end


// Store and clear current SVR
@interface WCRedEnvelopesRedEnvelopesDetailViewController : UIViewController
@end


%hook WCRedEnvelopesRedEnvelopesDetailViewController

- (void)viewDidLoad {
    %orig;
    if (currentSvrID) {
        [[SWXStorage sharedStorage] addPackageID:currentSvrID];
    }
    currentSvrID = nil;
}

%end


// Alert would be shown if opening package failed
%hook UIAlertView 

- (void)show {
    %orig;
    if (isOpeningPackage) {
        NSInteger randomNumber = (arc4random() % 68) + 1;
        NSTimeInterval time = 0.35 + (randomNumber * 0.001);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
    isOpeningPackage = NO;
    currentSvrID = nil;
}

%end


//App delegate
%hook MicroMessengerAppDelegate

- (void)applicationWillResignActive:(UIApplication *)application {
    [[SWXStorage sharedStorage] synchronize];
    %orig;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[SWXStorage sharedStorage] synchronize];
    %orig;
}

%end
