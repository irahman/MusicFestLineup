//
//  ViewController.h
//  Task_Project
//
//  Created by Irfan Rahman on 1/30/18.
//  Copyright © 2018 Irfan Rahman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic) NSMutableArray*jSonArray;
@property (strong , nonatomic) NSArray*arry;
@property (strong, nonatomic) IBOutlet UITableView *tableObj;

@property (strong , nonatomic) UIButton*sortOBj;
@end
