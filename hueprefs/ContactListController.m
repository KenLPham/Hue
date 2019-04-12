#include "ContactListController.h"

@implementation ContactListController
@synthesize defaults;

- (NSString*) formatName:(NSString*)name {
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

- (PSSpecifier*) createCell:(NSString*)name {
	NSString *key = [self formatName:name];
	
	PSSpecifier *cell = [PSSpecifier preferenceSpecifierNamed:name target:self set:NULL get:NULL detail:NSClassFromString(@"ContactThemeController") cell:PSLinkListCell edit:Nil];
	[cell setProperty:@YES forKey:PSEnabledKey];
	[cell setProperty:key forKey:PSKeyNameKey]; // name of recipient
	[cell setProperty:defaults forKey:PSDefaultsKey];

	return cell;
}

- (NSDictionary*) loadThemed {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", defaults];
	NSDictionary *themes = [NSDictionary dictionaryWithContentsOfFile:path];
	return themes;
}

- (NSArray*) specifiers {
	if (!_specifiers) {
		_specifiers = [[NSMutableArray alloc] init];

		PSSpecifier *themed = [PSSpecifier groupSpecifierWithName:@"Themed"];
		[_specifiers addObject:themed];

		PSSpecifier *contacts = [PSSpecifier groupSpecifierWithName:@"Contact List"];
		[_specifiers addObject:contacts];

		// Contact List
		NSError* contactError;

		// Load settings to get a list of names
		NSDictionary *themedContacts = [self loadThemed];

		CNContactStore *store = [[CNContactStore alloc] init];
		NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey];
		CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];

		[store enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact *contact, BOOL *stop) {
			NSString *name = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
			NSString *key = [self formatName:name];

			if ([themedContacts objectForKey:key]){
				[_specifiers insertObject:[self createCell:name] atIndex:1];
			} else {
				[_specifiers addObject:[self createCell:name]];
			}
		}];
	}

    return _specifiers;
}

- (void)setSpecifier:(PSSpecifier *)specifier {
	// Set key
	defaults = [specifier propertyForKey:PSDefaultsKey];
	[super setSpecifier:specifier];
}

@end