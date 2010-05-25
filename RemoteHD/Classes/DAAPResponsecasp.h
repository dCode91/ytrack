//
//  DAAPResponsecasp.h
//  BonjourWeb
//
//  Created by Fabrice Dewasmes on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAAPResponse.h"


@interface DAAPResponsecasp : DAAPResponse {
	NSNumber *mstt;
	NSArray *speakers;
}

@property (nonatomic, retain) NSNumber *mstt;

@end
