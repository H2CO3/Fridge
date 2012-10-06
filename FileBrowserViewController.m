// 
// FileBrowserViewController.m
// Fridge
// 
// Created by Árpád Goretitty on 04/10/2012.
// Licensed under the 3-clause BSD License
// 

#import <unistd.h>
#import <sys/types.h>
#import <sys/stat.h>
#import "FileBrowserViewController.h"

@interface FileBrowserViewController ()
- (id)initWithPath:(NSString *)p;
@end

@implementation FileBrowserViewController

@synthesize path, delegate;

// Super

- (id)initWithStyle:(UITableViewStyle)st
{
	return [self initWithPath:@"/"];
}

// Self

- (id)initWithPath:(NSString *)p
{
	if ((self = [super initWithStyle:self.tableView.style])) {
		path = [p copy];
		fileManager = [[NSFileManager alloc] init];
		contents = [[fileManager contentsOfDirectoryAtPath:path error:NULL] mutableCopy];
		[contents sortUsingSelector:@selector(caseInsensitiveCompare:)];

		self.title = [path lastPathComponent];
		[self.tableView reloadData];
	}
	return self;
}

- (void)dealloc
{
	[fileManager release];
	[path release];
	[contents release];
	[super dealloc];
}

// UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
       return contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellID = @"FileBrowserCell";
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
			reuseIdentifier:cellID]
		autorelease];
	}

	NSString *name = [contents objectAtIndex:indexPath.row];
	NSString *childPath = [path stringByAppendingPathComponent:name];
	BOOL isDir = NO;
	[fileManager fileExistsAtPath:childPath isDirectory:&isDir];
	
	cell.imageView.image = isDir ? [UIImage imageNamed:@"DirIcon.png"] : [UIImage imageNamed:@"FileIcon.png"];
	cell.textLabel.text = [contents objectAtIndex:indexPath.row];
	
	if (!isDir) {
		struct stat st;
		stat([childPath UTF8String], &st);
		NSMutableString *szStr = [NSMutableString string];
		
		if (st.st_size >= 1024 * 1024 * 1024) {
			[szStr appendFormat:@"%.2f GB", st.st_size / (1024.0f * 1024.0f * 1024.0f)];
		} else if (st.st_size >= 1024 * 1024) {
			[szStr appendFormat:@"%.2f MB", st.st_size / (1024.0f * 1024.0f)];
		} else if (st.st_size >= 1024) {
			[szStr appendFormat:@"%.2f kB", st.st_size / 1024.0f];
		} else {
			[szStr appendFormat:@"%u B", (unsigned)st.st_size];
		}

		cell.detailTextLabel.text = szStr;
	} else {
		cell.detailTextLabel.text = nil;
	}
	
	// test for symlink
	if (readlink([childPath UTF8String], NULL, 0) != -1) {
		cell.textLabel.textColor = [UIColor colorWithRed:0.1f green:0.3f blue:1.0f alpha:1.0f];
	} else {
		cell.textLabel.textColor = [UIColor blackColor];
	}

	return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tv deselectRowAtIndexPath:indexPath animated:YES];
	NSString *name = [contents objectAtIndex:indexPath.row];
	NSString *childPath = [path stringByAppendingPathComponent:name];

	BOOL isDir = NO;
	[fileManager fileExistsAtPath:childPath isDirectory:&isDir];

	if (isDir) {
		FileBrowserViewController *child = 
[[FileBrowserViewController alloc] initWithPath:childPath];
		child.delegate = self.delegate;
		[self.navigationController pushViewController:child animated:YES];
		[child release];
		if ([self.delegate respondsToSelector:@selector(fileBrowser:didLoadDirectory:)]) {
			[self.delegate fileBrowser:self didLoadDirectory:childPath];
		}
	} else {
		[self.delegate fileBrowser:self didSelectFile:childPath];
	}
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)es forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (es == UITableViewCellEditingStyleDelete) {
		NSString *name = [contents objectAtIndex:indexPath.row];
		NSString *childPath = [path stringByAppendingPathComponent:name];
		if ([self.delegate fileBrowser:self shouldDeleteFileAtPath:childPath]) {
			[fileManager removeItemAtPath:childPath error:NULL];
			[contents removeObjectAtIndex:indexPath.row];
			[tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
		}
	}
}

@end
