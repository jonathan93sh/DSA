#include "Talkthrough.h"
#include "blackfin_signal.h"

// Modify and insert your notch filter here!!!!


short x_[M];
unsigned char p_ = 0;

short decimFilter(short x)
{
	// fir filter
	long y = 0;

	x_[p_] = x;

	for(unsigned char i = 0;i < M; i++)
	{
		y+=(int)h[i]*(int)x_[(i+p_)%M];
	}
	p_=(p_+1)%M;


	return (short)(y>>M_SHIFT);
}

short x2_[UP_M];
unsigned char p2_ = 0;

short interpolFilter(short x)
{
	// fir filter
	int y = 0;

	x2_[p2_] = x;

	for(unsigned char i = 0;i < UP_M; i++)
	{
		y+=(int)x2_[i];
	}
	p2_=(p2_+1)%UP_M;

	return (short)(y>>UP_M_SHIFT);
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

#define DATA_SIZE 2500

short data[DATA_SIZE];
unsigned int data_point = 0;
unsigned int point = 0;

void Process_Data(void)
{
	short xn, yn;



	// FlagAMode is changed by using pushbutton	SW4 on board..
	switch (FlagAMode) {
		case PASS_THROUGH : 
			xn = (short) (iChannel0LeftIn >> 16); // Keeping 16 bits

			yn = decimFilter(xn);
			/*
			iChannel0LeftOut = iChannel0LeftIn;
			
 //			iChannel0RightOut = iChannel0RightIn;
			iChannel0RightOut = iChannel0LeftIn; // left in comes out on both outputs
			
			iChannel1LeftOut = iChannel1LeftIn;
			iChannel1RightOut = iChannel1RightIn;
			*/
			data_point = 0;
			point = 0;
			break;
			
			
		case IIR_FILTER_ACTIVE : // Button PF8 pressed
			xn = (short) (iChannel0LeftIn >> 16); // Keeping 16 bits

			yn = decimFilter(xn);
			if(data_point < DATA_SIZE)
			{

				if(point%UP_M==0)
				{
					data[data_point] = yn;
					data_point++;
				}

				yn = interpolFilter(SIGNAL[(data_point < SIGNAL_SIZE ? data_point : (SIGNAL_SIZE-1))]);
				iChannel0LeftOut = yn << 15; // Convert to 24 bits
				iChannel0RightOut = yn << 15;

				point++;
			}

			
			break;
	
	}	// end switch
	
	
}
