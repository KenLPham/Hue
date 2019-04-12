#import "ContactThemeController.h"

@implementation ContactThemeController
@synthesize name;
@synthesize defaults;

@synthesize theme;
@synthesize allThemes;

/* Info struct
	name {
		enabled->bool
		bubble_gradient->array
		text_color->hex string
		recipient_bubble->hex string
		recipient_text->hex string
	}
*/

/* sample theme dictionary Json
	{
		"sender_gradient":"FFBB27C4,FF3D63AE",
		"recvr_text":"FFFFA574",
		"sender_text":"FFFF967B",
		"enabled":true,
		"recvr_bubble":"FFAAAA34"
	}
*/


- (void) saveColor:(PSSpecifier*)specifier {
	NSString *hexString = [specifier propertyForKey:@"hexValue"];
	NSString *key = [specifier propertyForKey:PSKeyNameKey];
	[theme setObject:hexString forKey:key];
}

- (void) saveGradient:(PSSpecifier*)specifier {
	NSString *hexString = [specifier propertyForKey:@"hexValue"];
	NSString *key = [specifier propertyForKey:PSKeyNameKey];
	[theme setObject:hexString forKey:key];
}

- (NSMutableDictionary*) convertToDictionary:(NSString*)jsonString {
	// parse json string to dictionary
	NSError *error = nil;
	NSData *json = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&error];

	// make dictionary mutable
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	if (!error) {
		[ret addEntriesFromDictionary:dictionary];
	}

	return ret;
}

- (NSString*) convertToJson:(NSDictionary*)dictionary fallback:(NSString*)fallback {
	NSError *error = nil;
	NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
	
	if (!error) {
		NSString* jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
		return jsonString;
	} else {
		return fallback;
	}
}

- (void) loadSettings {
	if (!allThemes) {
		NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", defaults];
		
		NSDictionary *file = [NSMutableDictionary dictionaryWithContentsOfFile:path];
		allThemes = [[NSMutableDictionary alloc] init];

		if (file) {
			NSLog(@"[Hue] File exists, populating dictionary");
			[allThemes addEntriesFromDictionary:file];
		} else {
			NSLog(@"[Hue] File doesnt exist, using empty dictionary");
		}
	}

	// load up theme dictionary from settings
	if (!theme) {
		NSString *jsonString = [allThemes objectForKey:name];

		if (jsonString) {
			theme = [self convertToDictionary:jsonString];
		} else {
			NSLog(@"[Hue] %@ not found, creating empty dictionary", name);
			theme = [[NSMutableDictionary alloc] init];
		}
	}
}

