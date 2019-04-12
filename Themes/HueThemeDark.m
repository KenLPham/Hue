#import "HueThemeDark.h"

@implementation HueThemeDark
// MARK: Hue
- (id) themeBackground {
	return [UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:1.0];
}

- (id) themeIMText {
	return [UIColor whiteColor];
}

- (id) themeRecvrText {
	return [UIColor whiteColor];
}

- (id) themeSMSText {
	return [UIColor whiteColor];
}

- (id) themeAppTint {
	return nil;
}

- (NSArray*) themeIMGradient {
	return nil;
}

- (NSArray*) themeSMSGradient {
	return nil;	
}

- (NSArray*) themeRecvrGradient {
	return @[ [UIColor grayColor] ];
}

- (id) themeDarkText {
	return [UIColor whiteColor];
}

- (id) themeSubText {
	return [UIColor whiteColor];
}

// MARK: CKUITheme

/* Personal Theme
IM Bubbles
Some red color, default purple

SMS
greenish blue, turqois blue?
*/

/*
- (id)grayTextColor;
- (id)gray_balloonOverlayColor;
- (id)gray_progressViewColor;
- (id)gray_recipientTextColor;
- (id)gray_sendButtonColor;
*/

// For attachment balloons (gray_balloonColors overrides this)
- (id) gray_unfilledBalloonColor {
	return [UIColor grayColor];
}


// Acknowledgement Bubble (gets overrided if gray_balloonTextColor has a second color) <- ??
- (id) messageAcknowledgmentPickerBackgroundColor {
	return [UIColor grayColor];
}

// Heart Color in Acknowledgment Picker
- (id) messageAcknowledgmentWhiteColor {
	return [UIColor grayColor];
}

// Heart Color in Acknowledgment Picker
- (id) messageAcknowledgmentGrayColor {
	return [UIColor whiteColor];
}

- (id) messageAcknowledgmentBalloonBorderColor {
	return [UIColor clearColor];
}

// idk
// - (id) transcriptDeemphasizedTextColor {
// 	return [UIColor redColor];
// }

// doesnt do shit
// - (long long) transcriptLoadingIndicatorStyle {
// 	return 2;
// }

// doesnt do shit
// - (id) stickerDetailsSubheaderTextColor {
// 	return [UIColor whiteColor];
// }

/*
- (id)transcriptBigEmojiColor;
- (id)transcriptNavBarTextColor;
- (id)transcriptSeparatorColor;
*/

- (id) browserLabelColor {
	return [UIColor whiteColor];
}

// idk
// - (id) browserSwitcherGutterColor {
// 	return [UIColor redColor];
// }

/*
- (id)browserAppStripSeperatorBackgroundColor;
- (id)browserSwitcherBorderColor;
- (id)browserSwitcherGutterDividerColor;
*/

/*
- (id)appGrabberCloseImage;
- (id)appSelectionOutline;
- (id)appSelectionOutlineColor;
- (id) appStripCoverFillColor
*/

// does nothing apparently
// - (id) appStripCoverFillColor {
// 	return [UIColor clearColor];
// }

- (id) appGrabberPillColor {
	return [UIColor whiteColor];
}

// Status bar color when app manager (...) is open
- (long long) appManagerStatusBarStyle {
	return 1;
}

// - (id)segmentedControlSelectionTintColor;

- (id) sharedContentsCellBackgroundColor {
	return [UIColor grayColor];
}

- (id) sharedContentsCellTextColor {
	return [UIColor whiteColor];
}

// 1 = dark
- (long long) keyboardAppearance {
	return 1;
}

- (long long) keyboardDarkAppearance {
	return 1;
}

// useless
// - (long long) entryViewStyle {
// 	return 1;
// }

// Text field when composing a new chat
- (long long) toFieldBackdropStyle {
	// 1 = dark
	return 1;
}

- (long long) navBarStyle {
	return 1;
}


- (long long) statusBarStyle {
	return 1;
}

- (id) toFieldTextColor {
	return [UIColor whiteColor];
}

/*
- (id)syncProgressIndeterminateProgressBarTintColor {}
- (id)syncProgressLabelColor {}
- (id)syncProgressUserActionButtonTextColor {}
- (id)syncProgressUserMessageColor {}
*/

- (id) entryFieldTextColor {
	return [UIColor whiteColor];
}

// Placeholder Text Color
- (id) entryFieldGrayColor {
	return [UIColor lightGrayColor];
}

// 0 = default (pErFeCT fOR aNy BaCKgRoUnD)
// 1 = black
// 2 = white
- (long long) scrollIndicatorStyle {
	return 2;
}


// Conversation Details

/*
0 = extraLight
1 = light
2 = dark
3 = extraDark
4 = regular
5 = prominent
*/
- (long long) detailsBackgroundBlurEffectStyle {
	return 2;
}

// Contact TableView when Composing a new chat
/*
- (id)searchResultsBackgroundColor {
	return [UIColor redColor];
}

- (id)searchResultsCellBackgroundColor {
	return [UIColor blueColor];
}

- (id)searchResultsCellSelectedColor {
	return [UIColor greenColor];
}

- (id)searchResultsSeperatorColor {
	return [UIColor yellowColor];
}
*/

// what the fuck does this do
// - (long long) defaultBarStyle {
// 	return 1;
// }

// Conversation audio/facetime/info button color
- (id) navBarGrayColor {
	return [UIColor whiteColor];
}
@end