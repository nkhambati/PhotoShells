//
//  OCR.m
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-07.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import "OCR.h"
#include <QuartzCore/QuartzCore.h>
#include <CoreImage/CoreImage.h>

@implementation OCR

- (void)extractText:(NSArray *)imgArray
{
    if([imgArray count]>0)
    {
        NSEnumerator *images = [imgArray objectEnumerator];
        UIImage *image = [[UIImage alloc] init];
    
        Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    
        while(image = [images nextObject])
        {
            NSLog(@"image: %@", image);
            
            UIImage *image2 = [[UIImage alloc] init];
            image2 = [self resizeImage:image];
            [tesseract setImage:image2];
            [tesseract recognize];
            NSLog(@"%@", [tesseract recognizedText]);

        }
        
      /* // TO DO: Delete -- just proves that tesseract works
        UIImage *img = [[UIImage alloc] init];
        img = [UIImage imageNamed:@"sample3.jpg"];
        NSLog(@"%@", img);

        [tesseract setImage:img];
        [tesseract recognize];
        
        NSLog(@"%@", [tesseract recognizedText]);*/
    }
}

-(UIImage *)resizeImage:(UIImage *)image
{
    CGImageRef imageRef = [image CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    int width = image.size.width * 3;
    int height = image.size.height * 3;
    
    //if (alphaInfo == kCGImageAlphaNone)
    alphaInfo = kCGImageAlphaNoneSkipLast;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

@end
