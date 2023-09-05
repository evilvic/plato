//
//  SuppressLongPressPlugin.m
//  App
//
//  Created by Víctor Peña Romero on 05/09/23.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(SuppressLongPressPlugin, "SuppressLongPressPlugin",
    CAP_PLUGIN_METHOD(activate, CAPPluginReturnPromise);
)
