//
//  TableCell.m
//  Task_Project
//
//  Created by Irfan Rahman on 1/30/18.
//  Copyright © 2018 Irfan Rahman. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell

+(UINib *)nib{
    return [UINib nibWithNibName:@"TableCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
