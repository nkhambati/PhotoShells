//
//  PictureManager.h
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-06.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AssetsLibrary/AssetsLibrary.h>
#include <AssetsLibrary/ALAssetsLibrary.h>
#import "OCR.h"
#import "CategorizationSettings.h"

@interface PictureManager : NSObject
{
    ALAssetsLibrary *library;
    NSArray *imgA;
    NSMutableArray *mtbA;
    NSFileManager *manager;
    NSMutableArray *urlA;
    NSDate *lastUpdateDate;
    NSTimer *timer;
    NSInteger count[2];
   
}

+(PictureManager *)sharedPicManager;
-(void)fetchPictures;
-(void)SaveImage:(NSString *)album;
-(NSArray*)getUIImage;
-(NSMutableArray*)getURLs;
-(void)setTimer;
-(void)invalidateTimer;


@end
