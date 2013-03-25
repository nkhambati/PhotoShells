//
//  OCR.h
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-07.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tesseract.h"

@interface OCR : NSObject
{
}

- (void)extractText:(NSArray *)imgArray;
-(UIImage *)resizeImage:(UIImage *)image;
-(UIImage *)grayScale:(UIImage *)image;
-(unsigned char *) grayscalePixels:(UIImage *)image;
-(void)ImageHistogram:(int *)pixel_counts_array :(double *)pixelProbabilityArray;


@end
