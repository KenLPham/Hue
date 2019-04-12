#import "HueColorCell.h"

#define UIViewParentController(__view) ({ UIResponder *__responder = __view; while ([__responder isKindOfClass:[UIView class]]) __responder = [__responder nextResponder]; (UIViewController *)__responder; })

@implementation HueColorCell
- (void) openColorPickerView {
	ContactThemeController *viewController = nil;
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

	if (vc && [vc isKindOfClass:[ContactThemeController class]]) {
	    viewController = (ContactThemeController*)vc;
	} else {
	    return;
	}


	HueColorViewController *colorViewController = [[HueColorViewController alloc] init];

	colorViewController.view.frame = viewController.view.frame;
	colorViewController.parentController = viewController;
	colorViewController.specifier = self.specifier;
	colorViewController.themeController = viewController;
	colorViewController.saveAction = NSSelectorFromString([self.specifier propertyForKey:@"saveAction"]); // HUE
	[viewController.navigationController pushViewController:colorViewController animated:YES];
}
@end