#import "Hue.h"

@implementation Hue
+ (NSDictionary*) dictionary {
	if (!storage) {
		storage = [NSDictionary dictionaryWithContentsOfFile:kPrefsPlistPath];
	}
	return storage;
}

+ (NSString*) getPrefObject:(NSString*)key {
	return [[self dictionary] objectForKey:key];
}

+ (BOOL) getPrefBool:(NSString*)key {
	return [[[self dictionary] valueForKey:key] boolValue];
}

+ (NSString*) theme {
	return [self getPrefObject:kMainTheme] ?: @"theme_stock";
}

+ (NSString*) style {
	return [self getPrefObject:kStyle];
}

+ (BOOL) isEnabled {
	return [self getPrefBool:kPrefsEnabled];
}

+ (BOOL) enableStyle {
	NSString *style = [self style];
	return style ? ![style containsString:@"style_none"] : NO;
}

// not implemented
+ (BOOL) makeTransparent {
	return [self getPrefBool:kPrefsTransparent];
}

+ (BOOL) useIMBubble {
	return [self getPrefBool:kCopyIMColor];
}

+ (BOOL) useCustomColors {
	return [self getPrefBool:kCustomBubble];
}

+ (UIColor*) getColor:(NSString*)key fallback:(NSString*)fall {
	NSString *hex = [self getPrefObject:key];
	return [UIColor colorFromHexString:(hex ?: fall)];
}

+ (UIColor*) tintColor {
	return [self getColor:kTintColor fallback:@"007aff"];
}

+ (UIColor*) imTextColor {
	return [self getColor:kIMTextColor fallback:@"ffffff"];
}

+ (UIColor*) smsTextColor {
	return [self getColor:kSMSTextColor fallback:@"ffffff"];
}

+ (UIColor*) recTextColor {
	return [self getColor:kRecTextColor fallback:@"ffffff"];
}

+ (UIColor*) recColor {
	return [self getColor:kRecColor fallback:@"aaaaaa"];
}

+ (NSArray*) senderColors:(NSString*)key fallback:(NSString*)hex {
	NSString *stored = [self getPrefObject:key];

	NSArray<UIColor*> *colors = [(stored ?: hex) gradientStringColors];
	return colors;
}

+ (NSArray*) imSenderColors {
	NSString *fallback = @"4286F4,639EFF";
	return [self senderColors:kIMSenderColor fallback:fallback];

}

+ (NSArray*) smsSenderColors {
	NSString *fallback = @"2FD63F,3DF74F";
	return [self senderColors:kSMSSenderColor fallback:fallback];
}

// Contact Specific
+ (NSString*) formatName:(NSString*)name {
	// remove emojis
	NSError *error = nil;

	NSString *emojiPattern1 = @"[\\p{Emoji_Presentation}\\u26F1]"; //Code Points with default emoji representation
    NSString *emojiPattern2 = @"\\p{Emoji}\\uFE0F"; //Characters with emoji variation selector
    NSString *emojiPattern3 = @"\\p{Emoji_Modifier_Base}\\p{Emoji_Modifier}"; //Characters with emoji modifier
    NSString *emojiPattern4 = @"[\\U0001F1E6-\\U0001F1FF][\\U0001F1E6-\\U0001F1FF]"; //2-letter flags
    NSString *punctuationPattern = @"[.!?\\-'\";:,<>/’()]";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@|%@", emojiPattern1, emojiPattern2, emojiPattern3, emojiPattern4, punctuationPattern];

	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
	NSString *modified = [regex stringByReplacingMatchesInString:name options:0 range:NSMakeRange(0, [name length]) withTemplate:@""];

	// make name all lower case
	NSString *slammed = [modified lowercaseString];

	// remove spaces
	NSString *undertaker = [slammed stringByReplacingOccurrencesOfString:@" " withString:@""];

	return undertaker;
}

+ (NSDictionary*) convertToDictionary:(NSString*)jsonString {
	NSError *error = nil;

	NSData *json = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	if (json) {
		NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];

		return error ? [[NSDictionary alloc] init] : dictionary;
	}
	return [[NSDictionary alloc] init];
}

+ (void) setContact:(NSString*)name {
	// remove emojis
	NSString *formatted = [self formatName:name];

	// set name
	currentChat = formatted;
}

+ (NSString*) getContact {
	return currentChat;
}

// get json string from storage, then parse it into nsdictionary contactThemes
+ (NSDictionary*) themes {
	if (!contactThemes) {
		contactThemes = [NSDictionary dictionaryWithContentsOfFile:kContactsPlistPath] ?: [[NSDictionary alloc] init];
	}
	return contactThemes;
}

+ (NSDictionary*) currentTheme {
	NSString *storedTheme = [[self themes] objectForKey:[self getContact]];
	// NSLog(@"[Hue] %@ theme: %@", [self getContact], storedTheme);

	currentTheme = [self convertToDictionary:storedTheme];
	return currentTheme;
}

+ (BOOL) contactHasTheme {
	if ([self getContact] == nil) { return NO; }

	BOOL hasTheme = [[self currentTheme] count] > 0;
	BOOL enabled = [[[self currentTheme] valueForKey:@"enabled"] boolValue];
	return (hasTheme && enabled);
}

+ (NSArray*) contactSenderBubble {
	NSArray<UIColor*> *colors = [[[self currentTheme] objectForKey:@"sender_gradient"] gradientStringColors];
	return colors;
}

+ (UIColor*) themeColor:(NSString*)key {
	NSString *hex = [[self currentTheme] objectForKey:key];
	return [UIColor colorFromHexString:hex]; 
}

+ (NSArray*) contactRecvrBubble {
	return @[ [self themeColor:@"recvr_bubble"] ];
}

+ (UIColor*) contactSenderText {
	return [self themeColor:@"sender_text"];
}

+ (UIColor*) contactRecvrText {
	return [self themeColor:@"recvr_text"];
}
@end