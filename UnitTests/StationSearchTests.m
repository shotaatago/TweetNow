//
//  StationSearchTests.m
//  TweetNow
//
//  Created by Yuumi Yoshida on 10/05/10.
//  Copyright 2010 EY-Office. All rights reserved.
//

#import "StationSearchTests.h"


@implementation StationSearchTests

- (void) testNearLongitude {
	PlaceList *list = [StationSearch nearLongitude:139.670245 withLatitude:35.612152];
	
	STAssertEqualObjects(@"自由が丘", [list nameAtIndex:0], @"1位");
	STAssertEqualObjects(@"都立大学", [list nameAtIndex:1], @"2位");
	STAssertEqualObjects(@"奥沢", [list nameAtIndex:2], @"3位");
	STAssertEqualObjects(@"緑が丘", [list nameAtIndex:3], @"4位");
	STAssertEqualObjects(@"九品仏", [list nameAtIndex:4], @"5位");
}


@end
