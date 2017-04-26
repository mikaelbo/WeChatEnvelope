@class BaseChatCellView;


@interface BaseMsgContentViewController : UIViewController
@end


@interface BaseMsgContentViewController(SWX_extensions)

- (void)openRedPackageForCellView:(BaseChatCellView *)cellView;
- (void)openCellIfNeeded:(UITableViewCell *)cell;
- (UITableView *)visibleTableView;

@end
