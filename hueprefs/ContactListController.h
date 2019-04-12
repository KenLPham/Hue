#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Contacts/CNContactStore.h>
#import <Contacts/CNContactFetchRequest.h>
#import <Contacts/CNContainer.h>

@interface ContactListController : PSListController
@property (nonatomic, retain) NSString* defaults;
@end