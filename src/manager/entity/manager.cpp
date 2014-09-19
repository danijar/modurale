#include "manager.hpp"

#include <chrono>
extern "C" {
#ifdef _WIN32
#include <Rpc.h>
#else
#include <uuid/uuid.h>
#endif
}

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
	id entity = 0;
#ifdef _WIN32
	UUID uuid;
	UuidCreate(&uuid);
	entity |= uuid.Data1;
	entity <<= 32;
	entity |= uuid.Data2;
	entity <<= 16;
	entity |= uuid.Data2;
#else
	// Untested
	uuid_t uuid;
	uuid_generate_random(uuid);
	for (int i = 0; i < 8; ++i) {
		entity <<= 8;
		entity |= uuid[i];
	}
#endif
	return entity;
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
