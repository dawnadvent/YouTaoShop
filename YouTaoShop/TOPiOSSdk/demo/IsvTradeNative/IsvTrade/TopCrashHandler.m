//
//  TopCrashHandler.m
//  TOPIOSSdk
//
//  异常捕获处理
//  Created by fangweng on 12-12-18.
//  Copyright (c) 2012年 tmall.com. All rights reserved.
//

#import "TopCrashHandler.h"

@interface TopCrashHandler()

+(void) log:(NSString *)crashReason;

@end

void CrashHandlerUninstallUncaughtExceptionHandler()
{
	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
    signal(SIGQUIT, SIG_DFL);
    signal(SIGTRAP, SIG_DFL);
    signal(SIGEMT, SIG_DFL);
    signal(SIGSYS, SIG_DFL);
    signal(SIGXCPU, SIG_DFL);
    signal(SIGXFSZ, SIG_DFL);
    signal(SIGALRM, SIG_DFL);

}


void CrashHandlerHandleException(NSException *exception)
{
    [TopCrashHandler log:[exception reason]];
    //[exception callStackSymbols];
    
    CrashHandlerUninstallUncaughtExceptionHandler();
    [exception raise];
}


void CrashHandlerSignalHandler(int signal)
{
    NSString *reason = [NSString stringWithFormat:@"signal:%d", signal];
    [TopCrashHandler log:reason];
    CrashHandlerUninstallUncaughtExceptionHandler();
    kill(getpid(), signal);
}


void CrashHandlerInstallUncaughtExceptionHandler()
{
	NSSetUncaughtExceptionHandler(&CrashHandlerHandleException);
	signal(SIGABRT, CrashHandlerSignalHandler);
	signal(SIGILL, CrashHandlerSignalHandler);
	signal(SIGSEGV, CrashHandlerSignalHandler);
	signal(SIGFPE, CrashHandlerSignalHandler);
	signal(SIGBUS, CrashHandlerSignalHandler);
	signal(SIGPIPE, CrashHandlerSignalHandler);
    signal(SIGQUIT, CrashHandlerSignalHandler);
    signal(SIGTRAP, CrashHandlerSignalHandler);
    signal(SIGEMT, CrashHandlerSignalHandler);
    signal(SIGSYS, CrashHandlerSignalHandler);
    signal(SIGXCPU, CrashHandlerSignalHandler);
    signal(SIGXFSZ, CrashHandlerSignalHandler);
    signal(SIGALRM, CrashHandlerSignalHandler);
    
}

@implementation TopCrashHandler

static TopTracker * _topTracker;
static BOOL exceptionHandlerInstalled = NO;

+(void) monitor:(TopTracker *) topTracker
{
    @synchronized(self) {
        
        if (!exceptionHandlerInstalled)
        {
            exceptionHandlerInstalled = YES;
            
            _topTracker = topTracker;
            CrashHandlerInstallUncaughtExceptionHandler();
            
        }
    }
    
}

+(void) log:(NSString *)crashReason
{
    [_topTracker trackError:@"crash" errorcode:@"" msg:crashReason isLocal:FALSE forceFlush:TRUE];
    
    [NSThread sleepForTimeInterval:3];
    
}


@end
