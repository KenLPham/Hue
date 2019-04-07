#import "Headers/CKTranscriptCollectionView.h"
#import "Headers/IMTypingIndicatorLayer.h"

#import "Headers/CKConversationListStandardCell.h"

#import "Headers/CKColoredBalloonView.h"
#import "Headers/CKConversationListTableView.h"
#import "Headers/CKLabel.h"

#import "Headers/CKBalloonView.h"

#import "CKUITheme.h"
#import "Headers/LPTheme.h"

#import "Headers/LPLinkView.h"
#import "Headers/LPImageView.h"

#import "Headers/CKMessageEntryView.h"

#import "Hue.h"
#import "Themes/HueThemeDark.h"
#import "Themes/HueThemeStyle.h"
#import "Themes/HueThemeBlack.h"

// Transparent Background
#import "Headers/SMSApplication.h"
#import "Headers/CKMessagesController.h"

// Contact Specific Themes
#import <ChatKit/CKConversation.h>

/*
Selecting Conversations to delete messages looks all fucked
*/

%group HueStyle

/*
UIBackgroundStyleDefault,
UIBackgroundStyleTransparent,
UIBackgroundStyleLightBlur,
UIBackgroundStyleDarkBlur,
UIBackgroundStyleDarkTranslucent
*/

// Transparent Background
%hook SMSApplication
- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
	BOOL result = %orig;

	// @"style_none", @"style_trap", @"style_light", @"style_dark", @"style_tral"
	if ([style() isEqualToString:@"style_trap"]) {
		[application _setBackgroundStyle:UIBackgroundStyleTransparent];
	} else if ([style() isEqualToString:@"style_light"]) {
		[application _setBackgroundStyle:UIBackgroundStyleLightBlur];
	} else if ([style() isEqualToString:@"style_dark"]) {
		[application _setBackgroundStyle:UIBackgroundStyleDarkBlur];
	} else if ([style() isEqualToString:@"style_tral"]) {
		[application _setBackgroundStyle:UIBackgroundStyleDarkTranslucent];
	}

	UIWindow *window = MSHookIvar<UIWindow*>(application, "_window");
	[window setBackgroundColor:[UIColor clearColor]];
	[window setOpaque:NO];

	return result;
}

- (void) _setBackgroundStyle:(UIBackgroundStyle)style {
	%orig(style);
}
%end

%hook CKMessagesController
- (void) viewDidLoad {
	%orig;
	[self.view setOpaque:NO];
	[self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]]; // alpha of 0 will make is not able to register touches
}
%end

%end // End of HueStyle group

%group HueTheme

// Set Themes
%hook CKUIBehaviorPhone
- (id) theme {
	if ([theme() isEqual:@"theme_dark"]) {
		HueThemeDark *theme = [[%c(HueThemeDark) alloc] init];
		return theme;
	} else if ([theme() isEqual:@"theme_black"]) {
		HueThemeBlack *theme = [[%c(HueThemeBlack) alloc] init];
		return theme;
	}

	if (enableStyle()) { // Stock Transparent
		HueThemeStyle *theme = [[%c(HueThemeStyle) alloc] init];
		return theme;
	}
	return %orig; // Stock
}
%end

%hook CKUIBehaviorPad
- (id) theme {
	if ([theme() isEqual:@"theme_dark"]) {
		HueThemeDark *theme = [[%c(HueThemeDark) alloc] init];
		return theme;
	} else if ([theme() isEqual:@"theme_black"]) {
		HueThemeBlack *theme = [[%c(HueThemeBlack) alloc] init];
		return theme;
	}

	if (enableStyle()) { // Stock Transparent
		HueThemeStyle *theme = [[%c(HueThemeStyle) alloc] init];
		return theme;
	}

	return %orig; // Stock
}
%end

// %hook CKBalloonView
// - (bool) isFilled {
// 	return false;
// }

// - (bool) hasOverlay {
// 	return false;
// }

