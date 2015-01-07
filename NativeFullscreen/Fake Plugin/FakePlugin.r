#ifndef PRWIN_ENV
#include <CoreServices/CoreServices.r>
#define MAC_ENV
#include "PrSDKPiPLVer.h"
#include "PrSDKPiPL.r"
#endif

// The following string should be localized
#define plugInName		"NativeFullscreen Fake Plugin"

// This name should not be localized or updated
#define plugInMatchName	"NativeFullscreen Fake Plugin"

resource 'PiPL' (16000) {
    {
        // The plug-in type
        Kind {PrImporter},
        
        // The name as it will appear in a menu
        Name {plugInName},
        
        // The internal name of this plug-in
        AE_Effect_Match_Name {plugInMatchName},
    }
};

// [TODO] This definition should be moved to a common location
type 'IMPT'
{
    longint;
};

resource 'IMPT' (1000)
{
    0x0000
};