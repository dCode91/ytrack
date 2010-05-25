//
//  RemoteHDViewController.m
//  RemoteHD
//
//  Created by Fabrice Dewasmes on 19/05/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RemoteHDViewController.h"
#import "DAAPRequestReply.h"
#import "DAAPResponsemlog.h"
#import "DAAPResponsemsrv.h"
#import "DAAPResponsemdcl.h"
#import "PreferencesManager.h"


@implementation RemoteHDViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) libraryAvailable {
	[masterViewController display];
	[detailViewController display];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(libraryAvailable) name:@"connected" object:nil];
}


- (void) sampleRequests {
	NSString *host = @"MBPFDE.local.";
	NSString *portStr = @":3689";
	NSString* str = [[NSString alloc] initWithFormat:@"http://%@%@/server-info",host,portStr];
	NSLog(@"%@",str);
	NSArray *dictoA = [DAAPRequestReply smartRequestAndParseResponse:[NSURL URLWithString:str]];
	
	NSLog(@"briwsing : %@",[(DAAPResponsemsrv *)[dictoA objectAtIndex:0] minm]);
	
	int sessionId = 1;
	
	NSString* strspeaker = [[NSString alloc] initWithFormat:@"http://%@%@/getspeakers?session-id=%d",host,portStr,sessionId];
	NSLog(@"%@",strspeaker);
	NSArray *dictospeaker = [DAAPRequestReply smartRequestAndParseResponse:[NSURL URLWithString:strspeaker]];
	long long speakerId = [[(DAAPResponsemdcl *)[dictospeaker objectAtIndex:1] msma] longLongValue];
	
	NSString* strsetspeaker = [[NSString alloc] initWithFormat:@"http://%@%@/ctrl-int/1/setspeakers?speaker-id=0,0x%qX&session-id=%d",host,portStr,speakerId,sessionId];
	NSLog(@"%@",strsetspeaker);
	[DAAPRequestReply smartRequestAndParseResponse:[NSURL URLWithString:strsetspeaker]];
	
	
	//	NSString *string2 = [NSString stringWithFormat:@"http://192.168.0.9:3689/ctrl-int/1/playstatusupdate?revision-number=1&session-id=%d",sessionId];
	NSString *string2 = [NSString stringWithFormat:@"http://%@%@/databases?session-id=%d",host,portStr,sessionId];
	NSLog(@"%@",string2);
	[DAAPRequestReply smartRequestAndParseResponse:[NSURL URLWithString:string2]];
	
	
	NSString *string3 = [NSString stringWithFormat:@"http://%@%@/ctrl-int/1/playstatusupdate?revision-number=1&session-id=%d",host,portStr,sessionId];
	NSLog(@"%@",string3);
	[DAAPRequestReply smartRequestAndParseResponse:[NSURL URLWithString:string3]];
}

- (IBAction) buttonClicked:(id)sender{
		LibrariesViewController *libraries = [[LibrariesViewController alloc ] initWithNibName:@"LibrariesViewController" bundle:nil];
	//libraries.view.frame
	libraries.modalPresentationStyle = UIModalPresentationFormSheet;
	[libraries setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[libraries setDelegate:self];
	[self presentModalViewController:libraries animated:YES]; 
}

- (void) didFinishEditingLibraries {
	[self dismissModalViewControllerAnimated:YES];
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
