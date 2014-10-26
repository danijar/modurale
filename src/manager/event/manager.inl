#pragma once
#include "manager.hpp"

namespace engine {
namespace manager {

template<typename... Args>
template<typename F>
event::dispatcher<Args...>::dispatcher(F f) : m_function(std::move(f)) {}

template<typename... Args>
void event::dispatcher<Args...>::operator() (std::vector<boost::any> const &v)
{
	if (v.size() < sizeof...(Args))
		throw bad_arity();
	return do_call(v, std::make_integer_sequence<int, sizeof...(Args)>());
}

template<typename... Args>
template<int... Is>
void event::dispatcher<Args...>::do_call(std::vector<boost::any> const &v, std::integer_sequence<int, Is...>)
{
	try {
		return m_function((get_ith<Args>(v, Is))...);
	} catch (boost::bad_any_cast const&) {
		throw bad_types();
	}
}

template<typename... Args>
template<typename T>
T event::dispatcher<Args...>::get_ith(std::vector<boost::any> const &v, int i)
{
	return boost::any_cast<T>(v[i]);
}

template<typename... Args>
template<typename F>
event::dispatcher_type event::dispatcher_maker<std::tuple<Args...>>::make(F &&f)
{
	return dispatcher<Args...>{std::forward<F>(f)};
}

template<typename F>
std::function<void(std::vector<boost::any> const&)> event::make_dispatcher(F &&f)
{
	using f_type = decltype(&F::operator());
	using args_type = typename function_traits<f_type>::args_type;
	return dispatcher_maker<args_type>{}.make(std::forward<F>(f));
}

template<typename... Args>
std::function<void(std::vector<boost::any> const&)> event::make_dispatcher(void(*f)(Args...))
{
	return dispatcher_maker<std::tuple<Args...>>{}.make(f);
}
	
template<typename F>
void event::listen(std::string user, std::string const &event, F &callback)
{
	m_callbacks.emplace(event, make_dispatcher(std::forward<F>(callback)));
}

template<typename... Args>
void event::fire(std::string user, std::string const &event, Args const&... args)
{
	auto rng = m_callbacks.equal_range(event);
	for (auto it = rng.first; it != rng.second; ++it)
		enqueue(it->second, args...);
}

template<typename F, typename... Args>
void event::enqueue(F const &f, Args const&... args) {
	// Bind arguments and add function to jobs queue. Maybe there is a
	// way to directly bind the parameter pack with using boost::any.
	std::vector<boost::any> v{ args... };
	auto *job = new std::function<void()>(std::bind(f, v));
	while (!m_jobs.push(job));
}

template<typename F> void event::instance::listen(std::string const &event, F &&callback)
{
	m_manager.listen(m_name, event, callback);
}

template<typename... Args> void event::instance::fire(std::string const &event, Args const&... args)
{
	m_manager.fire(m_name, event, args...);
}

} // namespace manager
} // namespace engine
