#pragma once

#include "manager.hpp"

namespace engine {
namespace manager {
namespace event {

template<typename F>
void manager::listen(std::string user, std::string const &event, F &callback)
{
	m_callbacks.emplace(event, make_dispatcher(std::forward<F>(callback)));
}

template<typename... Args>
void manager::fire(std::string user, std::string const &event, Args const&... args)
{
	auto rng = m_callbacks.equal_range(event);
	for (auto it = rng.first; it != rng.second; ++it)
		enqueue(it->second, args...);
}

template<typename F, typename... Args>
void manager::enqueue(F const &f, Args const&... args) {
	// Bind arguments and add function to jobs queue. Maybe there is a
	// way to directly bind the parameter pack with using boost::any.
	std::vector<boost::any> v{ args... };
	auto *job = new std::function<void()>(std::bind(f, v));
	while (!m_jobs.push(job));
}

} // namespace event
} // namespace manager
} // namespace engine
