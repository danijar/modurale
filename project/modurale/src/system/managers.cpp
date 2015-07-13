#include "system/managers.hpp"

namespace engine {
namespace system {

manager_instances::manager_instances(std::string name, managers &managers) :
	// Get individual instances
	log(managers.m_log.make_instance(name)),
	entity(managers.m_entity.make_instance(name)),
	event(managers.m_event.make_instance(name)) {}

} // namespace system
} // namespace engine
