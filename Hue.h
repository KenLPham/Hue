//#import <libcolorpicker.h>
#include <CSColorPicker/CSColorPicker.h>

#define kPrefsPlistPath @"/var/mobile/Library/Preferences/com.kayfam.hueprefs.plist"
#define kPrefsChanged "com.kayfam.hueprefs/settingschanged"

// Settings keys
#define kPrefsEnabled @"enable"
#define kPrefsTransparent @"transparent"

// color keys
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

// methods
NSDictionary* dictionary () {
	if (!storage) {
		storage = [NSDictionary dictionaryWithContentsOfFile:kPrefsPlistPath];
	}
	return storage;
}

inline bool getPrefBool (NSString *key) {
	//return [[dictionary() valueForKey:key] boolValue];
	return [[[NSDictionary dictionaryWithContentsOfFile:kPrefsPlistPath] valueForKey:key] boolValue];
}

NSString* getPrefObject (NSString *key) {
	// return [dictionary() objectForKey:key];
	return [[NSDictionary dictionaryWithContentsOfFile:kPrefsPlistPath] objectForKey:key];
}

NSString* theme () {
	return getPrefObject(kMainTheme);
}

NSString* style () {
	return getPrefObject(kStyle);
}

inline bool isEnabled () {
	return getPrefBool(kPrefsEnabled);
}

inline bool enableStyle () {
	return ![style() isEqual:@"style_none"];
}

inline bool makeTransparent () {
	return getPrefBool(kPrefsTransparent);
}

inline bool useIMBubble () {
	return getPrefBool(kCopyIMColor);
}

inline bool useCustomBubble () {
	return getPrefBool(kCustomBubble);
}

// remove
UIColor* getColorOld (NSString *key, NSString *fallback) {
	NSString *hex = getPrefObject(key);
	//return LCPParseColorString(hex, fallback); // libcolorpicker
	return [UIColor colorFromHexString:hex]; // CSColorPicker
}

UIColor* getColor (NSString *key) {
	NSString *hex = getPrefObject(key);
	return [UIColor colorFromHexString:hex]; // CSColorPicker
}

// remove
UIColor* testColor () {
	return getColorOld(@"testKey", @"#ff0000");
}

// not implemented
UIColor* backgroundColor () {
	return getColorOld(kBackgroundColor, @"#ffffff");
}

UIColor* tintColor () {
	return getColor(kTintColor);
}

UIColor* imTextColor () {
	return getColor(kIMTextColor);
}

UIColor* smsTextColor () {
	return getColor(kSMSTextColor);
}

UIColor* recTextColor () {
	return getColor(kRecTextColor);
}

NSArray* senderColors (NSString *key) {
	NSString *jsonString = getPrefObject(key);
	NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

	if (data) {
		NSError *error = nil;
		NSArray *hexArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

		if (!error) {
			NSMutableArray *colorsArray = [[NSMutableArray alloc] init];

			for (NSString *hex in hexArray) {
				[colorsArray addObject:[UIColor colorFromHexString:hex]];
			}

			return colorsArray;
		}
		return nil;
	} else {
		return nil;
	}
}

UIColor* RecColor () {
	return getColor(kRecColor);
}

NSArray* IMSenderColors () {
	return senderColors(kIMSenderColor);
}

NSArray *SMSSenderColors () {
	return senderColors(kSMSSenderColor);
}