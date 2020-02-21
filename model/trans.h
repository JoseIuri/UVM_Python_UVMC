struct tr_in {
   int A;
   int B;
};

struct tr_out {
   long int data;
};

#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>
#include <boost/python.hpp>

typedef boost::shared_ptr<tr_in> tr_in_ptr;
typedef boost::shared_ptr<tr_out> tr_out_ptr;


BOOST_PYTHON_MODULE(trans)
{
    boost::python::class_<tr_in, tr_in_ptr>("tr_in")
        .def_readwrite("A", &tr_in::A)
        .def_readwrite("B", &tr_in::B);
    ;
    boost::python::class_<tr_out, tr_out_ptr>("tr_out")
        .def_readwrite("data", &tr_out::data);
    ;
};

UVMC_UTILS_2(tr_in, A, B)
UVMC_UTILS_1(tr_out, data)
