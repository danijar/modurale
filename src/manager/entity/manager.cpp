#include "manager.hpp"

#include <chrono>

namespace engine {
namespace manager {

entity::entity() : m_update(&entity::update, this) {}

entity::~entity()
{
	m_update_running = false;
	m_update.join();
}

entity::id entity::create()
{
	return m_generator();
}

unsigned int entity::check(id entity)
{
	// Counter number of attached properties
	unsigned int counter = 0;
	for (auto &i : m_properties)
		if (i.second->check(entity))
			counter++;
	return counter;
}

void entity::remove(id entity)
{
	for (auto &i : m_properties) {
		if (i.second->check(entity)) {
			auto &p = *i.second.get();
			boost::unique_lock<boost::shared_mutex> lock(p.m_expired_mutex);
			p.m_expired.insert(entity);
		}
	}
}

void entity::update()
{
	while (m_update_running.load()) {
		for (auto &i : m_properties) {
			auto &p = *i.second.get();
			if (p.m_expired.size()) {
				boost::unique_lock<boost::shared_mutex> lock_expired(p.m_expired_mutex);
				boost::unique_lock<boost::shared_mutex> lock_values(p.m_values_mutex);
				for (auto entity : p.m_expired)
					p.remove(entity);
				p.m_expired.clear();
			}
		}
		std::this_thread::sleep_for(std::chrono::milliseconds(10));
	}
}

} // namespace manager
} // namespace engine
