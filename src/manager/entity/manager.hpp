#pragma once

#include <unordered_map>
#include <set>
#include <cinttypes>
#include <typeindex>
#include <memory>
#include <thread>
#include <mutex>
#include <atomic>
#include <boost/uuid/uuid_generators.hpp>
#include "id.hpp"
#include "property.hpp"

namespace engine {
namespace manager {
namespace entity {

class instance;

class manager {
public:
	manager();
	~manager();
	instance &make_instance(std::string user);

	std::unordered_map<std::type_index, std::unique_ptr<abstract_property>> m_properties;
	boost::uuids::random_generator m_generator;

private:
	void update();

	std::atomic<bool> m_update_running{ true };
	std::thread m_update;
	std::unordered_map<std::string, std::unique_ptr<instance>> m_instances;
};

} // namespace entity
} // namespace manager
} // namespace engine

#include "instance.hpp"
