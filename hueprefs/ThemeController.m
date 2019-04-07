#include "ThemeController.h"

@implementation ThemeController

- (NSArray*) specifiers {
    return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    _specifiers = [[self loadSpecifiersFromPlistName:@"ThemeView" target:self] retain];

    [self setTitle:@"Themes"];
    [self.navigationItem setTitle:@"Themes"];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

@end