- (NSArray*) specifiers {
	if (!_specifiers) {
		[self loadSettings];

		_specifiers = [[NSMutableArray alloc] init];
		PSSpecifier *empty = [PSSpecifier emptyGroupSpecifier]; // 0

		// 1
		PSSpecifier *enableCell = [PSSpecifier preferenceSpecifierNamed:@"Enable" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
		[enableCell setProperty:@YES forKey:PSEnabledKey];
		[enableCell setProperty:@NO forKey:PSDefaultValueKey];
		[enableCell setProperty:kEnabledKey forKey:PSKeyNameKey];
		[_specifiers addObject:enableCell];

		// Bubbles 2
		[_specifiers addObject:empty];

		// Gradient 3
		NSString *senderFallback = [theme objectForKey:kSenderKey] ?: @"2fd63f,3df74f"; // get value from storage or use default fallback

		PSSpecifier *senderBubble = [PSSpecifier preferenceSpecifierNamed:@"Sender Bubble" target:self set:nil get:nil detail:nil cell:PSLinkCell edit:nil];
		[senderBubble setProperty:@YES forKey:PSEnabledKey];
		[senderBubble setProperty:NSClassFromString(@"HueGradientCell") forKey:PSCellClassKey];
		[senderBubble setProperty:kSenderKey forKey:PSKeyNameKey];
		[senderBubble setProperty:NSStringFromSelector(@selector(saveGradient:)) forKey:@"saveAction"];
		[senderBubble setProperty:senderFallback forKey:@"fallback"];
		[senderBubble setProperty:@YES forKey:@"alpha"];
		[_specifiers addObject:senderBubble];

		// Color 4
		NSString *recvrFallback = [theme objectForKey:kRecvrKey] ?: @"aaaaaa";

		PSSpecifier *recvrBubble = [PSSpecifier preferenceSpecifierNamed:@"Recipient Bubble" target:self set:nil get:nil detail:nil cell:PSLinkCell edit:nil];
		[recvrBubble setProperty:@YES forKey:PSEnabledKey];
		[recvrBubble setProperty:NSClassFromString(@"HueColorCell") forKey:PSCellClassKey];
		[recvrBubble setProperty:kRecvrKey forKey:PSKeyNameKey];
		[recvrBubble setProperty:NSStringFromSelector(@selector(saveColor:)) forKey:@"saveAction"];
		[recvrBubble setProperty:recvrFallback forKey:@"fallback"];
		[recvrBubble setProperty:@YES forKey:@"alpha"];
		[_specifiers addObject:recvrBubble];

		// Text 5
		[_specifiers addObject:empty];

		// 6
		NSString *sendTextFallback = [theme objectForKey:kSenderText] ?: @"ffffff";

		PSSpecifier *senderText = [PSSpecifier preferenceSpecifierNamed:@"Sender Text Color" target:self set:nil get:nil detail:nil cell:PSLinkCell edit:nil];
		[senderText setProperty:@YES forKey:PSEnabledKey];
		[senderText setProperty:NSClassFromString(@"HueColorCell") forKey:PSCellClassKey];
		[senderText setProperty:kSenderText forKey:PSKeyNameKey];
		[senderText setProperty:NSStringFromSelector(@selector(saveColor:)) forKey:@"saveAction"];
		[senderText setProperty:sendTextFallback forKey:@"fallback"];
		[senderText setProperty:@YES forKey:@"alpha"];
		[_specifiers addObject:senderText];

		// 7
		NSString *recvrTextFallback = [theme objectForKey:kRecvrText] ?: @"ffffff";

		PSSpecifier *recvrText = [PSSpecifier preferenceSpecifierNamed:@"Recipient Text Color" target:self set:nil get:nil detail:nil cell:PSLinkCell edit:nil];
		[recvrText setProperty:@YES forKey:PSEnabledKey];
		[recvrText setProperty:NSClassFromString(@"HueColorCell") forKey:PSCellClassKey];
		[recvrText setProperty:kRecvrText forKey:PSKeyNameKey];
		[recvrText setProperty:NSStringFromSelector(@selector(saveColor:)) forKey:@"saveAction"];
		[recvrText setProperty:recvrTextFallback forKey:@"fallback"];
		[recvrText setProperty:@YES forKey:@"alpha"];
		[_specifiers addObject:recvrText];

		// Save Button 8
		[_specifiers addObject:empty];

		// 9
		PSSpecifier *saveButton = [PSSpecifier preferenceSpecifierNamed:@"Save" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
		[saveButton setProperty:@YES forKey:PSEnabledKey];
		saveButton->action = @selector(save);
		[_specifiers addObject:saveButton];
	}

    return _specifiers;
}

- (void) setSpecifier:(PSSpecifier *)specifier {
	// Set key
	name = [specifier propertyForKey:PSKeyNameKey]; // key name for theme dictionary
	defaults = [specifier propertyForKey:PSDefaultsKey]; // plist
	[super setSpecifier:specifier];
}

- (void) save {
	/* Specifiers
		0 = empty
		1 = enable cell
		2 = empty
		3 = sender gradient
		4 = recvr color
		5 = empty
		6 = sender text
		7 = recvr text
		8 = empty
		9 = save button
	*/

	// check if theme is missing keys, if so, fill with fallbacks
	if (![theme objectForKey:kEnabledKey]) {
		PSSpecifier *specifier = [_specifiers objectAtIndex:1];
		[theme setObject:[specifier propertyForKey:PSDefaultValueKey] forKey:kEnabledKey];
	}

	if (![theme objectForKey:kSenderKey]) {
		PSSpecifier *specifier = [_specifiers objectAtIndex:3];
		[theme setObject:[specifier propertyForKey:@"fallback"] forKey:kSenderKey];
	}

	if (![theme objectForKey:kRecvrKey]) {
		PSSpecifier *specifier = [_specifiers objectAtIndex:4];
		[theme setObject:[specifier propertyForKey:@"fallback"] forKey:kRecvrKey];
	}

	if (![theme objectForKey:kSenderText]) {
		PSSpecifier *specifier = [_specifiers objectAtIndex:6];
		[theme setObject:[specifier propertyForKey:@"fallback"] forKey:kSenderText];
	}

	if (![theme objectForKey:kRecvrText]) {
		PSSpecifier *specifier = [_specifiers objectAtIndex:7];
		[theme setObject:[specifier propertyForKey:@"fallback"] forKey:kRecvrText];
	}

	// convert theme dictionary to json
	NSString *fallback = @"{\"sender_gradient\":\"2fd63f,3df74f\",\"recvr_text\":\"ffffff\",\"sender_text\":\"ffffff\",\"enabled\":false,\"recvr_bubble\":\"aaaaaa\"}";
	NSString *themeJson = [self convertToJson:theme fallback:fallback];

	NSLog(@"[Hue] save %@ theme: %@", name, themeJson);

	// store json into allThemes dictionary with key=name
	[allThemes setObject:themeJson forKey:name];

	// write settings to file
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", defaults];
	if ([allThemes writeToFile:path atomically:true]) {
		NSLog(@"[Hue] Save successful");
	} else {
		NSLog(@"[Hue] Save failed");
	}
}

- (id) readPreferenceValue:(PSSpecifier*)specifier {
	NSString *key = [specifier propertyForKey:PSKeyNameKey];
	return [theme objectForKey:key] ?: [specifier propertyForKey:PSDefaultValueKey];
}

- (void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *key = [specifier propertyForKey:PSKeyNameKey];

	if ([key isEqual:kEnabledKey]) {
		[theme setObject:value forKey:key];
	}
}

@end