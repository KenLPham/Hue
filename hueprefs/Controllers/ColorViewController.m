#import "ColorViewController.h"

@implementation ColorViewController

- (void) saveColor {
	// Update color dictionary
	UIColor *color = [self colorForRGBSliders];
	NSString *hex = [UIColor hexStringFromColor:color alpha:YES];
	[self.specifier setProperty:hex forKey:@"hexValue"];
	[self.specifier setProperty:color forKey:@"color"];
	[_bubble performSelector:_saveAction withObject:self.specifier];

	// Update cell
	ColorListCell *cell = (ColorListCell*)[self.specifier propertyForKey:@"cellObject"];
	if (cell) [cell refreshCellWithColor:color];
}

@end