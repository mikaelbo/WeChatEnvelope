#import "SWXSettingsViewController.h"


@interface MMUINavigationController : UINavigationController
@end


@interface MoreViewController : UIViewController 
@end


%hook MoreViewController

- (void)viewDidLoad {
    %orig;
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(SWX_longPress:)];
    recognizer.minimumPressDuration = 0.25;
    [self.navigationController.navigationBar addGestureRecognizer:recognizer];
}

%new
- (void)SWX_longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan) { return; }
    MMUINavigationController *navVC = [[%c(MMUINavigationController) alloc] initWithRootViewController:[[SWXSettingsViewController alloc] init]];
    [self presentViewController:navVC animated:YES completion:nil];
}

%end
