#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#include <CSColorPicker/CSColorPicker.h>

@interface NSUserDefaults (Private)
- (void)setObject:(id)object forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface PSEditableListController: PSListController
@end

#define kPrefsPlistPath @"/var/mobile/Library/Preferences/com.kayfam.hueprefs.plist"

@interface BubbleController : PSEditableListController
@property (nonatomic, retain) NSMutableDictionary *colors;
@property (nonatomic, retain) NSMutableDictionary *settings;

- (void) updateColor:(PSSpecifier*)specifier;
@end