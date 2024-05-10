//
//  CloudKitPlugin.m
//  App
//
//  Created by Víctor Peña Romero on 09/05/24.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(CloudKitPlugin, "CloudKitPlugin",
    CAP_PLUGIN_METHOD(createRecord, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(fetchRecords, CAPPluginReturnPromise);
)
