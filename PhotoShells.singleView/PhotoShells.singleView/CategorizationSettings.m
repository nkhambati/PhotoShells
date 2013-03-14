//
//  CategorizationSettings.m
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-13.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import "CategorizationSettings.h"

@implementation CategorizationSettings

-(void)setSeconds:(double)hours
{
    seconds = (hours * 3600);
}

-(double)getSeconds
{
    return seconds;
}


@end
