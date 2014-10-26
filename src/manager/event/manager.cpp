#include "manager.hpp"

namespace engine {
namespace manager {
using namespace std;

event::event() : m_update(&event::update, this) {}

event::~event()
{
	m_update_running = false;
	m_update.join();
}

event::instance &event::make_instance(string user)
{
	if (m_instances.find(user) == m_instances.end())
		m_instances.emplace(user, make_unique<instance>(user, *this));
	return *(m_instances[user].get());
}

void event::rethrow()
{
	// Fetch last exeception and reset member
	m_last_exception_access.lock();
	exception_ptr last_exception = m_last_exception;
	m_last_exception = nullptr;
	m_last_exception_access.unlock();

	// Rethrow if there is an exception
	if (last_exception)
		rethrow_exception(last_exception);
}

void event::update()
{
	while (m_update_running.load()) {
		function<void()> *job;
		if (m_jobs.pop(job)) {
			try {
				(*job)();
			} catch (...) {
				// Store exceptions for rethrowing from other ouside the worker thread
				m_last_exception_access.lock();
				m_last_exception = current_exception();
				m_last_exception_access.unlock();
			}
			delete job;
		}
	}
}

event::instance::instance(string name, event &manager) : m_name(name), m_manager(manager) {}

void event::instance::rethrow()
{
	m_manager.rethrow();
}

} // namespace manager
} // namespace engine
