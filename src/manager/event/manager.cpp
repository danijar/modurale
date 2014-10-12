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

void event::update()
{
	while (m_update_running.load()) {
		function<void()> *job;
		if (m_jobs.pop(job)) {
			(*job)();
			delete job;
		}
	}
}

event::instance::instance(string name, event &manager) : m_name(name), m_manager(manager) {}

} // namespace manager
} // namespace engine
