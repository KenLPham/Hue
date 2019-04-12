#import "../Headers/CKUITheme.h"
#import <CSColorPicker/CSColorPicker.h>
#import "../Hue.h"

@interface HueThemeBase: CKUITheme
// MARK: Hue Override
- (id) themeBackground;
- (id) themeAppTint;

- (id) themeIMText;
- (id) themeSMSText;
- (id) themeRecvrText;

- (NSArray*) themeIMGradient;
- (NSArray*) themeSMSGradient;
- (NSArray*) themeRecvrGradient;

- (id) themeDarkText; // text that is on a light background
- (id) themeSubText; // text that is by default gray

// MARK: Hue Private
- (id) backgroundColor;

@end