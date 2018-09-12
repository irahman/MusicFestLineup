//
//  TableCell.h
//  Task_Project
//
//  Created by Irfan Rahman on 1/30/18.
//  Copyright © 2018 Irfan Rahman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

+(UINib *)nib;

@property (strong, nonatomic) IBOutlet UIView *borterViewObj;

@property (strong, nonatomic) IBOutlet UIImageView *artImagePro;
@property (strong, nonatomic) IBOutlet UILabel *artNameObj;

@end
