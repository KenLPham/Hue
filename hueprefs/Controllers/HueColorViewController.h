#import "../Headers/CSColorPickerViewController.h"
#import "../Cells/HueColorCell.h"
#import "../Cells/HueGradientCell.h"
#import "../ContactThemeController.h"

@interface HueColorViewController: CSColorPickerViewController
@property (nonatomic) SEL saveAction;
@property (nonatomic, retain) ContactThemeController *themeController;
@end