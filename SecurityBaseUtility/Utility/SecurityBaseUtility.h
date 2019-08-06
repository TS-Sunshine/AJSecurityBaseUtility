//
//  SecurityBaseUtility.h
//  TouchIDDemo
//
//  Created by 安静的为你歌唱 on 2019/4/8.
//  Copyright © 2019 安静的为你歌唱. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface SecurityBaseUtility : NSObject

/**
 *  TouchIdValidationFailureBack
 *
 *  @param result LAError枚举
 */
typedef void(^TouchIdValidationFailureBack)(LAError result);

+ (instancetype) sharedInstance;

/**
 *  TouchId 验证
 *
 *  @param localizedReason TouchId信息
 *  @param title           验证错误按钮title
 *  @param backSucces      成功返回Block
 *  @param backFailure     失败返回Block
 */
- (void)evaluatePolicy:(NSString *)localizedReason
         fallbackTitle:(NSString *)title
          SuccesResult:(void(^)(void))backSucces
         FailureResult:(TouchIdValidationFailureBack)backFailure;

/**
 是否支持touchID或者faceID

 @return YES 支持 NO 不支持
 */
- (BOOL)isCanUseBiometrics;

/**
 是否是faceID

 @return YES 是  NO 不是 为touchID
 */
- (BOOL)isFaceID;

/**
 判断指纹库是否发生变化

 @return NO 没有变化 YES 有变化
 */
- (BOOL)biometricsLibraryDidChanged NS_AVAILABLE(10_11, 9_0);

/**
 保存指纹库信息
 */
- (void)saveBiometricsLibraryInfo NS_AVAILABLE(10_11, 9_0);

/**
 生物识别支付开关是否打开

 @return YES 打开 NO关闭
 */
- (BOOL)isBiometricsOpened;


/**
 是否开启生物识别支付

 @param open YES 开启 NO 关闭
 */
- (void)biometricsWith:(BOOL)open;


/**
 返回设备上生物时候的错误状态

 @return LAError
 */
- (LAError)deviceBiometricsState;

@end
