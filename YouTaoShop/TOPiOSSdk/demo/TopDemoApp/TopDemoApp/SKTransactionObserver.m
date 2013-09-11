//
//  SKTransactionObserver.m
//  TopDemoApp
//
//  Created by fangweng on 13-2-5.
//  Copyright (c) 2013年 fangweng. All rights reserved.
//

#import "SKTransactionObserver.h"
#import "JSONKit.h"
#import "GTMBase64.h"

@implementation SKTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}


- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"transaction completeTransaction: %@",[transaction transactionIdentifier]);
    
    NSString * msg = [[[NSString alloc]initWithFormat:@"订购成功: %@ %d %@",[[transaction payment] productIdentifier],[[transaction payment] quantity],[transaction transactionDate] ] autorelease];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    
    [alertView show];
    
    [alertView release];
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    
    
    NSURL *sandboxStoreURL = [[[NSURL alloc] initWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"] autorelease];

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:sandboxStoreURL];
    
    NSString *receipt = [GTMBase64 stringByEncodingData:[transaction transactionReceipt]];
    
    NSDictionary *body = @{@"receipt-data":receipt};
    
    [req setHTTPMethod:@"POST"];
    
    [req setHTTPBody:[body JSONData]];
    
    NSData *data= [NSURLConnection sendSynchronousRequest:req
									   returningResponse:nil
                                                   error:nil];
    
    if (data)
    {
        NSDictionary *resp = [data objectFromJSONData];
        
        NSString *status = [resp objectForKey:@"status"];
        //NSData *receipt = [resp objectForKey:@"receipt"];
        
        NSLog(@"status : %@",status);
    }
    
}

//{
//    receipt =     {
//        bid = "com.taobao.sellerplatform";
//        bvrs = "1.0";
//        "item_id" = 599583953;
//        "original_purchase_date" = "2013-02-05 06:50:25 Etc/GMT";
//        "original_purchase_date_ms" = 1360047025974;
//        "original_purchase_date_pst" = "2013-02-04 22:50:25 America/Los_Angeles";
//        "original_transaction_id" = 1000000063898510;
//        "product_id" = "com.taobao.sellerplatform.component.common";
//        "purchase_date" = "2013-02-05 06:50:25 Etc/GMT";
//        "purchase_date_ms" = 1360047025974;
//        "purchase_date_pst" = "2013-02-04 22:50:25 America/Los_Angeles";
//        quantity = 1;
//        "transaction_id" = 1000000063898510;
//        "unique_identifier" = 0000b0114818;
//        "unique_vendor_identifier" = "E143CD13-F4ED-434A-B931-3E984EC2FF2D";
//    };
//    status = 0;
//}


- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"transaction restoreTransaction: %@",[transaction transactionIdentifier]);
    
    NSString * msg = [[[NSString alloc]initWithFormat:@"订购成功: %@ %d %@",[[transaction payment] productIdentifier],[[transaction payment] quantity],[transaction transactionDate] ] autorelease];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    
    [alertView show];
    
    [alertView release];
    
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"transaction error: %d",transaction.error.code);
    }
    
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    
}

@end
