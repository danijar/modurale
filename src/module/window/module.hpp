#pragma once

#include "../../system/module.hpp"

namespace engine {
namespace module {

class window : public engine::system::module {
public:
	window(std::string name);
	void init();
	void update();

private:
	typedef manager::entity::id id;

	void listeners();
	void open(id entity);
	void close(id entity);
};

} // namespace module
} // namespace engine
