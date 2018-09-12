//
//  DetailVc.h
//  Task_Project
//
//  Created by Irfan Rahman on 1/30/18.
//  Copyright © 2018 Irfan Rahman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVc : UIViewController

@property (strong ,nonatomic)NSManagedObjectModel  *modal;

@property (strong, nonatomic) IBOutlet UIImageView *artImagePro;
@property (strong, nonatomic) IBOutlet UILabel *artNameObj;

@property (strong, nonatomic) IBOutlet UITextView *artDetailObj;


@end
