//
//  CategorizationSettings.m
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-13.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import "CategorizationSettings.h"

@implementation CategorizationSettings

-(void)setSeconds:(NSInteger)sec
{
    seconds = (sec * 3600);
}

-(NSInteger)getSeconds
{
    return seconds;
}


@end
