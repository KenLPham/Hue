#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

#define kEnabledKey @"enabled"

#define kSenderKey @"sender_gradient"
#define kRecvrKey @"recvr_bubble"

#define kSenderText @"sender_text"
#define kRecvrText @"recvr_text"

@interface NSUserDefaults (Private)
- (void)setObject:(id)object forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface ContactThemeController : PSListController
@property (nonatomic, retain) NSMutableDictionary *theme;
@property (nonatomic, retain) NSMutableDictionary *allThemes;

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* defaults;
@end