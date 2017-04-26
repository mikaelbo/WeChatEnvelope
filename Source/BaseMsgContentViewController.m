#import "BaseMsgContentViewController.h"


@implementation UIViewController(SWX_extensions)

- (void)openRedPackageForCellView:(BaseChatCellView *)cellView {

}

- (void)openCellIfNeeded:(UITableViewCell *)cell {
    
}

- (UITableView *)visibleTableView {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            return (UITableView *)view;
        }
    }
    return nil;
}

@end
