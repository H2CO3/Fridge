// 
// AppDelegate.m
// Fridge
// 
// Created by Árpád Goretitty on 04/10/2012.
// Licensed under the 3-clause BSD License
// 

#import "AppDelegate.h"
#import "Common.h"

@implementation AppDelegate

// UIApplicationDelegate

- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)opt
{
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	[window makeKeyAndVisible];

	mainViewController = [[FileBrowserViewController alloc] init];
	mainViewController.delegate = self;
	navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	[window addSubview:navController.view];

	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
	if ([def boolForKey:@"FridgeLaunched10"] == NO) {
		UIAlertView *av = [[UIAlertView alloc] init];
		av.title = LOC(@"Welcome to Music2iPod!");
		av.message = LOC(@"Thank you for downloading Music2iPod!\n\n"
			"This app enables you to import songs, pieces, videos and podcasts directly to the iPod media library, in order to be viewed in the default Music and Videos applications.\n"
			"Just use the file browser to navigate to the file you'd like to import and tap it to view and modify its metadata, choose whether"
			"you want it to be added as a song, a music video or a podcast, then tap the \"Done\" button to proceed.\n\n"
			"You can also open audiovisual media files using Music2iPod using the \"Open in...\" functionality of other apps, e. g. Mail, Safari, etc.\n\n"
			"Music2iPod also supports being launched through the music2ipod:// and fridge:// URL schemes - just specify a file path and you'll be presented with the usual import view.\n\n"
			"Developers: you can access the source code of this application at http://github.com/H2CO3/Fridge. "
			"The source code of the underlying iPod library helper library, libipodimport is also available at http://github.com/H2CO3/libipodimport.\n\n"
			"Thank you for using this app; please donate to me if you liked it!\n\n");

		av.delegate = self;
		[av addButtonWithTitle:LOC(@"Donate")];
		[av show];
		[av release];
	}

	return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)sApp annotation:(id)ctx
{
	NSString *path = [url path];
	[self openImportViewControllerWithPath:path];
	return YES;
}

// UIAlertViewDelegate

- (void)alertView:(UIAlertView *)av didDismissWithButtonIndex:(NSInteger)idx
{
	NSURL *url = [NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ASTPZY69JGEGW"];
	[[UIApplication sharedApplication] openURL:url];

	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
	[def setBool:YES forKey:@"FridgeLaunched10"];
	[def synchronize];
}

// Self

- (void)dealloc
{
	[window release];
	[navController release];
	[mainViewController release];
	[super dealloc];
}

- (void)openImportViewControllerWithPath:(NSString *)path
{
	ImportViewController *ctrl = [[ImportViewController alloc] initWithPath:path];
	[navController pushViewController:ctrl animated:YES];
	[ctrl release];
}

// FileBrowserViewControllerDelegate

- (void)fileBrowser:(FileBrowserViewController *)browser didSelectFile:(NSString *)path
{
	[self openImportViewControllerWithPath:path];
}

- (BOOL)fileBrowser:(FileBrowserViewController *)browser shouldDeleteFileAtPath:(NSString *)path
{
	return YES;
}

/*
- (void)fileBrowser:(FileBrowserViewController *)browser didLoadDirectory:(NSString *)path
{
	
}
*/

@end
