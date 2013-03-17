//
//  PictureManager.m
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-06.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import "PictureManager.h"

static int count = 0;
static int imagesFound = 0;

@implementation PictureManager

-(void)fetchPictures:(NSString *)specifiedDate
{
    // Initializing Variables
    imgA=[[NSArray alloc] init];
    mtbA =[[NSMutableArray alloc]init];
    NSMutableArray* urlDictionaries = [[NSMutableArray alloc] init];
    library = [[ALAssetsLibrary alloc] init];
    urlA = [[NSMutableArray alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {

        if(result != nil)
        {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {                
                [urlDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                [urlA addObject:url];
                
                [library assetForURL:url resultBlock:^(ALAsset *asset)
                 {
                     imagesFound++;

                     // Finding date of pictures taken
                     NSDate *dateTaken = [asset valueForProperty:(ALAssetPropertyDate)];
                     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                     [dateFormat setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
                     NSString *date = [dateFormat stringFromDate:(dateTaken)];
                     NSComparisonResult result = [date compare:specifiedDate];
                    
                     if(result > 0) //Pictures after the specified date
                     {
                         [mtbA addObject:[UIImage imageWithCGImage:[[asset  defaultRepresentation] fullScreenImage]]];
                     }
                     
                     if (imagesFound==count)
                     {
                         imgA=[[NSArray alloc] initWithArray:mtbA];
                         NSLog(@"imgA: %@", imgA);
                         
                         //Get Current Date to update lastUpdateDate for future fetches
                         NSDate *dateObject = [[NSDate alloc] init];
                         dateObject = [NSDate date];
                         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                         [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
                         lastUpdateDate = [dateFormatter stringFromDate:(dateObject)];
                         NSLog(@"LastUpdateDate: %@", lastUpdateDate);
                         
                         if(!imgA || ![imgA count])
                         {
                             return;
                         }
                         else
                         {
                             // Running OCR
                             OCR *ocr = [[OCR alloc] init];
                             NSString *extractedText = [[NSString alloc] init];
                             extractedText = [ocr extractText:imgA];
                         }
                     }
                     
                 }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                
            }
        }
    };
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    groups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop)
    {
        if(group != nil)
        {
            //NSLog(@"Group Name: %@", [group valueForProperty:ALAssetsGroupPropertyName]);
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [groups addObject:group];
            count=[group numberOfAssets];
        }

    };

    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator
                              failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
    return;
}




-(void)CopyPictureToAlbum:(NSURL *)url
                 Location: (NSString *)album
{
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop)
    {
        if([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:album])
        {
            [library assetForURL:url resultBlock:^(ALAsset *asset)
             {
                 if(asset != nil)
                 {
                     [group addAsset:asset];
                 }
             }
                    failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
        }
    };
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
}

-(NSArray*)getUIImage
{
    return imgA;
}


-(NSMutableArray*)getURLs
{
    return urlA;
}


@end
