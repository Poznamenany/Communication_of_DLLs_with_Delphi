//*
#include "DataTypes.h"

#ifndef DLL_Library_H
#define DLL_Library_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef BUILDING_DLL_Library
#define FCN_TYPE __declspec(dllexport)
#else
#define FCN_TYPE __declspec(dllimport)
#endif

// Actions
typedef b (*pAction1) (ui8);
void FCN_TYPE CallbackAction1(pAction1 aAction1);

// Events
void FCN_TYPE InitDLL(void);
void FCN_TYPE TerminDLL(void);
void FCN_TYPE Event1(ui32 aID, ui16 aAct);
void FCN_TYPE Loop(si64 aTick);

// States
typedef si16 (*pState1) (ui32);
void FCN_TYPE CallbackState1(pState1 aState1);

#ifdef __cplusplus
}
#endif


#endif  // EXAMPLE_DLL_H