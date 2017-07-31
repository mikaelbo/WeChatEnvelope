#import "SWXSettingsViewController.h"
#import "SWXSettingsUsecase.h"

#define BUNDLE_PATH @"/Library/Application Support/WeChatEnvelope/WeChatEnvelopeBundle.bundle"


@interface SWXSwitchCell : UITableViewCell

@property (nonatomic, strong) UISwitch *switchView;

@end


@implementation SWXSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:17];
        [self createSwitch];
    }
    return self;
}

- (void)createSwitch {
    self.switchView = [[UISwitch alloc] init];
    self.accessoryView = self.switchView;
}

@end


@interface SWXSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SWXSwitchCell *autoOpenEnvelopesCell;

@property (nonatomic) BOOL autoOpenEnabled;

@end


@implementation SWXSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    [self createTableView];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1];
    [self.view addSubview:self.tableView];
    [self addFooterView];
 }

- (void)addFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 170)];
    
    NSBundle *bundle = [[NSBundle alloc] initWithPath:BUNDLE_PATH];
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"WeChatEnvelope" ofType:@"png"]];
    CGSize size = image.size;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.tableView.frame.size.width - size.width) / 2,
                                                                           40,
                                                                           size.width,
                                                                           size.height)];
    imageView.image = image;
    [footerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               imageView.frame.origin.y + imageView.frame.size.height + 4,
                                                               self.tableView.frame.size.width,
                                                               24)];
    label.text = @"WeChat Envelope";
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    
    [footerView addSubview:label];
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                      label.frame.origin.y + label.frame.size.height,
                                                                      self.tableView.frame.size.width,
                                                                      17)];
    versionLabel.font = [UIFont systemFontOfSize:13];
    versionLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    versionLabel.text = @"Version 1.0.1";
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:versionLabel];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.autoOpenEnvelopesCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - Target action

- (void)autoOpenEnvelopesSwitchChanged:(UISwitch *)switchView {
    [SWXSettingsUsecase sharedUsecase].autoOpenEnvelopesEnabled = switchView.isOn;
}

#pragma mark - Cells

- (SWXSwitchCell *)autoOpenEnvelopesCell {
    if (!_autoOpenEnvelopesCell) {
        _autoOpenEnvelopesCell = [[SWXSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _autoOpenEnvelopesCell.switchView.onTintColor = [UIColor colorWithRed:26 / 255.0 green:175 / 255.0 blue:25 / 255.0 alpha:1];
        _autoOpenEnvelopesCell.textLabel.textColor = [UIColor blackColor];
        _autoOpenEnvelopesCell.textLabel.text = @"Auto open envelopes";
        _autoOpenEnvelopesCell.switchView.on = [SWXSettingsUsecase sharedUsecase].autoOpenEnvelopesEnabled;
        [_autoOpenEnvelopesCell.switchView addTarget:self action:@selector(autoOpenEnvelopesSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        _autoOpenEnvelopesCell.backgroundColor = [UIColor whiteColor];
    }
    return _autoOpenEnvelopesCell;
}

@end
