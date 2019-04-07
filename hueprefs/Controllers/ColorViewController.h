#import "../Headers/CSColorPickerViewController.h"
#import "../BubbleController.h"
#import "../Cells/ColorListCell.h"

@interface ColorViewController: CSColorPickerViewController
@property (nonatomic) SEL saveAction;
@property (nonatomic, retain) BubbleController *bubble;
@end