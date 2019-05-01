#include "HUERootListController.h"

@implementation HUERootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
	return _specifiers;
}

- (NSArray*) themeTitles {
    NSArray *titles = @[@"Stock", @"Dark", @"Black (Beta)"];
    return titles;
}

- (NSArray*) themeValues {
    NSArray *themes = @[@"theme_stock", @"theme_dark", @"theme_black"];
    return themes;
}

- (NSArray*) styleTitles {
    NSArray *titles = @[@"Color", @"Transparent", @"Light Blur", @"Dark Blur", @"Dark Translucent"];
    return titles;
}

- (NSArray*) styleValues {
    NSArray *themes = @[@"style_none", @"style_trap", @"style_light", @"style_dark", @"style_tral"];
    return themes;
}

// ISSUE: You have to remove iMessage from AppSwitcher for the tweak to apply the transparent background
// Terminate MobileSMS
- (void) apply {
    NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:@[@"MobileSMS"]];
    [task launch];
}

- (void) respring {
    NSLog(@"[Hue] respring...");

    NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:@[@"backboardd"]];
    [task launch];
}

@end
