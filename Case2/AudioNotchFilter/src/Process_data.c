#include "Talkthrough.h"

// Modify and insert your notch filter here!!!!
short myVolume(short x)
{
	// Attenuation
	return x>>2;
}

//--------------------------------------------------------------------------//
// Function:	Process_Data()												//
//																			//
// Description: This function is called from inside the SPORT0 ISR every 	//
//				time a complete audio frame has been received. The new 		//
//				input samples can be found in the variables iChannel0LeftIn,//
//				iChannel0RightIn, iChannel1LeftIn and iChannel1RightIn 		//
//				respectively. The processed	data should be stored in 		//
//				iChannel0LeftOut, iChannel0RightOut, iChannel1LeftOut,		//
//				iChannel1RightOut, iChannel2LeftOut and	iChannel2RightOut	//
//				respectively.												//
//--------------------------------------------------------------------------//
void Process_Data(void)
{
	short xn, yn;

	// FlagAMode is changed by using pushbutton	SW4 on board..
	switch (FlagAMode) {
		case PASS_THROUGH : 
		
			iChannel0LeftOut = iChannel0LeftIn;
			
 //			iChannel0RightOut = iChannel0RightIn;
			iChannel0RightOut = iChannel0LeftIn; // left in comes out on both outputs
			
			iChannel1LeftOut = iChannel1LeftIn;
			iChannel1RightOut = iChannel1RightIn;
			break;
			
			
		case IIR_FILTER_ACTIVE : // Button PF8 pressed
	
			xn = (short) (iChannel0LeftIn >> 16); // Keeping 16 bits
			
			yn = myVolume(xn);
			
			iChannel0LeftOut = yn << 16; // Convert to 24 bits
			iChannel0RightOut = yn << 16;
			break;
	
	}	// end switch
	
	
}
