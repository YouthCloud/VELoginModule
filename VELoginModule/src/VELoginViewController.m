//
//  VELoginViewController.m
//  voiceexpress
//
//  Created by Yaning Fan on 13-9-11.
//  Copyright (c) 2013年 CYYUN. All rights reserved.
//

#import "VELoginViewController.h"
#import "VEAppDelegate.h"
#import "MobClick.h"
#import "AFNetworking.h"
#import "UIViewController+HUD.h"
#import "Marcos.h"
#import "DKUtils.h"

@interface VELoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIView *checkBoxContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;

@property (nonatomic, assign) BOOL isAutoLoginOn;


@end

@implementation VELoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _userNameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
    
    _userNameTextField.delegate = self;
    _userNameTextField.clearsOnBeginEditing = YES;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordTextField.delegate = self;
    _passWordTextField.clearsOnBeginEditing = YES;
    _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //iphone 3,4,4s 往上移20.0f
    if ([UIScreen mainScreen].bounds.size.height <= 480.0f) {
        
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:60]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:19]];
        
    }
    
    //初始化checkboxImage
    //NSLog(@"%@------",USER_INFO);
    //_isAutoLoginOn = USER_INFO.autoLogin;
    [self refreshCheckBoxImageView:_isAutoLoginOn];
    
    UITapGestureRecognizer *backgroudTapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:backgroudTapGr];
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *checkBoxTapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkBoxTapped:)];
    [self.checkBoxContainerView addGestureRecognizer:checkBoxTapGr];
    self.checkBoxContainerView.userInteractionEnabled = YES;
    // Do any additional setup after loading the view.
    
    //自动登录
    if (_isAutoLoginOn) {
        //self.passWordTextField.text = USER_INFO.password;
        [self loginBtnTapped:nil];
    }

    
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LoginView"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginView"];
}


#pragma mark - textField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_userNameTextField isFirstResponder]) {
        [self.passWordTextField becomeFirstResponder];
    }else{
        [self performSelector:@selector(loginBtnTapped:) withObject:self];
    }
    return YES;
}

#pragma mark Target - Action

- (void)backgroundTapped:(UIGestureRecognizer *)gr
{
    [self.view endEditing:YES];
}

- (void)checkBoxTapped:(UIGestureRecognizer *)gr
{
    _isAutoLoginOn = !_isAutoLoginOn;
    
    [self refreshCheckBoxImageView:_isAutoLoginOn];
    
}
- (IBAction)loginBtnTapped:(id)sender {
    [self.view endEditing:YES];
    if ([DKUtils isBlankString:_userNameTextField.text] || [DKUtils isBlankString:_passWordTextField.text]) {
        [self showHint:@"用户名或密码为空"];
        return;
    }
    
}

#pragma mark - helper method

//-(void)doLoginAction:(NSString *)userName withPassWord:(NSString *)password
//{
//    
//    //NSString *md5Password = [DKUtils md5:password];
//    NSString *paramStr = [NSString stringWithFormat:@"username=%@&password=%@&mtype=1&version=%@",userName,password,APP_VERSION];
//    
//    // 请求URL
//    NSString *loginString = [NSString stringWithFormat:@"%@/login.htm", COMMONURL];
//    NSURL *loginUrl = [NSURL URLWithString:loginString];
//    
//    
//    [self.httpRequestLoader cancelAsynRequest];
//    
//    [self.httpRequestLoader startAsynRequestWithURL:loginUrl withParams:paramStr];
//    
//    __weak typeof(self) weakSelf = self;
//    [self.httpRequestLoader setCompletionHandler:^(NSDictionary *resultData, NSString *error){
//        [weakSelf hideHud];
//        if (resultData != nil)
//        {
//            NSString *resultValue = [resultData objectForKey:@"type"];
//            if ([resultValue isEqualToString:@"success"])
//            {
//                NSDictionary *userData = [resultData objectForKey:@"data"];
//                int userId = [[userData objectForKey:@"userId"] intValue];
//                NSString *nickName = [userData objectForKey:@"name"];
//                NSString *sessionToken = [userData objectForKey:@"sessionToken"];
//                BOOL turnTask = [[userData objectForKey:@"turnTask"] intValue] == 1 ? YES : NO;
//                BOOL createTask = [[userData objectForKey:@"createTask"] intValue] == 1 ? YES : NO;
//                [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                //更新用户信息
//                [[DKUserInfoManager shareManager] updateUserInfoWithUserName:userName password:password userId:userId nickName:nickName sessionToken:sessionToken autoLogin:weakSelf.isAutoLoginOn turnTask:turnTask createTask:createTask];
//                
//                // 显示登录成功之后的界面
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [weakSelf doActionAfterLoginSuccess];
//                    
//                    [DKUtils setTabbarViewControllerAsRootController];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:DKAppSignInSuccessNotification object:weakSelf];
//                });
//            }
//            else
//            {
//                NSString *errorInfo = [resultData objectForKey:@"message"];
//                if (errorInfo.length > 0) {
//                    [weakSelf showHint:errorInfo];
//                }
//            }
//        }
//        
//        if (error != nil)
//        {
//            [weakSelf showHint:@"网络连接异常"];
//        }
//    }];
//    
//}

#pragma mark - helper method

- (void)doActionAfterLoginSuccess
{
    // 重新注册推送服务，因为退出登录时关闭了推送服务
    [DKUtils registerForRemoteNotifications];

}



- (void)refreshCheckBoxImageView:(BOOL)isAutoLoginOn
{
    UIImage *image = isAutoLoginOn ? [UIImage imageNamed:@"checkbox-selected"] : [UIImage imageNamed:@"checkbox-normal"];
    [self.checkBoxImageView setImage:image];
}
@end
