#include <stdio.h>
#include "DLL_Library.h"


class TExtAI: public IEvents
{
	protected:
		ULONG m_cRef;
	public:
		ui8 ID;
		pIActions Actions;
		pIStates States;
		TExtAI(void);
		~TExtAI(void);
		// IEvents
		void ADDCALL Event1(ui32 aID);
		// IUnknown
		ULONG ADDCALL AddRef(void);
		ULONG ADDCALL Release(void);
		HRESULT ADDCALL QueryInterface(REFIID riid,void **ppv);
};

typedef TExtAI * pTExtAI;


TExtAI::TExtAI(void)
{
	ID = 0;
	m_cRef = 0;
	Actions = NULL;
	States = NULL;
	printf("    ExtAI: Constructor\n");
}

TExtAI::~TExtAI(void)
{
	printf("    ExtAI: Destructor\n");
}


// Methods of IConsole wrapping Console
void TExtAI::Event1(ui32 aID)
{
	printf("    TExtAI: Event1, class ID: %d; parameter aID: %d\n",ID,aID);
	Actions->Action1(11, 22); // Check callback in Delphi
	ui8 testVar = States->State1(22); // Check callback in Delphi
	printf("    TExtAI: Event1, class ID %d; testVar: %d\n",ID,testVar);
	// Get array (pointer to first element) from Main program and copy memory so we can work with it
	pui32 pMap;
	si32 mapLen;
	if (States->State2(pMap,mapLen) == true)
	{
		pui32 Map = new ui32[mapLen];
		memcpy(Map, pMap, mapLen * sizeof(Map[0])); 
		printf("    TExtAI: Event1, class ID %d; log array:",ID);
		for (ui32 K = 0; K < mapLen; K++)
		{
			printf(" %d",Map[K]);
		}
		printf("\n");
		// ...
		delete [] Map;
	}
}


// Methods of IUnknown
ULONG TExtAI::AddRef()
{
	ULONG Cnt = InterlockedIncrement(&m_cRef);
	//printf("      TExtAI: AddRef%d\n", Cnt);
	return Cnt;
}

ULONG TExtAI::Release()
{
	ULONG result = InterlockedDecrement(&m_cRef);
	//printf("      TExtAI: Release%d\n", result);
	if (!result)
	{
		//printf("    TExtAI: Release\n");
		delete this;
	}
	return result;
}

HRESULT TExtAI::QueryInterface(REFIID riid, void **ppvObject)
{
	HRESULT rc = S_OK;
	*ppvObject = NULL;

	//  Multiple inheritance requires an explicit cast
	if (riid == IID_IEvents)
		*ppvObject = (IEvents*)this; 
	else
		rc = E_NOINTERFACE;    

	//Return a pointer to the new interface and thus call AddRef() for the new index
	if (rc == S_OK)
		this->AddRef(); 
	return rc;
}