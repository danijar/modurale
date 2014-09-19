#pragma once

#include <string>
#include <vector>
#include "module.hpp"

namespace engine {
namespace system {

class system {
public:
	void attach(module &module);
	module &detach(std::string name);
	void activate(std::string name);
	void deactivate(std::string name);
	bool active(std::string name);
	void init();
	void update();
	bool running();

private:
	struct entry {
		entry(module &module) : m_module(module) {}
		bool operator=(const entry &rhs) { return m_module.name == rhs.m_module.name; }
		module &m_module;
		bool m_active = true;
	};

	std::vector<entry> m_modules;
	bool m_running = true;
};

} // namespace system
} // namespace engine
