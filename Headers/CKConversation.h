@interface CKConversation (Hue)
@property (getter=isPinned, nonatomic) bool pinned;

+ (bool) pinnedConversationsEnabled;

- (bool)isPinned;
- (void)setPinned:(bool)arg1;
@end