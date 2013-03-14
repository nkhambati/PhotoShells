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

//- (void)loadImages:(NSArray *)imageUrls loadedImages:(NSArray *)loadedImages callback:(void(^)(NSArray *))callback
-(void)fetchPictures
{
    // Initializing Variables
    imgA=[[NSArray alloc] init];
    mtbA =[[NSMutableArray alloc]init];
    NSMutableArray* urlDictionaries = [[NSMutableArray alloc] init];
    library = [[ALAssetsLibrary alloc] init];
    urlA = [[NSMutableArray alloc] init];
    
    //if (imgA == nil || [imgA count] == 0) {
   //     callback(fetchedPictures);
   // }
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        //NSLog(@"IN QUEUE2");

        if(result != nil)
        {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
            {
                // NSLog(@"Result: %@",[result valueForProperty:ALAssetPropertyDate]);
                
                [urlDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
               // NSLog(@"Result: %@",[result valueForProperty:ALAssetPropertyURLs]);
                
                
                NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                [urlA addObject:url];
                // NSLog(@"URL: %@",url);
                
                [library assetForURL:url resultBlock:^(ALAsset *asset)
                 {
                     [mtbA addObject:[UIImage imageWithCGImage:[[asset  defaultRepresentation] fullScreenImage]]];
                     
                     if ([mtbA count]==count)
                     {
                         imgA=[[NSArray alloc] initWithArray:mtbA];
                         NSLog(@"imgArray: %@", imgA);
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

    //operationQueue = [[NSOperationQueue alloc] init];

    //NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator
                              failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
   // }];
        
    //NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"imgArray return: %@", imgA);
        return;
   // }];
    
    //[operationQueue addOperation:operation];
    //[operationQueue addOperation:operation2];
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

-(NSArray*)getUIImage
{
    return imgA;
}


-(NSMutableArray*)getURLs
{
    return urlA;
}


@end
