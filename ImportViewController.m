//
// ImportViewController.m
// Fridge
//
// Created by Árpád Goretitty on 04/10/2012.
// Licensed under the 3-clause BSD License
//

#import <ipodimport.h>
#import "ImportViewController.h"
#import "Common.h"

@interface ImportViewController ()
- (void)close;
- (void)done;
@end

@implementation ImportViewController

- (id)initWithPath:(NSString *)p
{
	if ((self = [self init])) {
		path = [p copy];
		self.title = [path lastPathComponent];
		CGRect frm;

		UIBarButtonItem *done = [[UIBarButtonItem alloc]
			initWithBarButtonSystemItem:UIBarButtonSystemItemDone
			target:self
			action:@selector(done)
		];
		self.navigationItem.rightBarButtonItem = done;
		[done release];
				
		keys = [[NSArray alloc] initWithObjects:kIPIKeyTitle,
			kIPIKeyArtist,
			kIPIKeyAlbum,
			kIPIKeyGenre,
			kIPIKeyYear,
			nil
		];
		
		mediaTypes = [[NSArray alloc] initWithObjects:
			kIPIMediaSong,
			kIPIMediaMusicVideo,
			kIPIMediaPodcast,
			nil
		];
		
		descriptions = [[NSArray alloc] initWithObjects:
			LOC(@"Title of the piece"),
			LOC(@"Artist, singer or author"),
			LOC(@"Containing album"),
			LOC(@"Genre"),
			LOC(@"Release year"),
			nil
		];

		// Getting the screen bounds fails on iPad (???)
		CGFloat w = 320.0f; // [UIApplication sharedApplication].keyWindow.frame.size.width;
		
		textFields = [[NSMutableArray alloc] init];
		frm.origin = CGPointMake(0.0f, 0.0f);
		frm.size = CGSizeMake(w, 44.0f);
		
		NSString *desc;
		for (desc in descriptions) {
			UITextField *tf = [[UITextField alloc] initWithFrame:frm];
			tf.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			tf.placeholder = desc;
			tf.clearButtonMode = UITextFieldViewModeWhileEditing;
			tf.delegate = self;
			tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 8.0f, 44.0f)];
			tf.leftView = padding;
			tf.leftViewMode = UITextFieldViewModeAlways;
			[padding release];
			[textFields addObject:tf];
			[tf release];
		}
		
		NSArray *items = [NSArray arrayWithObjects:
			LOC(@"Song"),
			LOC(@"Video"),
			LOC(@"Podcast"),
			nil
		];

		typeControl = [[UISegmentedControl alloc] initWithItems:items];
		typeControl.segmentedControlStyle = UISegmentedControlStyleBar;
		frm.origin = CGPointMake(4.0f, 4.0f);
				
		frm.size = CGSizeMake(w - 8.0f, 36.0f);
		typeControl.frame = frm;
		typeControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;

		NSString *fnam = [[path lastPathComponent] stringByDeletingPathExtension];
		[(UITextField *)[textFields objectAtIndex:0] setText:fnam];
		[(UITextField *)[textFields objectAtIndex:2] setText:@"Added using Music2iPod"];

		NSString *ext = [p pathExtension];
		if ([ext isEqualToString:@"mp4"]
		 || [ext isEqualToString:@"3gp"]
		 || [ext isEqualToString:@"mov"]
		 || [ext isEqualToString:@"wmv"]
		 || [ext isEqualToString:@"flv"]
		) {
			typeControl.selectedSegmentIndex = 1; // video
		} else {
			typeControl.selectedSegmentIndex = 0; // assume a song
		}

		[self.tableView reloadData];
	}
	return self;
}

- (void)dealloc
{
	[path release];
	[keys release];
	[mediaTypes release];
	[descriptions release];
	[textFields release];
	[typeControl release];
	[super dealloc];
}
			    
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)o
{
	return YES;
}

// UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) return 1;
	return textFields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellID = @"ImportCell";
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
			reuseIdentifier:cellID]
		autorelease];

		if (indexPath.section == 1) {
			[cell.contentView addSubview:[textFields objectAtIndex:indexPath.row]];
		} else {
			[cell.contentView addSubview:typeControl];
		}
	}
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"Media Type";
	}
	return @"Metadata";
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil; // don't enable selection
}

// UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	NSInteger idx = [textFields indexOfObject:textField];
	if (idx < textFields.count - 1) {
		[[textFields objectAtIndex:idx + 1] becomeFirstResponder];
	}
	
	return YES;
}

// Self

- (void)done
{
	NSMutableDictionary *meta = [NSMutableDictionary dictionary];
	int i;
	for (i = 0; i < keys.count; i++) {
		id key = [keys objectAtIndex:i];
		NSString *value = [(UITextField *)[textFields objectAtIndex:i] text];
		[meta setValue:value forKey:key];
	}
	id mType = [mediaTypes objectAtIndex:typeControl.selectedSegmentIndex];
	[meta setValue:mType forKey:kIPIKeyMediaType];

	[[IPIPodImporter sharedInstance] importFileAtPath:path withMetadata:meta];

	UIAlertView *av = [[UIAlertView alloc] init];
	av.title = LOC(@"File added");
	av.message = LOC(@"The item has been successfully imported to the media library.");
	[av addButtonWithTitle:LOC(@"Dismiss")];
	[av show];
	[av release];

	[self close];
}

- (void)close
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
