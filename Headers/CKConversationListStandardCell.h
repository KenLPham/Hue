@interface CKConversationListStandardCell : UITableViewCell
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;

- (void) updateUnreadIndicatorWithImage:(UIImage*)arg1;
- (id) conversation;
@end