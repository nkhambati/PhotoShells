//
//  CategorizationSettings.h
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-13.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategorizationSettings : NSObject
{
    NSInteger seconds;
}
-(void)setSeconds:(NSInteger)sec;
-(NSInteger)getSeconds;

@end
