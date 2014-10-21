//  InstaSelfie
//
//  Created by cheskiewicz on 10/20/14.
//  Copyright (c) 2014 Rymegan LLc. All rights reserved.
//

#import "Cell.h"

@implementation Cell
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end
