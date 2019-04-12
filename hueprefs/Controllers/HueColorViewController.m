#import "HueColorViewController.h"

@implementation HueColorViewController
@synthesize themeController;
@synthesize saveAction;

- (void) saveColor {
	NSString *saveValue = nil;

	if (self.isGradient) {
		for (UIColor *color in self.colors) {
			saveValue = saveValue ? [saveValue stringByAppendingFormat:@",%@", color.hexStringWithAlpha] : [NSString stringWithFormat:@"%@", color.hexStringWithAlpha];
		}

		[self.specifier setProperty:saveValue forKey:@"hexValue"];
	} else {
		UIColor *color = [self colorForRGBSliders];
		saveValue = color.hexStringWithAlpha;

		[self.specifier setProperty:saveValue forKey:@"hexValue"];
	}

	// Update color dictionary
	[themeController performSelector:saveAction withObject:self.specifier];

	// Update cell
	UITableViewCell *cell = [self.specifier propertyForKey:@"cellObject"];

	if (cell && [cell isKindOfClass:[HueColorCell class]]) {
		[(HueColorCell*)cell refreshCellWithColor:[self colorForRGBSliders]];
	} else if (cell && [cell isKindOfClass:[HueGradientCell class]]) {
		[(HueGradientCell*)cell refreshCellWithColors:self.colors];
	}
}
@end