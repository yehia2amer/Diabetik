//
//  UASummaryWidgetListViewController.m
//  Diabetik
//
//  Created by Nial Giacomelli on 17/04/2014.
//  Copyright (c) 2014 UglyApps. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "UASummaryWidgetListViewController.h"

// Widgets
#import "UAHbA1CWidget.h"
#import "UATimeOfDayWidget.h"
#import "UATimeSinceWidget.h"

@interface UASummaryWidgetListViewController ()
@property (nonatomic, strong) NSArray *widgetList;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation UASummaryWidgetListViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self)
    {
        NSDictionary *hba1cWidget = @{@"name": NSLocalizedString(@"HbA1c estimate", nil),
                                      @"description": NSLocalizedString(@"An estimated HbA1c reading over a certain time period", nil), @"class": [UAHbA1CWidget class]};
        NSDictionary *todWidget = @{@"name": NSLocalizedString(@"Average glucose", nil),
                                      @"description": NSLocalizedString(@"Average glucose readings for a specific time of day", nil), @"class":  [UATimeOfDayWidget class]};
        NSDictionary *timeSinceWidget = @{@"name": NSLocalizedString(@"Time since", nil),
                                    @"description": NSLocalizedString(@"The time since a certain event", nil), @"class":  [UATimeSinceWidget class]};
        self.widgetList = [NSArray arrayWithObjects:todWidget, hba1cWidget, timeSinceWidget, nil];
        
        
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"AddEntryModalCloseIconiPad"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.closeButton.frame = CGRectMake(self.view.bounds.size.width/2.0f - 20.0f, self.view.bounds.size.height-60.0f, 40.0f, 40.0f);
}

#pragma mark - Presentation logic
- (void)dismiss
{
    __weak typeof(self) weakRef = self;
    [weakRef willMoveToParentViewController:nil];
    [weakRef.view removeFromSuperview];
    [weakRef removeFromParentViewController];
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    Class WidgetClass = self.widgetList[indexPath.row][@"class"];
    [self.delegate summaryList:self didSelectWidgetClass:WidgetClass];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.widgetList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"widget"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"widget"];
    }
    
    cell.textLabel.text = self.widgetList[indexPath.row][@"name"];
    cell.detailTextLabel.text = self.widgetList[indexPath.row][@"description"];
    
    return cell;
}
@end
