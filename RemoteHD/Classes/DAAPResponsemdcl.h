//
//  DAAPResponsemdcl.h
//  BonjourWeb
//
//  Created by Fabrice Dewasmes on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DAAPResponsemdcl : NSObject {
	NSNumber *caia;
	NSString *minm;
	NSNumber *msma;
}

@property (nonatomic, retain) NSNumber *caia;
@property (nonatomic, retain) NSString *minm;
@property (nonatomic, retain) NSNumber *msma;

@end
