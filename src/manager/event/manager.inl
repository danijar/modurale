#pragma once
#include "manager.hpp"

namespace engine {
namespace manager {
namespace event_detail {
using namespace std;
using boost::any;
using boost::any_cast;

template <typename... Args>
template <typename F>
dispatcher<Args...>::dispatcher(F f) : _f(move(f)) {}

template <typename... Args>
void dispatcher<Args...>::operator() (vector<any> const& v) {
	if (v.size() < sizeof...(Args))
		throw runtime_error("Callback has wrong arity.");
	return do_call(v, make_integer_sequence<int, sizeof...(Args)>());
}

template <typename... Args>
template <int... Is>
void dispatcher<Args...>::do_call(vector<any> const& v, integer_sequence<int, Is...>) {
	try {
		return _f((get_ith<Args>(v, Is))...);
	} catch (boost::bad_any_cast const&) {
		throw runtime_error("Callback has wrong signature.");
	}
}

template <typename... Args>
template <typename T>
T dispatcher<Args...>::get_ith(vector<any> const& v, int i) {
	return any_cast<T>(v[i]);
}

template <typename... Args>
template <typename F>
dispatcher_type dispatcher_maker<tuple<Args...>>::make(F&& f) {
	return dispatcher<Args...>{forward<F>(f)};
}

template <typename F>
function<void(vector<any> const&)> make_dispatcher(F&& f) {
	using f_type = decltype(&F::operator());
	using args_type = typename function_traits<f_type>::args_type;
	return dispatcher_maker<args_type>{}.make(forward<F>(f));
}

template <typename... Args>
function<void(vector<any> const&)> make_dispatcher(void(*f)(Args...)) {
	return dispatcher_maker<tuple<Args...>>{}.make(f);
}
	
template <typename F>
void manager::listen(string const& event, F&& f) {
	m_callbacks.emplace(event, make_dispatcher(forward<F>(f)));
}

template <typename... Args>
void manager::fire(string const& event, Args const&... args) {
	auto rng = m_callbacks.equal_range(event);
	for (auto it = rng.first; it != rng.second; ++it)
		call(it->second, args...);
}

template <typename F, typename... Args>
void manager::call(F const& f, Args const&... args) {
	vector<any> v{args...};
	f(v);
}

} // namespace event_detail
} // namespace manager
} // namespace engine
