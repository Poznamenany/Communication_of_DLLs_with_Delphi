#include <stdio.h>
#include "DLL_Library.h"
#include "DLL_ExtAI.h"

// Constants
const ui8 MAX_EXT_AI_CNT = 12;

// Variables
ui8 ExtAICnt; // ExtAI cnt
pTExtAI ExtAI [MAX_EXT_AI_CNT]; // pointers to possible ExtAI
pCallback1 Callback1;// Callback from communication interface in C to Delphi

// Events
void __stdcall InitDLL(void)
{
	printf("DLL InitDLL - C\n");
	ExtAICnt = 0;
	for (ui8 K = 0; K < MAX_EXT_AI_CNT; K++)
	{
		ExtAI[K] = NULL;
	}
}

void TerminDLL(void) 
{
	printf("DLL TerminDLL - C\n");
	for (ui8 K = 0; K < MAX_EXT_AI_CNT; K++)
	{
		if (ExtAI[K] != NULL)
		{
			ExtAI[K]->Release();
		}
	}
}


HRESULT NewExtAI(pIEvents *aEvents)
{
	printf("DLL NewExtAI - C\n");
	ExtAI[ExtAICnt] = new TExtAI();
    *aEvents = ExtAI[ExtAICnt];
    if (*aEvents)
    {
		ExtAICnt++;
        (*aEvents)->AddRef();
        return S_OK;
    }
    else
    {
        return E_NOINTERFACE;
    }
}


void InitNewExtAI(ui8 aID, pIActions aActions)
{
	printf("DLL InitNewExtAI - C\n");
	ExtAI[ExtAICnt-1]->ID = aID;
	ExtAI[ExtAICnt-1]->Actions = aActions;
}


// Register callback
void FCN_TYPE RegisterCallback1(pCallback1 aCallback1);
void RegisterCallback1(pCallback1 aCallback1)
{
	printf("DLL Callback1\n");
	Callback1 = aCallback1;
	b res = (*aCallback1)( ui8(212) ); // Test callback
}


int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void* lpReserved)
{
    return 1;
}