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
    NSString *extractedText;
}

- (NSString *)extractText:(NSArray *)imgArray;

@end