// - (bool) wantsSkinnyMask {
// 	return false;
// }

// - (bool) canUseOpaqueMask {
// 	return true;
// }
//%end

// %hook CKColoredBalloonView
// - (bool) hasBackground {
// 	return false;
// }
// %end

// Unfilled bubbles do no work for gradients, or invisible ink
// %hook CKBalloonView
// - (bool) isFilled { // unfils Spotify bubbles too...
// 	return false;
// }

// - (bool) wantsSkinnyMask {
// 	return false;
// }
// %end

%hook CKUITheme
// Tint
- (id) appTintColor {
	return useCustomBubble() ? tintColor() : %orig;
}

// IM Sender
- (id) blue_balloonColors {
	NSArray *colorArray = IMSenderColors();
	return (useCustomBubble() && colorArray) ? colorArray : %orig;
}

- (id) blue_balloonTextColor {
	return useCustomBubble() ? imTextColor() : %orig;
}

// SMS Sender
- (id) green_balloonColors {
	NSArray *colorArray = useIMBubble() ? IMSenderColors() : SMSSenderColors();
	return (useCustomBubble() && colorArray) ? colorArray : %orig;
}

- (id) green_balloonTextColor {
	return useCustomBubble() ? smsTextColor() : %orig;
}

// Recipient
- (id) gray_balloonColors {
	if (useCustomBubble()) {
		NSMutableArray *colors = [[NSMutableArray alloc] init];
		[colors addObject:RecColor()];

		return colors;
	} else if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		NSMutableArray *colors = [[NSMutableArray alloc] init];
		[colors addObject:[UIColor grayColor]];

		return colors;
	} else {
		return %orig;
	}
}

- (id) gray_balloonTextColor {
	return useCustomBubble() ? recTextColor() : (([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) ? [UIColor whiteColor] : %orig);
}
%end

%hook CKMessageEntryView
// 0 = white, transparent
// 1 = dark, unreadable, transparent
// 2 = dark, readable, transparent
// 4 = default
- (void) setStyle:(long long)arg1 {
	if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		%orig(2);
	} else {
		%orig;
	}
}
%end

// Theme Links and App bubbles
%hook LPTheme
- (id) backgroundColor {
	if (useCustomBubble()) {
		return RecColor();
	} else if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		return [UIColor grayColor];
	} else {
		return %orig;
	}
}

// - (id) highlightColor {
// 	return [UIColor purpleColor];
// }

- (id) mediaBackgroundColor {
	if (useCustomBubble()) {
		return RecColor();
	} else if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		return [UIColor grayColor];
	} else {
		return %orig;
	}
}
%end

%hook LPTapToLoadViewStyle
- (id) backgroundColor {
	if (useCustomBubble()) {
		return RecColor();
	} else if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		return [UIColor lightGrayColor];
	} else {
		return %orig;
	}
}
%end

%hook LPTextViewStyle
- (id) color {
	if (useCustomBubble()) {
		return recTextColor();
	} else if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		return [UIColor whiteColor];
	} else {
		return %orig;
	}
}
%end

%hook UINavigationBar
// 0 = light transparent
// 1 = dark transparent
- (void) _setBarStyle:(int)style {
	if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		%orig(1);
	} else {
		%orig;
	}
}
%end

%hook CKAvatarTitleCollectionReusableView
// 1 = gray, 2 = white, 4 = black (default)
- (void) setStyle:(int)style {
	if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		%orig(2);
	} else {
		%orig;
	}
}
%end

// Typing Indicator
%hook IMTypingIndicatorLayer
- (id) bubbleColor {
	if (useCustomBubble()) {
		return RecColor();
	} else if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		return [UIColor grayColor];
	} else {
		return %orig;
	}
}

- (id) thinkingDotColor {
	if (useCustomBubble()) {
		return recTextColor();
	} else if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		return [UIColor whiteColor];
	} else {
		return %orig;
	}	
}
%end

