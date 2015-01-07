//
//  FakePlugin.h
//  NativeFullscreen
//
//  Created by Guilherme Rambo on 07/01/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

#include "PrSDKImport.h"
#include "PrSDKPixelFormat.h"

// Declare plug-in entry point with C linkage
#ifdef __cplusplus
extern "C" {
#endif
    
    PREMPLUGENTRY DllExport xImportEntry (csSDK_int32 selector, imStdParms *stdParms, void *param1, void *param2);
    
#ifdef __cplusplus
}
#endif