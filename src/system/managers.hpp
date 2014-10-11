#pragma once

#include <string>
#include "../manager/log/manager.hpp"
#include "../manager/entity/manager.hpp"
#include "../manager/event/manager.hpp"

namespace engine {
namespace system {

struct managers {
	struct instances;

	manager::log    m_log;
	manager::entity m_entity;
	manager::event  m_event;
};

struct managers::instances {
	instances(std::string name, managers &managers);

	manager::log::instance    &log;
	manager::entity::instance &entity;
	manager::event::instance  &event;
};

} // namespace system
} // namespace engine
