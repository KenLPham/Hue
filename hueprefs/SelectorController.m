#include "SelectorController.h"

@implementation SelectorController
- (id) specifiers {
    return _specifiers;
}

- (void) loadFromSpecifier:(PSSpecifier *)specifier {
    self.sub = [specifier propertyForKey:@"HUE"];
    // NSString *prefix = [@"HUE" stringByAppendingString:sub];
    NSString *title = [specifier name];

    _specifiers = [[self loadSpecifiersFromPlistName:self.sub target:self] retain];

    //_specifiers = [[self loadSpecifiersFromPlistName:@"TestView" target:self] retain];

    //PSSpecifier *themes = [PSSpecifier preferenceSpecifierNamed:deviceName target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:PSListItemsController.class cell:PSLinkListCell edit:nil];
    //[self insertContiguousSpecifiers:routes afterSpecifierID:@"DevicesGroupCell" animated:NO];

    // for (PSSpecifier *theme in themes) {
        
    // }

    // if ([sub isEqualToString:@"Banners"]) {
    //     _specifiers = [[self loadSpecifiersFromPlistName:@"Notifications" target:self] retain];
    // } else {
    //     _specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];
    // }

    // for (PSSpecifier *specifier in _specifiers) {
    //     NSString *key = [specifier propertyForKey:@"key"];
    //     if (key) {
    //         [specifier setProperty:[prefix stringByAppendingString:key] forKey:@"key"];
    //     }

    //     NSMutableDictionary *dict = [specifier propertyForKey:@"libcolorpicker"];
    //     if (dict) {
    //         dict[@"key"] = [prefix stringByAppendingString:dict[@"key"]];
    //         [specifier setProperty:dict forKey:@"libcolorpicker"];
    //     }

    //     if ([specifier.name isEqualToString:@"%SUB_NAME%"]) {
    //         specifier.name = title;
    //     }

    //     [self reloadSpecifier:specifier];
    // }

    [self setTitle:title];
    [self.navigationItem setTitle:title];
}

- (void) setSpecifier:(PSSpecifier *)specifier {
	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (NSArray*) themeTitles {
    NSArray *titles = @[@"Stock", @"Dark"];
    return titles;
}

- (NSArray*) themeValues {
    NSArray *themes = nil;

    if ([self.sub containsString:@"BGView"]) {
        themes = [NSArray arrayWithObjects:@"#ffffff", @"#1c1c1c", nil];
    } else if ([self.sub containsString:@"TintView"]) {
        themes = [NSArray arrayWithObjects:@"#007aff", @"#7f007f", nil];
    }

    // Text
    // themes = @[@"#000000", @"#ffffff"];
    return @[@"#000000", @"#ffffff"];
}

@end