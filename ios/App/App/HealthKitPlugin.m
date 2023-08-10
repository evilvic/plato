//
//  HealthKitPlugin.m
//  App
//
//  Created by Víctor Peña Romero on 08/08/23.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(HealthKitPlugin, "HealthKitPlugin",
    CAP_PLUGIN_METHOD(requestAuthorization, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(queryHKitSampleType, CAPPluginReturnPromise);
)
