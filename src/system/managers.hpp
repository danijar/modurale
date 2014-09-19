#pragma once

#include <string>
#include "../manager/log/manager.hpp"
#include "../manager/entity/manager.hpp"
#include "../manager/event/manager.hpp"
// ...

namespace engine {
namespace system {

class managers {
public:
	managers(std::string name);

	manager::log log;
	manager::entity entity;
	manager::event event;
	// ...
};

} // namespace system
} // namespace engine
