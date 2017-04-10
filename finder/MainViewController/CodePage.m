//
//  codePage.m
//  Magalie121
//
//  Created by Ignacio Garcia Ruiz on 6/6/16.
//  Copyright © 2016 Magalie. All rights reserved.
//

#import "CodePage.h"
#import "finderAppDelegate.h"

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
    [self activar];
    
}


/*
 activation = 1;
 message = "";
 */
-(void)activar{
    NSLog(@"%@",_codeField.text);
     NSString * url = @"http://www.magalie121.com/wp-codeactivation.php?code=";
    url=[url stringByAppendingString:_codeField.text];
    NSDictionary *data= [self reponseUrl: url];
     NSLog(@"%@",data);
    int valor= [data objectForKey:@"activation"];
    
    if(valor==1)
    {
        [self writeToTextFile];
        finderAppDelegate *appDelegate = (finderAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadcontrols];
    }
    else{
    
    }
        
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

//Method writes a string to a text file

-(void) writeToTextFile{
NSString * nameFile=@"activacion.code";
    //get the documents directory:
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:nameFile];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR0ti", nil)
                                                            message:NSLocalizedString(@"ERROR0", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
    
}
-(void) settingsFile{

    NSFileManager * fileManager =[[NSFileManager alloc]init];
    NSArray  * path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[path objectAtIndex:0] stringByAppendingPathComponent:@"activacion.code"];
    NSString *FilePath=[[path objectAtIndex:0] absoluteString];
    NSString *TEST =[FilePath stringByAppendingPathComponent:@"vesrsion.json"];
    BOOL flage =[[NSFileManager  defaultManager] fileExistsAtPath:TEST];
    
    if (flage)
    {
        NSLog(@"It's exist ");
    }
    else
    {
        NSLog(@"It is not here yet ");
        NSData * data =[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/igarciar/testProyect/igarciar-patch-1/date.json"]];
        [data writeToFile:TEST atomically:YES];
    }

}

@end
