//
//  PaymentPanel.m
//  SuperGerm
//
//  Created by Ariequ on 13-11-28.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import "PaymentPanel.h"
#import "CCBReader.h"
#import "GameStartScene.h"


@implementation PaymentPanel

-(void)onPay
{
    if ([SKPaymentQueue canMakePayments]) {
        // 执行下面提到的第5步：
        [self getProductInfo];
    } else {
        NSLog(@"失败，用户禁止应用内付费购买.");
    }
}

// 下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfo {
    NSSet * set = [NSSet setWithArray:@[@"1001"]];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

// 以上查询的回调函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"无法获取产品信息，购买失败。");
        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // 监听购买结果
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//}

-(void) onEnter
{
    [super onEnter];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    // Your application should implement these two methods.
    NSString * productIdentifier = transaction.payment.productIdentifier;
//    NSString * receipt = [transaction.transactionReceipt base64EncodedString];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"%@",transaction.error);
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    } else {
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) showAlerView
{
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:@"buy a life" message:@"fu huo" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"confirm", nil];
    [alertView show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self onPay];
    }
    else
    {
//        [[CCDirector sharedDirector] replaceScene: [CCBReader sceneWithNodeGraphFromFile:@"MainMenueScene.ccbi"]];
        [[CCDirector sharedDirector] replaceScene: [[GameStartScene alloc] init]];


    }
}


@end
