//
//  SafeAreaPlugin.m
//  App
//
//  Created by Víctor Peña Romero on 08/08/23.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(SafeAreaPlugin, "SafeAreaPlugin",
    CAP_PLUGIN_METHOD(getInsets, CAPPluginReturnPromise);
)
