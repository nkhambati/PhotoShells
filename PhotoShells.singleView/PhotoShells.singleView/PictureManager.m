//
//  PictureManager.m
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-06.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import "PictureManager.h"

static int imagesFound = 0;
static int groupsChecked = 0;

@implementation PictureManager

static PictureManager* _sharedPicManager = nil;

+(PictureManager*)sharedPicManager
{
	@synchronized([PictureManager class])
	{
		if (!_sharedPicManager)
			[[self alloc] init];
        
		return _sharedPicManager;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([PictureManager class])
	{
		NSAssert(_sharedPicManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedPicManager = [super alloc];
		return _sharedPicManager;
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

-(void)fetchPictures
{
    // Initializing Variables
    imgA=[[NSArray alloc] init];
    mtbA =[[NSMutableArray alloc]init];
    NSMutableArray* urlDictionaries = [[NSMutableArray alloc] init];
    library = [[ALAssetsLibrary alloc] init];
    urlA = [[NSMutableArray alloc] init];
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        //NSLog(@"in pictures enum block");
        
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
                     
                     // If lastUpdateDate == nil, then set it to random value
                     if(!lastUpdateDate)
                     {
                         NSLog(@"lastupdate date is null");
                         // TO DO: Change this value.
                         lastUpdateDate = [[NSDate alloc] init];
                         NSDateFormatter *df = [[NSDateFormatter alloc] init];
                         [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                         lastUpdateDate = [df dateFromString: @"2013-01-01 00:00:01"];

                     }
                     
                     // Finding date of pictures taken
                     NSDate *dateTaken = [asset valueForProperty:(ALAssetPropertyDate)];
                     NSComparisonResult comparisonResult = [dateTaken compare:lastUpdateDate];
                     
                     //TO DO: Delete Commenting
                    /* NSLog(@"lastUpdateDate: %@", lastUpdateDate);
                     NSLog(@"UIImage: %@", [UIImage imageWithCGImage:[[asset  defaultRepresentation] fullScreenImage]]);
                     NSLog(@"Date: %@", [result valueForProperty:ALAssetPropertyDate]);
                     NSLog(@"comparisonResult: %d", comparisonResult);
                    */
                     
                     if(comparisonResult > 0) //Pictures after the specified date
                     {
                         [mtbA addObject:[UIImage imageWithCGImage:[[asset  defaultRepresentation] fullScreenImage]]];
                     }
                     
                     if (imagesFound==count[groupsChecked])
                     {
                         imgA=[[NSArray alloc] initWithArray:mtbA];
                         //NSLog(@"imgA: %@", imgA);
                         groupsChecked++;
                         
                         //If both "Saved Pictures" and "Camera Roll" have been checked, update lastUpdateDate to current date.
                         if(groupsChecked == 2)
                         {
                             //Get Current Date to update lastUpdateDate for future fetches
                             lastUpdateDate = [NSDate date];
                         }
                         
                         if(!imgA || ![imgA count]) //If no new pictures found
                         {
                             //NSLog(@"in the if");
                             return;
                         }
                         else
                         {
                             //NSLog(@"Completing OCR");
                             // Running OCR
                             OCR *ocr = [[OCR alloc] init];
                             [ocr extractText:imgA];
                             
                             // Re-declaring variables
                             imagesFound = 0;
                             imgA = nil;
                                imgA=[[NSArray alloc] init];
                             mtbA = nil;
                                mtbA =[[NSMutableArray alloc]init];
                             //NSMutableArray* urlDictionaries = [[NSMutableArray alloc] init];
                             library = nil;
                                library = [[ALAssetsLibrary alloc] init];
                             urlA = nil;
                                urlA = [[NSMutableArray alloc] init];
                         }
                     }
                     
                 }
                        failureBlock:^(NSError *error){ NSLog(@"operation was not successfull!"); } ];
                
            }
        }
    };
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    groups = [[NSMutableArray alloc] init];
    static int i = 0;
    
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop)
    {
        //NSLog(@"in asset Group Enum");
        if(group != nil)
        {
            NSLog(@"Group Name: %@", [group valueForProperty:ALAssetsGroupPropertyName]);
            [group enumerateAssetsUsingBlock:assetEnumerator];
            [groups addObject:group];
            count[i]=[group numberOfAssets];
            i++;

        }
    };
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {NSLog(@"There is an error");}];
    return;
}


