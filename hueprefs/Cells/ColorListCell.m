#import "ColorListCell.h"

#define UIViewParentController(__view) ({ UIResponder *__responder = __view; while ([__responder isKindOfClass:[UIView class]]) __responder = [__responder nextResponder]; (UIViewController *)__responder; })

@implementation ColorListCell

// Implement my own way to set this
// use a selector that takes a specifier too
// - (UIColor *) previewColor {
// 	return [UIColor greenColor];
// }

// TODO: Store saveAction selector into PSSpecifier

- (void) openColorPickerView {
	// PSViewController *viewController = nil;
	BubbleController *viewController = nil;
	UIViewController *vc = nil;

	if ([self respondsToSelector:@selector(_viewControllerForAncestor)]) {
	    vc = [self performSelector:@selector(_viewControllerForAncestor)];
	}

	if (!vc) {
	    if ([self.specifier propertyForKey:@"parent"]) {
	        vc = [self.specifier propertyForKey:@"parent"];
	    } else {
	        vc = UIViewParentController(self);
	    }
	}

	// if (vc && [vc isKindOfClass:[PSViewController class]]) {
	//     viewController = (PSViewController*)vc;
	// } else {
	//     return;
	// }

	if (vc && [vc isKindOfClass:[BubbleController class]]) {
	    viewController = (BubbleController*)vc;
	} else {
	    return;
	}


	ColorViewController *colorViewController = [[ColorViewController alloc] init];

	if (self.specifier) {
	    colorViewController.specifier = self.specifier;
	}

	colorViewController.view.frame = viewController.view.frame;
	colorViewController.parentController = viewController;
	colorViewController.bubble = viewController;
	colorViewController.specifier = self.specifier;
	colorViewController.saveAction = NSSelectorFromString([self.specifier propertyForKey:@"saveAction"]); // HUE
	[viewController.navigationController pushViewController:colorViewController animated:YES];
}

@end