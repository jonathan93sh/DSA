#include "Talkthrough.h"

// Modify and insert your notch filter here!!!!

int x1_, x2_ = 0;
int y1_, y2_ = 0;

//int b[] = {(short)(1.9895f*(2^3)), 1};
//short a[] = {(short)(1.9875f*(2^3)), (short)(0.9980f*(2^3))};

short myVolume(short x)
{

	//short y = x<<2 - 19895*x_[0] + x_[1] + 19875*y_[0] - 9980*y_[1];
	int y = ((int)x<<14) + (-32595*x1_) + (x2_<<14) + (32269*y1_) + (-16058*y2_);
	y2_ = y1_;
	x2_ = x1_;

	y1_ = y>>14;

	x1_ = x;

	return (short)(y>>14);
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
