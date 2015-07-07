#pragma once

#include <string>
#include "../manager/log/manager.hpp"
#include "../manager/entity/manager.hpp"
#include "../manager/event/manager.hpp"

namespace engine {
namespace system {

struct managers {
	manager::log::manager    m_log;
	manager::entity::manager m_entity;
	manager::event::manager  m_event;
};

struct manager_instances {
	manager_instances(std::string name, managers &managers);

	manager::log::instance    &log;
	manager::entity::instance &entity;
	manager::event::instance  &event;
};

} // namespace system
} // namespace engine
