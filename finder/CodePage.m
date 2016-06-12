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
    NSURL *url = [NSURL URLWithString:@"http://www.magalie121.com/wp-codeactivation.php?code=444"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
        /* 
         [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
            
        
          NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0 error:NULL];
             
                                      NSString text = [[greeting objectForKey:@"activation"] stringValue];
                                       
                                       NSLog( @"%@", text );
                                       
                                       }
                                       }];
          */
             
         }
    

@end
