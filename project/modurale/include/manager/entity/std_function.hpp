#pragma once

#include <functional>

namespace engine {
namespace manager {
namespace entity {

// Decide whether a template type is an std::function specialization
template<class T>
struct is_std_function : std::false_type {};

template<class T>
struct is_std_function<std::function<T>> : std::true_type{};

// Get std::function specialization from general template type
template<typename T>
struct deduce_std_function;

template<typename R, typename C, typename... T>
struct deduce_std_function<R(C::*)(T...)> {
    using type = std::function<R(T...)>;
};

template<typename R, typename C, typename... T>
struct deduce_std_function<R(C::*)(T...) const> {
    using type = std::function<R(T...)>;
};

} // namespace entity
} // namespace manager
} // namespace engine
