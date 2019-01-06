@REM With StdCall convention there is problem that name of function contain count of bytes in head
@REM For example function Test(int a, int b) will be processed by compiler like Test@8 or even _Test@8
@REM Universal solution for all compilers: create *.def file, compile with this file

g++ -m32 -c -o DLL_library.o DLL_library.cpp -D ADD_EXPORTS
g++ -m32 -o DLL_library.dll DLL_library.o DLL_Library.def -s -shared -Wl,--subsystem,windows
@rem ,kill-at

PAUSE