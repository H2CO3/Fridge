// 
// FileBrowserViewController.h
// Fridge
// 
// Created by Árpád Goretitty on 04/10/2012.
// Licensed under the 3-clause BSD License
// 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FileBrowserViewController;

@protocol FileBrowserViewControllerDelegate <NSObject>
- (void)fileBrowser:(FileBrowserViewController *)browser didSelectFile:(NSString *)path;
- (BOOL)fileBrowser:(FileBrowserViewController *)browser shouldDeleteFileAtPath:(NSString *)path;
@optional
- (void)fileBrowser:(FileBrowserViewController *)browser didLoadDirectory:(NSString *)path;
@end

@interface FileBrowserViewController: UITableViewController {
	NSFileManager *fileManager;
	NSString *path;
	NSMutableArray *contents;
	id <FileBrowserViewControllerDelegate> delegate;
}

@property (nonatomic, readonly) NSString *path;
@property (nonatomic, assign) id <FileBrowserViewControllerDelegate> delegate;

@end
