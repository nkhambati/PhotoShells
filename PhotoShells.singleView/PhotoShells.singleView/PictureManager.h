//
//  PictureManager.h
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-06.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AssetsLibrary/AssetsLibrary.h> 
#import "OCR.h"

@interface PictureManager : NSObject
{
    ALAssetsLibrary *library;
    NSArray *imgA;
    NSMutableArray *mtbA;
    NSFileManager *manager;
    NSMutableArray *urlA;
    NSString *lastUpdateDate;
}

-(void)fetchPictures:(NSString *)specifiedDate;
-(void)CopyPictureToAlbum:(NSURL *)url Location: (NSString *)album;
-(NSArray*)getUIImage;
-(NSMutableArray*)getURLs;
@end
