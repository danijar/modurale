#include "manager.hpp"

#include <chrono>

namespace engine {
namespace manager {
namespace entity {

manager::manager() : m_update(&manager::update, this) {}

manager::~manager()
{
	m_update_running = false;
	m_update.join();
}

void manager::update()
{
	while (m_update_running.load()) {
		for (auto &i : m_properties) {
			auto &p = *i.second.get();
			if (p.m_expired.size()) {
				std::lock_guard<std::recursive_mutex> lock_expired(p.m_expired_mutex);
				std::lock_guard<std::recursive_mutex> lock_values(p.m_values_mutex);
				for (auto entity : p.m_expired)
					p.remove(entity);
				p.m_expired.clear();
			}
		}
		std::this_thread::sleep_for(std::chrono::milliseconds(10));
	}
}

instance &manager::make_instance(std::string user)
{
	if (m_instances.find(user) == m_instances.end())
		m_instances.emplace(user, std::make_unique<instance>(user, *this));
	return *(m_instances[user].get());
}

} // namespace entity
} // namespace manager
} // namespace engine
