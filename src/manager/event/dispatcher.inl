#pragma once

#include "dispatcher.hpp"

namespace engine {
namespace manager {
namespace event {

template<typename... Args>
template<typename F>
dispatcher<Args...>::dispatcher(F f) : m_function(std::move(f)) {}

template<typename... Args>
void dispatcher<Args...>::operator() (vector_of_any const &v)
{
    if (v.size() < sizeof...(Args))
        throw bad_arity();
    return do_call(v, std::make_integer_sequence<int, sizeof...(Args)>());
}

template<typename... Args>
template<int... Is>
void dispatcher<Args...>::do_call(vector_of_any const &v, std::integer_sequence<int, Is...>)
{
    try {
        return m_function((get_ith<Args>(v, Is))...);
    } catch (boost::bad_any_cast const&) {
        throw bad_types();
    }
}

template<typename... Args>
template<typename T>
T dispatcher<Args...>::get_ith(vector_of_any const &v, int i)
{
    return boost::any_cast<T>(v[i]);
}

template<typename... Args>
template<typename F>
dispatcher_type dispatcher_maker<std::tuple<Args...>>::make(F &&f)
{
    return dispatcher<Args...>{std::forward<F>(f)};
}

template<typename F>
dispatcher_type make_dispatcher(F &&f)
{
    using f_type = decltype(&F::operator());
    using args_type = typename function_traits<f_type>::args_type;
    return dispatcher_maker<args_type>{}.make(std::forward<F>(f));
}

template<typename... Args>
dispatcher_type make_dispatcher(void(*f)(Args...))
{
    return dispatcher_maker<std::tuple<Args...>>{}.make(f);
}

} // namespace event
} // namespace manager
} // namespace engine
