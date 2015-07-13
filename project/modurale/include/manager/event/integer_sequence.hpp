#pragma once

// This file injects an implementation of std::integer_sequence
// from C++14 into the standard namespace, because it is not
// available on all targeted tool chains.

namespace std {

template<class T, int... Is>
struct integer_sequence {};

template<class T, int N, int... Is>
struct make_integer_sequence : make_integer_sequence<T, N - 1, N - 1, Is...> {};

template<class T, int... Is>
struct make_integer_sequence<T, 0, Is...> : integer_sequence<T, Is...> {};

} // namespace std
