//
//  SecurityBaseUtility.m
//  TouchIDDemo
//
//  Created by 安静的为你歌唱 on 2019/4/8.
//  Copyright © 2019 安静的为你歌唱. All rights reserved.
//

#import "SecurityBaseUtility.h"

@interface SecurityBaseUtility()

@property (nonatomic, strong)LAContext *context;

@end

@implementation SecurityBaseUtility

/**
 生物识别的单例
 */
+ (instancetype) sharedInstance {
    static SecurityBaseUtility *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SecurityBaseUtility alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (LAContext *)context {
    if (!_context) {
        _context = _context = [[LAContext alloc] init];
    }
    return _context;
}


- (BOOL)isFaceID{
    if (@available(iOS 11.0, *)) {
        switch (self.context.biometryType) {
            case LABiometryTypeNone:
                return NO;
                break;
            case LABiometryTypeTouchID:
                return NO;
                break;
            case LABiometryTypeFaceID:
                return YES;
                break;
            default:
                return NO;
                break;
        }
    } else {
        return NO;
    }
}

- (BOOL)isCanUseBiometrics {
    if (@available(iOS 8.0, *)) {
        //错误对象
        NSError* error = nil;
        if ([self.context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            return YES;
        }else {
            return NO;
        }
    } else {
        // Fallback on earlier versions
        return NO;
    }
}

/**
 LAErrorPasscodeNotSet           // 用户没有设置TouchID
 LAErrorTouchIDNotAvailable      // 用户设备不支持TouchID
 LAErrorTouchIDNotEnrolled         // 用户没有设置手指指纹
 */
- (LAError)deviceBiometricsState {
    //错误对象
    NSError* error = nil;
    if ([self.context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        return error.code;
    }else {
        return error.code;
    }
}

- (void)evaluatePolicy:(NSString *)localizedReason
         fallbackTitle:(NSString *)title
          SuccesResult:(void(^)())backSucces
         FailureResult:(TouchIdValidationFailureBack)backFailure {
    
    //初始化上下文对象
    if (@available(iOS 8.0, *)) {
        self.context.localizedFallbackTitle = title;
        //错误对象
        NSError* error = nil;
        //首先使用canEvaluatePolicy 判断设备支持状态
        if ([self.context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            //支持指纹验证
            [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                         localizedReason:localizedReason
                                   reply:
             ^(BOOL succes, NSError *error) {
                 if (succes) {
                     //验证成功，返回主线程处理
                     dispatch_async(dispatch_get_main_queue(), ^{
                         backSucces(succes);
                     });
                 } else {
                     NSLog(@"%@",error.localizedDescription);
                     dispatch_async(dispatch_get_main_queue(), ^{
                         backFailure(error.code);
                     });
                 }
             }];
        }else {
            NSLog(@"%@",error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                backFailure(error.code);
            });
            
        }
    } else {
        // Fallback on earlier versions
        return;
    }
}

/**
 保存开启状态时的生物识别数据
 */
- (void)saveBiometricsLibraryInfo{
    NSError* error = nil;
    if ([self.context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
        NSUserDefaults *touchIdData = [NSUserDefaults standardUserDefaults];
        if (@available(iOS 9.0, *)) {
            NSData *oldData = [self.context evaluatedPolicyDomainState];
            [touchIdData setObject:oldData forKey:@"TouchIdData"];
            [touchIdData synchronize];
        } else {
            // Fallback on earlier versions
        }
        
    }
}

- (NSData *)getTouchIdData{
    NSUserDefaults *touchIdData = [NSUserDefaults standardUserDefaults];
    NSData *old = [touchIdData objectForKey:@"TouchIdData"];
    return old;
}

- (BOOL)biometricsLibraryDidChanged{
    NSError* error = nil;
    if ([self.context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
        NSData *new = [self.context evaluatedPolicyDomainState];
        if (@available(iOS 8.0, *)) {
            if ([[self getTouchIdData] isEqual:new]) {
                return NO;
            }else{
                return YES;
            }
        } else {
            return NO;
        }
    }else{
        return NO;
    }
}

- (BOOL)isBiometricsOpened {
    NSString *isOpenStr= [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",@"BiometricsOpened"]];
    if ([isOpenStr isEqualToString:@"1"]) {
        return YES;
    }else {
        return NO;
    }
}

- (void)biometricsWith:(BOOL)open{
    //若是打开状态，则需要更新数据
    if(open){
        [self saveBiometricsLibraryInfo];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",open] forKey:[NSString stringWithFormat:@"%@",@"BiometricsOpened"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
