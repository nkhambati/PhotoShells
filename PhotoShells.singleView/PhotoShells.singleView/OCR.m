//
//  OCR.m
//  PhotoShells.singleView
//
//  Created by Nishrin Khambati on 13-03-07.
//  Copyright (c) 2013 Nishrin Khambati. All rights reserved.
//

#import "OCR.h"
#include <QuartzCore/QuartzCore.h>
#include <CoreImage/CoreImage.h>

static float ent_threshold = 1.1;
int img_count = 0;

@implementation OCR


- (NSArray *)extractText:(NSArray *)imgArray
{
    NSMutableArray *text_image_indices = [[NSMutableArray alloc] init];
    
    //NSLog(@"in extract text");
    if([imgArray count]>0)
    {
        img_count = [imgArray count];
        NSEnumerator *images = [imgArray objectEnumerator];
        UIImage *image = [[UIImage alloc] init];
        float img_entropies[[imgArray count]];
    
      //  Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
        
        int entropy_counter = 0;
        while(image = [images nextObject])
        {
            NSLog(@"image: %@", image);

            UIImage *image2 = [[UIImage alloc] init];
            image2 = [self resizeImage:image];
            //image2 = [self grayScale:image2];
            unsigned char *pixelData = [self grayscalePixels:image2];
            
            // Test script
            int counts[256];
            for(int i = 0; i < 256; i++)
            {
                counts[i] = 0;
            }
            
            for(int i=0;i<image.size.height;i++)
            {
                for(int j=0;j<image.size.width;j++)
                {                    
                    unsigned char data = pixelData[(i*((int)image.size.width))+j];
                    int pixelInt = data & 0xFFFF;
                    //NSLog(@"%d", pixelInt);
                    //NSLog(@"0x%X",pixelData[(i*((int)image.size.width))+j]);
                    
                    counts[pixelInt] = counts[pixelInt] + 1;
                }
            }
           /*
            for(int i = 0; i < 256; i++)
            {
                NSLog(@"%d %d", i, counts[i]);
            }*/
            
            //call the histogram function to get the pixel probabilities
            //double* pixelProbabilityArray = [self ImageHistogram:counts];
            double pixelProbabilityArray[256];
           
            for(int i = 0; i < 256; i++)
            {
                pixelProbabilityArray[i] = 0;
            }
            
            [self ImageHistogram:counts :pixelProbabilityArray];
            
            /*NSLog(@"pixel probabilities:");
            for(int i = 0; i < 256; i++)
            {
                NSLog(@"%d %f", i, pixelProbabilityArray[i]);
            }*/
            
            //call the entropy function to get the image entropy
            img_entropies[entropy_counter] = [self ImageEntropy:pixelProbabilityArray];
            //NSLog(@"Entropy %d: %f", entropy_counter, img_entropies[entropy_counter]);
            entropy_counter++;
            //[tesseract setImage:image2];
            //[tesseract recognize];
            //NSLog(@"%@", [tesseract recognizedText]);

        }
        
        //out of while loop
        NSLog(@"Entropies");
        
        for (int i = 0; i < entropy_counter; i++) {
            NSLog(@"%d - %f", i, img_entropies[i]);
        }
        
        //NEED TO CREATE A DYNAMIC ARRAY FOR INDICES
        text_image_indices = [[NSMutableArray alloc] init];

                
        [self categorizeImages:img_entropies :text_image_indices];
        
        NSLog(@"text_image_indices: ");
        
        for (int i = 0; i < [text_image_indices count]; i++) {            
            NSLog(@"%@", text_image_indices[i]);
        }

    }
    return text_image_indices;
}
-(void) categorizeImages:(float[]) entropy_array :(NSMutableArray *) text_image_indices
{
    //int index = 0;
    
    NSLog(@"threshold: %f", ent_threshold);
    
    for (int cat = 0; cat < img_count; cat++) {
        if (entropy_array[cat] < ent_threshold) {
            [text_image_indices addObject:[NSNumber numberWithInteger:cat]];
            //text_image_indices[index] = cat;
            //index++;
        }
    }
}

-(UIImage *)resizeImage:(UIImage *)image
{
    CGImageRef imageRef = [image CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    int width = image.size.width * 3;
    int height = image.size.height * 3;
    
    alphaInfo = kCGImageAlphaNoneSkipLast;
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, rgbColorSpace, alphaInfo);

    //CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

-(UIImage *)grayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *grayImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return grayImage;
}

/*-(UIImage *)processImage(UIImage *)image
{
    CIImage *beginImage = [image CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [filter outputImage];
    
    UIImage *newImage = [UIImage imageWithCIImage:outputImage];
    self.imageView.image = newImage;
}*/

-(unsigned char *) grayscalePixels:(UIImage *)image
{
    #define BYTES_PER_PIXEL 8
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceGray();
    size_t bytesPerRow = image.size.width * BYTES_PER_PIXEL;
    unsigned char* bitmapData = (unsigned char*) malloc(bytesPerRow * image.size.height);
    CGContextRef context = CGBitmapContextCreate(bitmapData, image.size.width, image.size.height, BYTES_PER_PIXEL,bytesPerRow,colourSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colourSpace);
    CGRect rect = CGRectMake(0.0,0.0, image.size.width, image.size.height);
    CGContextDrawImage(context,rect, image.CGImage);
    unsigned char* pixelData = (unsigned char*)CGBitmapContextGetData(context);
    CGContextRelease(context);

    /*// Test script
	
     for(int i=0;i<image.size.height;i++)
     {
         for(int y=0;y<image.size.width;y++)
         {
             unsigned char data = pixelData[(i*((int)image.size.width))+y];
             int pixelInt = data & 0xFFFF;
             NSLog(@"%d", pixelInt);
             //NSLog(@"0x%X",pixelData[(i*((int)image.size.width))+y]);
         }
     }*/
	 
    
    return pixelData;
    
    #undef BYTES_PER_PIXEL
}


//calculating the probability values for each pixel to obtain a histogram
- (void)ImageHistogram:(int *)pixel_counts_array :(double *)pixelProbabilityArray
{
    //NSLog(@"in histogram");
    int num_occurrences, p_count;
    double num_pixels = 0;
    
    
    for (p_count = 0; p_count < 256; p_count++) {
        num_pixels += pixel_counts_array[p_count];
    }
    NSLog(@"num_pixels: %f", num_pixels);
    
    for (p_count = 0; p_count < 256; p_count++) {
         num_occurrences = pixel_counts_array[p_count];
        pixelProbabilityArray[p_count] = num_occurrences/num_pixels;        
    }
    //NSLog(@"returning histogram");
}

//calculating the image entropy using the historgram values
- (float)ImageEntropy:(double *)pixel_prob_array
{
    float temp_ent = 0.0f, imageEntropy = 0.0f;
    
    for (int ent = 0; ent < 256; ent++) {
        double p = pixel_prob_array[ent];
        double p_log = 0.0;
        if (p != 0) {
            p_log = log2f(p);
        }
        temp_ent = p*p_log;
        imageEntropy += temp_ent;
    }
    
    imageEntropy = -imageEntropy;
    return imageEntropy;
}


@end
