#import "SWXSettingsViewController.h"

@interface NewSettingViewController: UIViewController
- (void)reloadTableData;
@end

@interface MMTableViewInfo : NSObject
- (id)getTableView;
- (void)clearAllSection;
- (void)addSection:(id)arg1;
- (void)insertSection:(id)arg1 At:(unsigned int)arg2;
- (id)getSectionAt:(unsigned int)arg1;
@end

@interface MMTableViewSectionInfo : NSObject
+ (id)sectionInfoDefaut;
+ (id)sectionInfoHeader:(id)arg1;
+ (id)sectionInfoHeader:(id)arg1 Footer:(id)arg2;
- (void)addCell:(id)arg1;
@end

@interface MMTableViewCell : UITableViewCell
@end

@interface MMTableViewCellInfo : NSObject
@property(nonatomic) __weak MMTableViewCell *cell;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 accessoryType:(long long)arg4;
+ (id)switchCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 on:(_Bool)arg4;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 rightValue:(id)arg4 accessoryType:(long long)arg5;
+ (id)normalCellForTitle:(id)arg1 rightValue:(id)arg2;
+ (id)urlCellForTitle:(id)arg1 url:(id)arg2;
@end

@interface MMTableView: UITableView
@end

@interface MMUINavigationController : UINavigationController
@end


%hook NewSettingViewController

- (void)reloadTableData {
    %orig;
    MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");

    if (!tableViewInfo) { return; }
    if (![tableViewInfo respondsToSelector:@selector(getSectionAt:)] || ![tableViewInfo respondsToSelector:@selector(getTableView)]) { return; }
    if (![%c(MMTableViewCellInfo) respondsToSelector:@selector(normalCellForSel:target:title:accessoryType:)]) { return; }

    MMTableViewSectionInfo *sectionInfo = [tableViewInfo getSectionAt:0];
    MMTableViewCellInfo *settingCell = [%c(MMTableViewCellInfo) normalCellForSel:@selector(SWX_pushSettings) 
                                                                          target:self 
                                                                           title:@"WeChat Envelope" 
                                                                   accessoryType:1];

    [sectionInfo addCell:settingCell];
    MMTableView *tableView = [tableViewInfo getTableView];
    [tableView reloadData];
}

%new
- (void)SWX_pushSettings {
    [self.navigationController pushViewController:[[SWXSettingsViewController alloc] init] animated:YES];
}

%end
