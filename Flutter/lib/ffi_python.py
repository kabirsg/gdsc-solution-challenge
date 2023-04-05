import cffi

ffi = cffi.FFI()

ffi.cdef("""
    void run_cilent_analytics();
""")

ffi.set_source("ffi_python_c", '''
    #include "python.h"

    void run_cilent_analytics() {
        Py_Initialize();
        PyRun_SimpleString("import sys");
        PyRun_SimpleString("sys.path.append('Flutter/lib/')");
        PyObject* pModule = PyImport_ImportModule("ffi_python.py"); 
        PyObject* pFunc = PyObject_GetAttrString(pModule, "run_cilent_analytics");
        PyObject_CallObject(pFunc, NULL);
        Py_Finalize();
    }
''')

ffi.compile()
