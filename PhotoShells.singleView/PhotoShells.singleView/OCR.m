//
//  OCR.m
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-07.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import "OCR.h"

@implementation OCR

- (NSString *)extractText:(NSArray *)imgArray
{
    if([imgArray count]>0)
    {
    
        extractedText = [[NSString alloc] init];
    
        NSEnumerator *images = [imgArray objectEnumerator];
        id image;
    
        Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    
        while(image = [images nextObject])
        {
            [tesseract setImage:image];
            [tesseract recognize];

        }    
    }
    
    return @"Blah";
}

@end
