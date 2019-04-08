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
@end