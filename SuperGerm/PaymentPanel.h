//
//  PaymentPanel.h
//  SuperGerm
//
//  Created by Ariequ on 13-11-28.
//  Copyright (c) 2013年 Ariequ. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface PaymentPanel : CCLayer <SKProductsRequestDelegate,UIAlertViewDelegate,SKPaymentTransactionObserver>
-(void) showAlerView;
@end
