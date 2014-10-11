#include "manager.hpp"

#include <chrono>

namespace engine {
namespace manager {
using namespace std;
using namespace std::chrono;

entity::entity() : m_update(&entity::update, this) {}

entity::~entity()
{
	m_update_running = false;
	m_update.join();
}

entity::id entity::instance::create()
{
	return m_manager.m_generator();
}

unsigned int entity::instance::check(id entity) const
{
	// Counter number of attached properties
	unsigned int counter = 0;
	for (auto &i : m_manager.m_properties)
		if (i.second->check(entity))
			counter++;
	return counter;
}

void entity::instance::remove(id entity)
{
	for (auto &i : m_manager.m_properties) {
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
		this_thread::sleep_for(milliseconds(10));
	}
}

entity::instance &entity::make_instance(string user)
{
	if (m_instances.find(user) == m_instances.end())
		m_instances.emplace(user, make_unique<instance>(user, *this));
	return *(m_instances[user].get());
}

entity::instance::instance(string name, entity &manager) : m_name(name), m_manager(manager) {}

} // namespace manager
} // namespace engine
