//
//  RegisteredPlaceList.m
//  TweetNow
//
//  Created by Yuumi Yoshida on 09/12/25.
//  Copyright 2009 EY-Office. All rights reserved.
//

#import "RegisteredPlaceList.h"
#define DB_VERSION 101
#define PLACE_LIST_DB_VERSION @"placeListDbVersion"
#define PLACE_LIST_DB  @"placeListDb"

static RegisteredPlaceList *sharedInstanceDelegate = nil;

@interface PlaceList(Private)

- (RegisteredPlaceList *) init;

@end

@implementation RegisteredPlaceList

- (id) init {	
	self = (RegisteredPlaceList *)[super init];
	[list retain];  // Keep list
	return self;
}

- (void)load {	
	int dbVersion = [[NSUserDefaults standardUserDefaults] integerForKey:PLACE_LIST_DB_VERSION];
	if (dbVersion == DB_VERSION) {
		[self fromStringArray:[[NSUserDefaults standardUserDefaults] arrayForKey:PLACE_LIST_DB]];
	}
	
	//NSLog(@"load placeDb: %@", list);
}

- (void)save {
	[[NSUserDefaults standardUserDefaults] setInteger:DB_VERSION forKey:PLACE_LIST_DB_VERSION];
	[[NSUserDefaults standardUserDefaults] setObject:[self toStringArray] forKey:PLACE_LIST_DB];
	//NSLog(@"save placeDb: %@", list);
}

- (PlaceList *) nearLongitude:(float)longitude withLatitude:(float)latitude {
	PlaceList *nears = [PlaceList placeList];

	for (int i = 0; i < [list count]; i++) {
		Place *p = (Place *)[list objectAtIndex:i];
		if (fabsf(p.longitude - longitude) < 0.01 && fabsf(p.latitude - latitude) < 0.01) {
			[nears addPlace:p];
		}
	}
	
	[nears sortByDistanceFromLongitude:longitude latitude:latitude];
	return nears;
}

- (void) removeAll {
	[list removeAllObjects];
}

// http://blog.quazie.net/2009/04/sharedinstance-objective-cs-singleton-paradigm/

+ (RegisteredPlaceList *)sharedInstance {
	@synchronized(self) {
		if (sharedInstanceDelegate == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return sharedInstanceDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstanceDelegate == nil) {
			sharedInstanceDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return sharedInstanceDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}


@end
