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
		void __stdcall Event1(ui32 aID);
		// IUnknown
		ULONG __stdcall AddRef(void);
		ULONG __stdcall Release(void);
		HRESULT __stdcall QueryInterface(REFIID riid,void **ppv);
};

typedef TExtAI * pTExtAI;


TExtAI::TExtAI(void)
{
	ID = 0;
	m_cRef = 0;
	printf("ExtAI: Constructor\n");
}

TExtAI::~TExtAI(void)
{
	printf("ExtAI: Destructor\n");
}

// Methods of IConsole wrapping Console
void TExtAI::Event1(ui32 aID)
{
	printf("TExtAI: Event1, class ID: %d; parameter aID: %d\n",ID,aID);
	Actions->Action1(11, 22); // Check callback in Delphi
}

// Methods of IUnknown
ULONG TExtAI::AddRef()
{
	return InterlockedIncrement(&m_cRef);
}

ULONG TExtAI::Release()
{
	ULONG result = InterlockedDecrement(&m_cRef);
	if (!result)
		delete this;
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