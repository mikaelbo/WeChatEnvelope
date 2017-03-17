
@interface CMessageWrap : NSObject

@property (nonatomic) NSUInteger m_uiMesLocalID;
@property (nonatomic) long long m_n64MesSvrID;

@end


@interface WCPayC2CMessageViewModel : NSObject

@property (nonatomic, readonly) BOOL isSender;
@property (nonatomic, readonly) NSUInteger msgStatus;
@property (nonatomic, strong) CMessageWrap *messageWrap;

@end


@protocol MessageNodeViewDelegate <NSObject>

@optional
- (void)onHideKeyboard;

@end


@interface BaseChatCellView : UIView  //WCPayC2CMessageCellView

@property (nonatomic, weak) id <MessageNodeViewDelegate> delegate;
@property (nonatomic, readonly) id viewModel; //WCPayC2CMessageViewModel

@end


@interface WCPayC2CMessageCellView : BaseChatCellView

- (void)onTouchUpInside;

@end


@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, readonly) BaseChatCellView *cellView;

@end


@interface WCRedEnvelopesReceiveHomeView : UIView

- (void)OnOpenRedEnvelopes;
- (void)OnCancelButtonDone;

@end
