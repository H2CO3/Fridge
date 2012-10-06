//
// ImportViewController.h
// Fridge
//
// Created by Árpád Goretitty on 04/10/2012.
// Licensed under the 3-clause BSD License
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImportViewController: UITableViewController <UITextFieldDelegate> {
	NSString *path;
	NSArray *keys;
	NSArray *descriptions;
	NSArray *mediaTypes;
	NSMutableArray *textFields;
	UISegmentedControl *typeControl;
}

- (id)initWithPath:(NSString *)path;

@end
