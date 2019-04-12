#include <CSColorPicker/CSColorPicker.h>

#define kPrefsPlistPath @"/var/mobile/Library/Preferences/com.kayfam.hueprefs.new.plist"
#define kContactsPlistPath @"/var/mobile/Library/Preferences/com.kayfam.hueprefs.contacts.plist"

#define kPrefsChanged "com.kayfam.hueprefs/settingschanged"

// Settings keys
#define kPrefsEnabled @"enable"

// not implemented
#define kPrefsTransparent @"transparent"

// theme keys
#define kMainTheme @"main_theme"

#define kStyle @"background_style"

// bubble keys
#define kCopyIMColor @"copy_im"
#define kCustomBubble @"custom_bubble"

#define kIMSenderColor @"im_sender_colors"
#define kSMSSenderColor @"sms_sender_colors"
#define kRecColor @"rec_color"

// text keys
#define kIMTextColor @"im_text_color"
#define kSMSTextColor @"sms_text_color"
#define kRecTextColor @"rec_text_color"

// not implemented
#define kBackgroundColor @"bg_color"

#define kTintColor @"tint_color"

static NSDictionary *storage;

// Contact Specific Theme
static NSString *currentChat = nil;
static NSDictionary *contactThemes; // plist
static NSDictionary *currentTheme;

@interface Hue: NSObject
+ (NSDictionary*) dictionary;

+ (NSString*) getPrefObject:(NSString*)key;
+ (BOOL) getPrefBool:(NSString*)key;

+ (NSString*) theme;
+ (NSString*) style;

+ (BOOL) isEnabled;
+ (BOOL) enableStyle;

+ (BOOL) makeTransparent; // not implemented

+ (BOOL) useIMBubble;
+ (BOOL) useCustomColors;

+ (UIColor*) getColor:(NSString*)key fallback:(NSString*)fall;

+ (UIColor*) tintColor;

+ (UIColor*) imTextColor;
+ (UIColor*) smsTextColor;
+ (UIColor*) recTextColor;

+ (UIColor*) recColor;

+ (NSArray*) senderColors:(NSString*)key fallback:(NSString*)hex;
+ (NSArray*) imSenderColors;
+ (NSArray*) smsSenderColors;

// Contact Specific Themes
+ (void) setContact:(NSString*)name;
+ (NSString*) getContact;

+ (NSDictionary*) themes;
+ (NSDictionary*) currentTheme;

+ (BOOL) contactHasTheme;

+ (NSArray*) contactSenderBubble;
+ (UIColor*) contactRecvrBubble;
+ (UIColor*) contactSenderText;
+ (UIColor*) contactRecvrText;
@end