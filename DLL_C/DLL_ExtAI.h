#include <stdio.h>
#include "DLL_Library.h"


class TExtAI: public IEvents
{
	protected:
		ULONG m_cRef;
	public:
		ui8 ID;
		pIActions Actions;
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