//
//  DAAPResponseaply.h
//  yTrack
//
//  Created by Fabrice Dewasmes on 23/05/10.
//  Copyright 2010 Fabrice Dewasmes. All rights reserved.
//  
//  This file is part of yTrack.
//  
//  yTrack is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  yTrack is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with yTrack.  If not, see <http://www.gnu.org/licenses/>.
//

#import <Foundation/Foundation.h>
#import "DAAPResponse.h"
#import "DAAPResponsemlcl.h"

@interface DAAPResponseaply : DAAPResponse {
	NSNumber *mstt;
	NSNumber *muty;
	NSNumber *mtco;
	NSNumber *mrco;
	DAAPResponsemlcl *mlcl;
}

@property (nonatomic, retain) NSNumber *mstt;
@property (nonatomic, retain) NSNumber *muty;
@property (nonatomic, retain) NSNumber *mtco;
@property (nonatomic, retain) NSNumber *mrco;
@property (nonatomic, retain, getter=listing) DAAPResponsemlcl *mlcl;

@end
