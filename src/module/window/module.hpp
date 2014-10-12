#pragma once

#include "../../system/module.hpp"
#include "../../type/window/type.hpp"

namespace engine {
namespace module {

class window : public system::module {
public:
	window(std::string name, system::managers &managers);
	void update();

private:
	using id = manager::entity::id;

	void listeners();
	void apply(type::window &window);
	void remove(id entity);
};

} // namespace module
} // namespace engine
