//
//  codePage.m
//  Magalie121
//
//  Created by Ignacio Garcia Ruiz on 6/6/16.
//  Copyright © 2016 Magalie. All rights reserved.
//

#import "CodePage.h"

@interface CodePage ()

@end

@implementation CodePage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setParent:(NSObject*)value{
    [self setParent:value];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)find:(id)sender {
    
    
}


/*
 activation = 1;
 message = "";
 */
-(void)activar{
     NSString * url = @"http://www.magalie121.com/wp-codeactivation.php?code=444";
    NSDictionary *data= [self reponseUrl: url];
    NSLog(@"%@",data);
}


-(NSDictionary*) reponseUrl:(NSString* )url {
   // NSString *twitterUrl = @"https://raw.githubusercontent.com/igarciar/testProyect/igarciar-patch-1/date.json";
    NSURLRequest *Request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: Request returningResponse: &resp error: &error];
    NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:response
                                                             options:0
                                                               error:NULL];
    return greeting;

}


@end
