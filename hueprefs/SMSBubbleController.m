#import "SMSBubbleController.h"

@implementation SMSBubbleController
@synthesize colors;
@synthesize settings;

- (void) updateColor:(PSSpecifier*)specifier {
	NSString *key = [specifier name];
	NSString *hex = [specifier propertyForKey:@"hexValue"];
	[colors setValue:hex forKey:key];
}

- (PSSpecifier*) createCell:(NSString*)key hexValue:(NSString*)hex {
	UIColor *color = [UIColor colorFromHexString:hex];

	PSSpecifier *cell = [PSSpecifier preferenceSpecifierNamed:key target:self set:NULL get:NULL detail:Nil cell:PSLinkListCell edit:Nil];
	[cell setProperty:@YES forKey:@"enabled"];
	[cell setProperty:NSClassFromString(@"ColorListCell") forKey:PSCellClassKey];
	[cell setProperty:NSStringFromSelector(@selector(updateColor:)) forKey:@"saveAction"];
	[cell setProperty:@"com.kayfam.hueprefs" forKey:PSDefaultsKey];
	[cell setProperty:@"/Library/PreferenceBundles/HuePrefs.bundle" forKey:@"defaultsPath"];
	[cell setProperty:hex forKey:@"fallback"];
	[cell setProperty:@true forKey:@"alpha"];

	// Manually set Color
	[cell setProperty:hex forKey:@"hexValue"];
	[cell setProperty:color forKey:@"color"];

	return cell;
}

- (void) addCell:(NSString*)hex {
	// Create title
	long index = [_specifiers count] - 4; // 6 with the presetGroup and rainbowpreset button
	NSString *cellName = [NSString stringWithFormat:@"Color %ld", index];

	// Create new cell
	PSSpecifier *newCell = [self createCell:cellName hexValue:hex];

	// Add to colors dictionary
	NSString *hexVal = [newCell propertyForKey:@"hexValue"] ? : [newCell propertyForKey:@"fallback"]; // @"FFFFFF"
	[colors setValue:hexVal forKey:cellName];

	// Add cell to pane
	[self insertSpecifier:newCell atEndOfGroup:0];
	[self reloadSpecifier:newCell animated:true];
}

- (void) addCell {
	[self addCell:@"FFFFFF"];
}

- (void) load {
	if (!settings) {
		settings = [[NSMutableDictionary alloc] init];
		NSDictionary *stored = [NSDictionary dictionaryWithContentsOfFile:kPrefsPlistPath];

		for (NSString *key in stored) {
			id value = [stored objectForKey:key];
			[settings setObject:value forKey:key];
		}
	}

	if (!colors) {
		colors = [[NSMutableDictionary alloc] init];

		// get color json string from plist
		NSString *colorJson = [settings objectForKey:@"sms_sender_colors"];

		// convert json string to array
		if (colorJson) {
			NSData* data = [colorJson dataUsingEncoding:NSUTF8StringEncoding];
			NSError *error = nil;
			NSArray *hexArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

			// add hex values to color dictionary
			for (long i = 0; i < [hexArray count]; i++) {
				NSString *key = [NSString stringWithFormat:@"Color %ld", i];
				NSString *hex = [hexArray objectAtIndex:i];

				[colors setObject:hex forKey:key];
			}
		}
	}
}

- (void) save {
	NSMutableArray *hexArray = [[NSMutableArray alloc] init];

	// Store hex values into an array
	for (NSString *key in colors) {
		NSString *hex = [colors objectForKey:key];
		[hexArray addObject:hex];
	}

	// Convert array into json string
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:hexArray options:kNilOptions error:&error];
	NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	
	// Add to settings dictionary and write to file
	if (!error) {
		// save to plist
		[settings setObject:jsonString forKey:@"sms_sender_colors"];
		[settings writeToFile:kPrefsPlistPath atomically:false];

		// save to cfpreferences
		CFPreferencesSetValue((__bridge CFStringRef)@"sms_sender_colors", (__bridge CFPropertyListRef)jsonString, (__bridge CFStringRef)@"com.kayfam.hueprefs", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    	CFPreferencesSynchronize((__bridge CFStringRef)@"com.kayfam.hueprefs", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

    	// save to nsuserdefaults
    	[[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:@"sms_sender_colors" inDomain:@"com.kayfam.hueprefs"];
	}
}

- (NSArray*) specifiers {
	if (!_specifiers) {
		// get data from plist
		[self load];

		_specifiers = [[NSMutableArray alloc] init];

		// create Bubble Color group
		PSSpecifier *colorGroup = [PSSpecifier groupSpecifierWithName:@"Colors"];
		[_specifiers addObject:colorGroup];

		for (NSString *key in colors) {
			NSString *hex = colors[key];

			// create specifiers
			PSSpecifier *stored = [self createCell:key hexValue:hex];
			[_specifiers addObject:stored];
		}

		// button group
		PSSpecifier *empty = [PSSpecifier emptyGroupSpecifier];
		[_specifiers addObject:empty];

		PSSpecifier *addButton = [PSSpecifier preferenceSpecifierNamed:@"Add Color" target:self set:NULL get:NULL detail:Nil cell:PSButtonCell edit:Nil];
		addButton->action = @selector(addCell);
		[_specifiers addObject:addButton];

		PSSpecifier *saveButton = [PSSpecifier preferenceSpecifierNamed:@"Save" target:self set:NULL get:NULL detail:Nil cell:PSButtonCell edit:Nil];
		saveButton->action = @selector(save);
		[_specifiers addObject:saveButton];

		// Presets
		/*
		PSSpecifier *presetGroup = [PSSpecifier groupSpecifierWithName:@"Presets"];
		[_specifiers addObject:presetGroup];

		PSSpecifier *presetOne = [PSSpecifier preferenceSpecifierNamed:@"Rainbow" target:self set:NULL get:NULL detail:Nil cell:PSButtonCell edit:Nil];
		presetOne->action = @selector(setPreset);
		[_specifiers addObject:presetOne];
		*/
	}
	return _specifiers;
}

- (void) remove:(PSSpecifier*)specifier {
	// remove from color dictionary
	if ([specifier name]) {
		[colors removeObjectForKey:[specifier name]];
	}
}

/*
- (void) setPreset {
	// clear colors dictionary
	[colors removeAllObjects];

	// clear specifiers
	for (PSSpecifier* specifier in _specifiers) {
		if (![specifier name]) { return; } // at empty group, stop removing

		if ([[specifier name] containsString:@"Color"]) {
			[self removeSpecifier:specifier];
		}
	}

	id objects[] = { @"E55451", @"F87217", @"FDD017", @"8AFB17", @"3090C7", @"461B7E" };
	NSUInteger count = sizeof(objects) / sizeof(id);
	NSArray *rainbow = [NSArray arrayWithObjects:objects count:count];

	// Get hex value from NSArray
	for (NSString* hex in rainbow) {
		[self addCell:hex];
	}
	
	// Auto save?
	// [self save];
}
*/

- (void) tableView:(id)arg1 commitEditingStyle:(UITableViewCellEditingStyle)arg2 forRowAtIndexPath:(NSIndexPath*)arg3 {
	if (arg2 == UITableViewCellEditingStyleDelete) {
		[self remove:_specifiers[arg3.row]];
	}
	[super tableView:arg1 commitEditingStyle:arg2 forRowAtIndexPath:arg3];
}

- (UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
	return UITableViewCellEditingStyleDelete;
}
@end