// Makes it render as a template so a tintColor can be used
%hook CKConversationListStandardCell
- (void) updateUnreadIndicatorWithImage:(UIImage*)arg1 {
	UIImage *replacement = [arg1 imageWithRenderingMode:2];
	%orig(replacement);
}
%end

// ISSUE: Causes a crash when opening a conversation
// Composing new message NavBar title color

%hook CKNavigationBarCanvasView
- (void) setTitleView:(UIView*)title {
	if ([title isKindOfClass:[UILabel class]]) {
		if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
			UILabel *label = (UILabel*)title;
			[label setTextColor:[UIColor whiteColor]];

			%orig(label);
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}
%end


// Bar the the bottom of the screen when deleting conversations
%hook UIToolbar
// 0 = white (default)
- (NSInteger) barStyle {
	return ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) ? 1 : 0;
}
%end

// Change the "To:" text color when composing a new message
%hook MFHeaderLabelView
+ (id) _defaultColor {
	if ([theme() isEqual:@"theme_dark"] || [theme() isEqual:@"theme_black"]) {
		return [UIColor whiteColor];
	} else {
		return %orig;
	}
}
%end

%hook MFModernAtomView
// iMessage
+ (id) _defaultTintColor {
	// if ([theme() isEqual:@"theme_dark"]) {
	// 	return [UIColor purpleColor];
	// } else {
	// 	return %orig;
	// }

	return useCustomBubble() ? [IMSenderColors() lastObject] : %orig;
}

+ (id) _SMSTintColor {
	// if ([theme() isEqual:@"theme_dark"]) {
	// 	return [UIColor colorWithRed:(48/255.0) green:(144/255.0) blue:(199/255.0) alpha:1.0];
	// } else {
	// 	return %orig;
	// }

	return useCustomBubble() ? [SMSSenderColors() lastObject] : %orig;
}
%end

%end // End of HueTheme Group

// doesnt work
// %hook CKEditableCollectionViewCell
// - (void) setCheckmark:(UIImageView*)check {
// 	UIImage *replacement = [[check image] imageWithRenderingMode:2];
// 	[check setImage:replacement];
// 	%orig(check);
// }
// %end

/*CNContactHeaderDisplayView
avatarStyle
0 = circle
1 = rounded rect

name label text color needs to be changed
background of tableview needs to be changed

*/

// Background colors dont change, but the separatorColor does
/*
static UIColor *bgColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:1.0];

%hook CNContactView
- (id) backgroundColor {
	return bgColor;
}

- (id) sectionBackgroundColor {
	return bgColor;
}

- (id) selectedCellBackgroundColor {
	return bgColor;
}

- (id) separatorColor {
	return [UIColor clearColor];
}
%end
*/

// Dividers
// [UIColor colorWithRed:(69/255.0) green:(71/255.0) blue:(81/255.0) alpha:1.0];

%group HueContact

%hook CKMessagesController

// Get name of recipient [SUCCESS]
- (id) currentConversation {
	CKConversation *convo = %orig;

	// if convo is nil, make recipient nil

	NSString *recipient = [convo name];
	NSLog(@"%@", recipient);

	return %orig;
}

%end

%end // End of HueContact group

// %group HueHide
// %end // End of HueHide group

// %group HuePin
// %end // End of HuePin group

%ctor {
	@autoreleasepool {
		NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
		NSUInteger count = args.count;
		if (count != 0) {
			NSString *executablePath = args[0];
			if (executablePath) {
				NSString *processName = [executablePath lastPathComponent];
				BOOL isSpringBoard = [processName isEqualToString:@"SpringBoard"];
				BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;

				if (((isSpringBoard || isApplication) && [processName isEqualToString:@"MobileSMS"]) && isEnabled()) {
					%init(HueTheme);
					if (1 == 0) { // lol
						%init(HueContact);
					}

					if (enableStyle()) {
						%init(HueStyle);
					}
				}
			}
		}
	}
}