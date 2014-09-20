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
	bool active(std::string name) const;
	void init();
	void update();
	bool running() const;

private:
	struct entry {
		entry(module &module) : m_module(module) {}
		bool operator=(const entry &rhs) const;
		module &m_module;
		bool m_active = true;
	};

	std::vector<entry> m_modules;
	bool m_running = true;
};

} // namespace system
} // namespace engine
