#include "manager.hpp"

namespace engine {
namespace manager {
using namespace std;

event::instance &event::make_instance(string user)
{
	if (m_instances.find(user) == m_instances.end())
		m_instances.emplace(user, make_unique<instance>(user, *this));
	return *(m_instances[user].get());
}

event::instance::instance(string name, event &manager) : m_name(name), m_manager(manager) {}

} // namespace manager
} // namespace engine
