#include "manager.hpp"

namespace engine {
namespace manager {
namespace event {

manager::manager() : m_update(&manager::update, this) {}

manager::~manager()
{
	m_update_running = false;
	m_update.join();
}

instance &manager::make_instance(std::string user)
{
	if (m_instances.find(user) == m_instances.end())
		m_instances.emplace(user, std::make_unique<instance>(user, *this));
	return *(m_instances[user].get());
}

void manager::rethrow()
{
	// Fetch last exeception and reset member
	m_last_exception_access.lock();
	std::exception_ptr last_exception = m_last_exception;
	m_last_exception = nullptr;
	m_last_exception_access.unlock();

	// Rethrow if there is an exception
	if (last_exception)
		std::rethrow_exception(last_exception);
}

void manager::update()
{
	while (m_update_running.load()) {
		std::function<void()> *job;
		if (m_jobs.pop(job)) {
			try {
				(*job)();
			} catch (...) {
				// Store exceptions for rethrowing from other ouside the worker
				// thread
				m_last_exception_access.lock();
				m_last_exception = std::current_exception();
				m_last_exception_access.unlock();
			}
			delete job;
		}
	}
}

} // namespace event
} // namespace manager
} // namespace engine
