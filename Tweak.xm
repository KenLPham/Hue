#import <UIKit/UIKit.h>

#import "Headers/IMTypingIndicatorLayer.h"

#import "Headers/CKConversationListStandardCell.h"

#import "Headers/CKColoredBalloonView.h"
#import "Headers/CKConversationListTableView.h"
#import "Headers/CKLabel.h"

#import "Headers/CKBalloonView.h"

#import "Headers/CKUITheme.h"
#import "Headers/LPTheme.h"

#import "Headers/LPLinkView.h"
#import "Headers/LPImageView.h"

#import "Headers/CKMessageEntryView.h"

#import "Hue.h"
#import "Themes/HueThemeDark.h"
#import "Themes/HueThemeStyle.h"
#import "Themes/HueThemeBlack.h"

#import "Headers/CKConversationListController.h"

// Transparent Background
#import "Headers/SMSApplication.h"
#import "Headers/CKMessagesController.h"

// Contact Specific Themes
#import <ChatKit/CKConversation.h>

/*
Selecting Conversations to delete messages looks all fucked
going horizontal in chat then going back makes the navbar go back to white (leave chat window to fix)
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
	NSString *style = [Hue style]; // @"style_none", @"style_trap", @"style_light", @"style_dark", @"style_tral"

	if ([style isEqualToString:@"style_trap"]) {
		[application _setBackgroundStyle:UIBackgroundStyleTransparent];
	} else if ([style isEqualToString:@"style_light"]) {
		[application _setBackgroundStyle:UIBackgroundStyleLightBlur];
	} else if ([style isEqualToString:@"style_dark"]) {
		[application _setBackgroundStyle:UIBackgroundStyleDarkBlur];
	} else if ([style isEqualToString:@"style_tral"]) {
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

// Fix Search Results being unreadable
%hook UISearchController
- (void) viewDidLoad {
	%orig;

	UIBlurEffectStyle style = [[Hue theme] isEqual:@"theme_stock"] ? UIBlurEffectStyleLight : UIBlurEffectStyleDark;
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:blurEffectView atIndex:0];
}
%end

// Hide list before seguing
%hook CKConversationListController

- (void) viewWillAppear:(BOOL)arg1 {
	%orig;
	
	if (self.view) {
		[self.view setHidden:NO];
	}
}

- (void) viewWillDisappear:(BOOL)arg1 {
	%orig;
	
	if (self.view) {
		[self.view setHidden:YES];
	}
}
%end

%end // End of HueStyle group

%group HueTheme

// Set Themes
%hook CKUIBehaviorPhone
- (id) theme {
	NSString *currentTheme = [Hue theme];
	if ([currentTheme isEqual:@"theme_dark"]) {
		HueThemeDark *theme = [[%c(HueThemeDark) alloc] init];
		return theme;
	} else if ([currentTheme isEqual:@"theme_black"]) {
		HueThemeBlack *theme = [[%c(HueThemeBlack) alloc] init];
		return theme;
	}

	if ([Hue enableStyle]) { // Stock Transparent
		HueThemeStyle *theme = [[%c(HueThemeStyle) alloc] init];
		return theme;
	}
	return %orig; // Stock
}
%end

%hook CKUIBehaviorPad
- (id) theme {
	NSString *currentTheme = [Hue theme];
	if ([currentTheme isEqual:@"theme_dark"]) {
		HueThemeDark *theme = [[%c(HueThemeDark) alloc] init];
		return theme;
	} else if ([currentTheme isEqual:@"theme_black"]) {
		HueThemeBlack *theme = [[%c(HueThemeBlack) alloc] init];
		return theme;
	}

	if ([Hue enableStyle]) { // Stock Transparent
		HueThemeStyle *theme = [[%c(HueThemeStyle) alloc] init];
		return theme;
	}

	return %orig; // Stock
}
%end

// Makes it render as a template so a tintColor can be used
%hook CKConversationListStandardCell
- (void) updateUnreadIndicatorWithImage:(UIImage*)arg1 {
	UIImage *replacement = [arg1 imageWithRenderingMode:2];
	%orig(replacement);
}
%end

// Composing new message NavBar title color
%hook CKNavigationBarCanvasView
- (void) setTitleView:(UIView*)title {
	if ([title isKindOfClass:[UILabel class]]) {
		NSString *theme = [Hue theme];
		if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
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

%hook CKMessageEntryView
// 0 = white, transparent
// 1 = dark, unreadable, transparent
// 2 = dark, readable, transparent
// 4 = default
- (void) setStyle:(long long)arg1 {
	NSString *theme = [Hue theme];

	if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		%orig(2);
	} else {
		%orig;
	}
}
%end

// Bar the the bottom of the screen when deleting conversations
%hook UIToolbar
// 0 = white (default)
- (NSInteger) barStyle {
	NSString *theme = [Hue theme];
	return ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) ? 1 : 0;
}
%end

%hook CKAvatarTitleCollectionReusableView
// 1 = gray, 2 = white, 4 = black (default)
- (void) setStyle:(int)style {
	NSString *theme = [Hue theme];

	if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		%orig(2);
	} else {
		%orig;
	}
}
%end

%end // End of HueTheme Group

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

%group HueBubbles

// Remove if possible
%hook CKUITheme
// Tint
// - (id) appTintColor {
// 	return [Hue tintColor];
// }

// // IM Sender
// - (id) blue_balloonColors {
// 	return [Hue imSenderColors];
// }

// - (id) blue_balloonTextColor {
// 	return [Hue imTextColor];
// }

// // SMS Sender
// - (id) green_balloonColors {
// 	NSArray *colorArray = [Hue useIMBubble] ? [Hue imSenderColors] : [Hue smsSenderColors];
// 	return colorArray;
// }

// - (id) green_balloonTextColor {
// 	return [Hue smsTextColor];
// }

// // Recipient
// - (id) gray_balloonColors {
// 	NSMutableArray *colors = [[NSMutableArray alloc] init];
// 	[colors addObject:[Hue recColor]];

// 	return colors;
// }

// - (id) gray_balloonTextColor {
// 	return [Hue recTextColor];
// }
%end

// Theme Links and App bubbles
%hook LPTheme
- (id) backgroundColor {
	NSString *theme = [Hue theme];

	if ([Hue useCustomColors]) {
		return [Hue recColor];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor grayColor];
	} else {
		return %orig;
	}
}

// - (id) highlightColor {
// 	return [UIColor purpleColor];
// }

- (id) mediaBackgroundColor {
	NSString *theme = [Hue theme];

	if ([Hue useCustomColors]) {
		return [Hue recColor];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor grayColor];
	} else {
		return %orig;
	}
}
%end

%hook LPTapToLoadViewStyle
- (id) backgroundColor {
	NSString *theme = [Hue theme];

	if ([Hue useCustomColors]) {
		return [Hue recColor];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor lightGrayColor];
	} else {
		return %orig;
	}
}
%end

%hook LPTextViewStyle
- (id) color {
	NSString *theme = [Hue theme];

	if ([Hue useCustomColors]) {
		return [Hue recTextColor];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor whiteColor];
	} else {
		return %orig;
	}
}
%end

// Typing Indicator
%hook IMTypingIndicatorLayer
- (id) bubbleColor {
	NSString *theme = [Hue theme];

	if ([Hue useCustomColors]) {
		return [Hue recColor];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor grayColor];
	} else {
		return %orig;
	}
}

- (id) thinkingDotColor {
	NSString *theme = [Hue theme];

	if ([Hue useCustomColors]) {
		return [Hue recTextColor];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor whiteColor];
	} else {
		return %orig;
	}	
}
%end

// Change the "To:" text color when composing a new message
%hook MFHeaderLabelView
+ (id) _defaultColor {
	NSString *theme = [Hue theme];
	return ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) ? [UIColor whiteColor] : %orig;
}
%end

%hook MFModernAtomView
// iMessage
+ (id) _defaultTintColor {
	id tint = [[Hue imSenderColors] lastObject];
	return [Hue useCustomColors] ? tint : %orig;
}

+ (id) _SMSTintColor {
	id tint = [[Hue smsSenderColors] lastObject];
	return [Hue useCustomColors] ? tint : %orig;
}
%end

// ISSUE: Fucks up animation
// %hook UINavigationBar
// - (bool) isTranslucent {
// 	return ![[Hue theme] isEqual:@"theme_black"];
// }

// // Doesnt do anythin
// // - (long long) _barTranslucence {
// // 	return 2;
// // }
// %end

%end // End of HueBubbles Group

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
%hook CKConversationListController
- (void) tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2 {
	CKConversationListTableView *convoList = (CKConversationListTableView*)[self view];
	CKConversationListStandardCell *cell = [convoList cellForRowAtIndexPath:arg2];
	CKLabel *label = MSHookIvar<CKLabel*>(cell, "_fromLabel");

	[Hue setContact:label.text];
	NSLog(@"[Hue] Opening Chat with %@", [Hue getContact]);

	%orig;
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

				if (((isSpringBoard || isApplication) && [processName isEqualToString:@"MobileSMS"]) && [Hue isEnabled]) {
					NSLog(@"[Hue] Hue is enabled, injecting into MobileSMS");

					// Enable HueTheme Group
					if (![[Hue theme] containsString:@"theme_stock"] || [Hue enableStyle]) {
						NSLog(@"[Hue] Isn't using Stock theme, enabling HueTheme Group");
						%init(HueTheme);
					}

					// Enable HueBubbles Group
					if ([Hue useCustomColors]) {
						NSLog(@"[Hue] Using Custom Colors, enabling HueBubbles Group");
						%init(HueBubbles);
					}

					// Enable HueContact Group
					%init(HueContact);

					// Enable HueStyle Group
					if ([Hue enableStyle]) {
						NSLog(@"[Hue] Background style selected, enabling HueStyle Group");
						%init(HueStyle);
					}
				}
			}
		}
	}
}