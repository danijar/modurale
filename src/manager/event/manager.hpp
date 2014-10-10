#pragma once

#include <string>
#include <vector>
#include <map>
#include <tuple>
#include <functional>
#include <utility>
#include <boost/any.hpp>
#include "integer_sequence.hpp"

namespace engine {
namespace manager {

class event {
public:
	template<typename F> void listen(std::string const &event, F&& f);
	template<typename... Args> void fire(std::string const &event, Args const&... args);

private:
	template<typename... Args> class dispatcher {
	public:
		template<typename F> dispatcher(F f);
		void operator() (std::vector<boost::any> const &v);

	private:
		template<int... Is> void do_call(std::vector<boost::any> const &v, std::integer_sequence<int, Is...>);
		template<typename T> T get_ith(std::vector<boost::any> const &v, int i);

		std::function<void(Args...)> m_function;
	};
	typedef std::function<void(std::vector<boost::any> const&)> dispatcher_type;
	template<typename T> struct function_traits;
	template<typename R, typename C, typename... Args> struct function_traits<R(C::*)(Args...)> {
		using args_type = std::tuple<Args...>;
	};
	template<typename R, typename C, typename... Args> struct function_traits<R(C::*)(Args...) const> {
		using args_type = std::tuple<Args...>;
	};
	template<typename T> struct dispatcher_maker;
	template<typename... Args> struct dispatcher_maker<std::tuple<Args...>> {
		template<typename F> dispatcher_type make(F&& f);
	};

	template<typename F> std::function<void(std::vector<boost::any> const&)> make_dispatcher(F&& f);
	template<typename... Args> std::function<void(std::vector<boost::any> const&)> make_dispatcher(void(*f)(Args...));
	template<typename F, typename... Args> void call(F const &f, Args const&... args);

	std::multimap<std::string, dispatcher_type> m_callbacks;
};

} // namespace manager
} // namespace engine

#include "manager.inl"
