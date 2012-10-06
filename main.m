// 
// main.m
// Fridge
// 
// Created by Árpád Goretitty on 04/10/2012.
// Licensed under the 3-clause BSD License
// 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

int main(int argc, char **argv)
{
        NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];

        int exitCode = UIApplicationMain(argc, argv, nil, @"AppDelegate");

        [p release];
        return exitCode;
}
