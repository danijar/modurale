#pragma once

#include <functional>
#include <exception>

#ifdef _MSC_VER
#include "integer_sequence.hpp"
#endif

namespace engine {
namespace manager {
namespace event {

using vector_of_any = std::vector<boost::any>;
using dispatcher_type = std::function<void(vector_of_any const&)>;

class bad_arity : public std::exception {
    const char *what() const throw()
    {
        return "Callback expects more parameters than provided.";
    }
};

class bad_types : public std::exception {
    const char *what() const throw()
    {
        return "Callback expects other parameter types than provided.";
    }
};

template<typename... Args> class dispatcher {
public:
    template<typename F>
    dispatcher(F f);
    void operator() (vector_of_any const &v);

private:
    template<int... Is>
    void do_call(vector_of_any const &v, std::integer_sequence<int, Is...>);
    template<typename T> T
    get_ith(vector_of_any const &v, int i);

    std::function<void(Args...)> m_function;
};

template<typename T> struct function_traits;

template<typename R, typename C, typename... Args>
struct function_traits<R(C::*)(Args...)> {
    using args_type = std::tuple<Args...>;
};

template<typename R, typename C, typename... Args>
struct function_traits<R(C::*)(Args...) const> {
    using args_type = std::tuple<Args...>;
};

template<typename T>
struct dispatcher_maker;

template<typename... Args>
struct dispatcher_maker<std::tuple<Args...>> {
    template<typename F> dispatcher_type make(F &&f);
};

template<typename F>
dispatcher_type make_dispatcher(F &&f);

template<typename... Args>
dispatcher_type make_dispatcher(void(*f)(Args...));

} // namespace event
} // namespace manager
} // namespace engine

#include "dispatcher.inl"
