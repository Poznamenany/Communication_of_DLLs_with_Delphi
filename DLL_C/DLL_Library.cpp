#include <stdio.h>
#include "DLL_Library.h"

// Actions
pAction1 Action1;

// States
pState1 State1;

// Actions
void CallbackAction1(pAction1 aAction1)
{
	printf("DLL CallbackAction1\n");
	Action1 = aAction1;
	b res = (*aAction1)( ui8(211) );
	//b res = Action1( ui8(211) );
}


// Events
void InitDLL(void)
{
	printf("DLL InitDLL - C\n");
}

void TerminDLL(void) 
{
	printf("DLL TerminDLL - C\n");
}

void Event1(ui32 aID, ui16 aAct)
{
	printf("DLL Event1, ID: %u; Act: %u\n", aID, aAct);
}

void Loop(si64 aTick)
{
	printf("DLL Loop, aTick: %10lld\n", (long long)aTick);
	ui32 test = State1(211);
	Action1(211);
}


// States
void CallbackState1(pState1 aState1)
{
	printf("DLL CallbackState1\n");
	State1 = aState1;
	si16 res = State1(211);
	printf("DLL Return State1 %d\n", res);
}

