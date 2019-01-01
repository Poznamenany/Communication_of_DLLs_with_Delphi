g++ -m32 -c -DBUILDING_DLL_Library DLL_library.cpp
g++ -m32 -shared -o DLL_library.dll DLL_library.o -Wl,--out-implib,libDLL_library.a