/*-(ALAssetsGroup*) FindAlbum:(NsString *)album
{
    _block ALAssetsGroup* groupFound;
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop)
    {
        if([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:album]) //found album
        {
            groupFound = group;
        }
        else
        {
            groupFound = nil;
        }
     
     }
    failureBlock:^(NSError* error)
        {
            NSLog(@"failed to enumerate albums:\n Error: %@", error); //[error localizedDescription]);
        }];
    
    return groupFound;
   
}*/

/*
 SaveImage: Saves processed images back in the photo gallery
            1. Searches for the given album name in the gallery
            2. If album found, adds the picture to the galler
 
            3. If album not found, create the album
            4. Save the picture in the newly created album
 
            Enumerates through all ablums in the gallery 
*/

-(BOOL) addPicture:(ALAssetsLibrary *)lib toGroup:(ALAssetsGroup *)group
{
    __block int counter = 0;
    BOOL added = false;
    
    for (int i = 0; i <[urlA count]; i++)
    {
        [library assetForURL:urlA[i] resultBlock:^(ALAsset *asset) //converts url to a picture
         {
             if(asset != nil) //if the picture isnt null, add it to the group
             {
                 [group addAsset:asset]; //Adds picture to the album
                 counter++;
             }
         }
         
        failureBlock:^(NSError *error){ NSLog(@"Failed to add picture to the album.\nError: %@", [error localizedDescription]); }];
    }
    
    //if all pictures are added successfully
    if(counter == [urlA count])
        added = TRUE;
    
    return added;
}


//-(void)SaveImage:(NSURL *)url toAlbum:(NSString*)album
-(void)SaveImage:(NSString *)album
{
    __block BOOL albumFound = false;
    __block BOOL addedSuccessfully = false;
    //__block ALAssetsLibrary *library2 = library;
    __block int counter = 0;
   
    
    //Find album
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop)
    {
        if([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:album]) //found album
        {
            albumFound = TRUE;
            //addedSuccessfully = [self addPicture:library toGroup:group];
            
            for (int i = 0; i <[urlA count]; i++)
            {
                [library assetForURL:urlA[i] resultBlock:^(ALAsset *asset) //converts url to a picture
                 {
                     if(asset != nil) //if the picture isnt null, add it to the group
                     {
                         [group addAsset:asset]; //Adds picture to the album
                         counter++;
                     }
                 }
                 
                        failureBlock:^(NSError *error){ NSLog(@"Failed to add picture to the album.\nError: %@", [error localizedDescription]); }];
            }
                  
            
            //album was found and picture was added to the added
            //bail out of the method
            //if(addedSuccessfully)
                return;
        }
        
        //If the album doesnt exist
        if(group == nil && albumFound == false)
        {
            __weak ALAssetsLibrary * weakSelf = self;
        
            //Creates a new album
            [library addAssetsGroupAlbumWithName:album resultBlock:^(ALAssetsGroup *group)
             {
                for (int i = 0; i <[urlA count]; i++)
                 {
                    [weakSelf assetForURL:urlA[i] resultBlock:^(ALAsset *asset) //converts url to a picture
                     {
                         if(asset != nil) //if the picture isnt null, add it to the group
                         {
                          [group addAsset:asset]; //Adds picture to the newly created album
                           addedSuccessfully = true;
                         }
                     }
                          failureBlock:^(NSError *error)
                     { NSLog(@"Failed to add picture to the album.\nError: %@", [error localizedDescription]); }];
                 } }
                                    failureBlock:^(NSError *error) {
                NSLog(@"Error adding/creating album to the photoGallery");
                                    }];
                    
            //should be the last iteration anyway, but just in case, bail out of the method
            return;

        }

};
    // search all photo albums in the library
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                        usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error)
        {NSLog(@"There is an error with enumerating through albums");}];
}


-(NSArray*)getUIImage
{
    //NSLog(@"in UI Image");
    return imgA;
}


-(NSMutableArray*)getURLs
{
    return urlA;
}

-(void)setTimer;
{
    // TO DO: Delete this and uncomment the line following
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                             target:self
                                           selector:@selector(fetchPictures)
                                           userInfo:nil repeats:YES];
    
    /*timer = [NSTimer scheduledTimerWithTimeInterval:[[CategorizationSettings sharedCatSettings] getSeconds]
                                             target:self
                                           selector:@selector(fetchPictures)
                                           userInfo:nil repeats:YES];*/
}

-(void)invalidateTimer
{
    [timer invalidate];
}


@end
