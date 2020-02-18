// reference model calling python function

#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>
#include <boost/python.hpp>

namespace bp = boost::python;

bp::object load_python(const char *file, const char *func) {
    bp::object main_module;
    Py_Initialize();
    try {
       main_module = bp::import("__main__");
       bp::object main_namespace = main_module.attr("__dict__");
       bp::object simple = exec_file(file, main_namespace, main_namespace);

#if PY_MAJOR_VERSION >= 3
       PyInit_trans();
#else
       inittrans();
#endif
        cout << "Info: SystemC: Python: loaded function " << func
             << " from file " << file << endl;
    } catch (bp::error_already_set&) {
        PyErr_Print();
        cout << "ERROR: SystemC: Python: failed to load " << func
             << " from file " << file << endl;
        sc_stop();
    }
    return main_module.attr(func);
}


SC_MODULE(refmod) {
  sc_port<tlm_get_peek_if<tr_in> > in;
  sc_port<tlm_put_if<tr_out> > out;

  bp::object pFunc;

  void p() {

    tr_in_ptr tr_in_ptr = boost::make_shared<tr_in>();
    tr_out_ptr tr_out_ptr = boost::make_shared<tr_out>();
    while (1) {

      *tr_in_ptr = in->get();

      try {
        pFunc(tr_in_ptr, tr_out_ptr); // pass transaction to Python
      } catch (bp::error_already_set&) {
        PyErr_Print();
        cout << "ERROR: SystemC: Python: function call failed" << endl;
        sc_stop();
      }

      out->put(*tr_out_ptr);
    }
  }
  SC_CTOR(refmod): in("in"), out("out") {
     SC_THREAD(p);
     pFunc = load_python("../adder.py","adder");
  }
};


