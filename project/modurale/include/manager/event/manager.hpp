#pragma once

#include <string>
#include <vector>
#include <map>
#include <unordered_map>
#include <memory>
#include <thread>
#include <atomic>
#include <functional>
#include <utility>
#include <exception>
#include <stdexcept>
#include <mutex>
#include <boost/any.hpp>
#include <boost/lockfree/queue.hpp>
#include "dispatcher.hpp"

namespace engine {
namespace manager {
namespace event {

class instance;

class manager {
public:
	manager();
	~manager();
	instance &make_instance(std::string user);
	template<typename F>
	void listen(std::string user, std::string const &event, F &callback);
	template<typename... Args>
	void fire(std::string user, std::string const &event, Args const&... args);
	void rethrow();

private:
	void update();
	template<typename F, typename... Args>
	void enqueue(F const &f, Args const&... args);

	std::multimap<std::string, dispatcher_type> m_callbacks;
	std::atomic<bool> m_update_running{ true };
	boost::lockfree::queue<std::function<void()>*, boost::lockfree::capacity<16>> m_jobs;
	std::thread m_update;
	std::unordered_map<std::string, std::unique_ptr<instance>> m_instances;
	std::exception_ptr m_last_exception;
	std::mutex m_last_exception_access;
};

} // namespace event
} // namespace manager
} // namespace engine

#include "manager.inl"
#include "instance.hpp"
