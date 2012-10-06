// 
// AppDelegate.h
// Fridge
// 
// Created by Árpád Goretitty on 04/10/2012.
// Licensed under the 3-clause BSD License
// 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FileBrowserViewController.h"
#import "ImportViewController.h"

@interface AppDelegate: NSObject <UIApplicationDelegate, UIAlertViewDelegate, FileBrowserViewControllerDelegate> {
        UIWindow *window;
        FileBrowserViewController *mainViewController;
        UINavigationController *navController;
}

- (void)openImportViewControllerWithPath:(NSString *)path;

@end
