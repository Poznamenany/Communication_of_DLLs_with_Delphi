#include <stdint.h>

using b = bool;        //              0 to 1
using ui8 = uint8_t;   //              0 to 255
using si8 = int8_t;    //           -128 to 127
using ui16 = uint16_t; //              0 to 65,535
using si16 = int16_t;  //        -32,768 to 32,767
using ui32 = uint32_t; //              0 to 4,294,967,295
using si32 = int32_t;  // -2,147,483,648 to 2,147,483,647
using ui64 = uint64_t; //              0 to 18,446,744,073,709,551,615
using si64 = int64_t;  //        -(2^63) to (2^63)-1
using f4 = float;
using f8 = double;
// using f12 = long double;	

// String
using wStr = wchar_t;

// Pointers
typedef b * pb;
typedef ui8 * pui8;
typedef si8 * psi8;
typedef ui16 * pui16;
typedef si16 * psi16;
typedef ui32 * pui32;
typedef si32 * psi32;
typedef ui64 * pui64;
typedef si64 * psi64;
typedef f4 * pf4;
typedef f8 * pf8;

// Structures
struct TDLLConfig {
	wStr const* Author;
	wStr const* Description;
	wStr const* ExtAIName;
	ui32 Version;
};

struct TDLLpConfig
{
	wStr const* Author;
	ui32 AuthorLen;
	wStr const* Description;
	ui32 DescriptionLen;
	wStr const* ExtAIName;
	ui32 ExtAINameLen;
	ui32 Version;
};