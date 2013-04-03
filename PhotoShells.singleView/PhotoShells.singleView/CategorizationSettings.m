//
//  CategorizationSettings.m
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-13.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import "CategorizationSettings.h"

@implementation CategorizationSettings

static CategorizationSettings* _sharedCatSettings = nil;

+(CategorizationSettings*)sharedCatSettings
{
	@synchronized([CategorizationSettings class])
	{
		if (!_sharedCatSettings)
			_sharedCatSettings = [[self alloc] init];
        
		return _sharedCatSettings;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([CategorizationSettings class])
	{
		NSAssert(_sharedCatSettings == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedCatSettings = [super alloc];
		return _sharedCatSettings;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
    
	return self;
}

-(void)setSeconds:(double)hours
{
    seconds = (hours * 3600);
}

-(double)getSeconds
{
    return seconds;
}


@end
