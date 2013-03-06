//
//  PictureManager.m
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-06.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import "PictureManager.h"

static int count = 0;

@implementation PictureManager

-(NSMutableArray*)fetchPictures
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
                // NSLog(@"Result: %@",[result valueForProperty:ALAssetPropertyDate]);
                
                [urlDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                NSLog(@"Result: %@",[result valueForProperty:ALAssetPropertyURLs]);
                
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                [urlA addObject:url];
                // NSLog(@"URL: %@",url);
                
                [library assetForURL:url resultBlock:^(ALAsset *asset)
                 {
                     [mtbA addObject:[UIImage imageWithCGImage:[[asset  defaultRepresentation] fullScreenImage]]];
                     
                     if ([mtbA count]==count)
                     {
                         imgA=[[NSArray alloc] initWithArray:mtbA];
                     }
                     
                 }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                
            }
        }
    };
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop)
    {
        if(group != nil)
        {
            NSLog(@"Group Name: %@", [group valueForProperty:ALAssetsGroupPropertyName]);
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [groups addObject:group];
            count=[group numberOfAssets];
        }
    };
    
    groups = [[NSMutableArray alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
    
}




-(void)CopyPictureToAlbum:(NSURL *)url
                 Location: (NSString *)album
{
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop)
    {
        if([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:album])
        {
            // NSLog(@"Group Name: %@", [group valueForProperty:ALAssetsGroupPropertyName]);
            
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


@end
