#pragma once

#include "../../system/module.hpp"

namespace engine {
namespace module {

class window : public engine::system::module {
public:
	window(std::string name);
	void update();

private:
	using id = manager::entity::id;

	void listeners();
	void open(id entity);
	void close(id entity);
};

} // namespace module
} // namespace engine
