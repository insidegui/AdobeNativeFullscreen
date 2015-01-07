//
//  FakePlugin.cpp
//  NativeFullscreen
//
//  Created by Guilherme Rambo on 07/01/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

#include "FakePlugin.h"

PREMPLUGENTRY DllExport xImportEntry (csSDK_int32 selector, imStdParms *stdParms, void *param1, void *param2)
{
    return imUnsupported;
}