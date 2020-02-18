struct tr_in {
   int a;
   int b;
};

struct tr_out {
   int data;
};

#ifdef REFMOD_PYTHON

#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>
#include <boost/python.hpp>

typedef boost::shared_ptr<tr_in> tr_in_ptr;
typedef boost::shared_ptr<tr_out> tr_out_ptr;


BOOST_PYTHON_MODULE(trans)
{
    boost::python::class_<tr_in, tr_in_ptr>("tr_in")
        .def_readwrite("a", &tr_in::a);
    ;
    boost::python::class_<tr_in, tr_in_ptr>("tr_in")
        .def_readwrite("b", &tr_in::b);
    ;
    boost::python::class_<dtr_out, dtr_out_ptr>("dtr_out")
        .def_readwrite("data", &dtr_out::data);
    ;
};

#endif

#ifdef UVMC_UTILS_2
UVMC_UTILS_2(tr_in, a, b)
UVMC_UTILS_1(tr_out, data)
#else

inline ostream& operator<< (ostream& os, const a_tr& arg) {
  os << " d=" << arg.d << "  a=" << arg.a;
  return os;
}

inline istream& operator >> (istream& is,  a_tr& arg){
  double d;
  is >> d >> arg.a;
  arg.d = sc_time(d, SC_NS);
  return is;
}

#endif

