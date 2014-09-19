#include "system.hpp"

namespace engine {
namespace system {
using namespace std;

void system::attach(module &module)
{
	for (auto i : m_modules)
		if (i.m_module.name == module.name)
			throw runtime_error("There is already a module with the name.");
	module.set(&m_running);
	m_modules.emplace_back(module);
}

module &system::detach(string name)
{
	for (auto i = m_modules.begin(); i != m_modules.end(); i++) {
		if (i->m_module.name == name) {
			module &module = i->m_module;
			m_modules.erase(i);
			return module;
		}
	}
	throw runtime_error("The module does not exist.");
}

void system::activate(string name)
{
	for (auto i : m_modules) {
		if (i.m_module.name == name) {
			if (i.m_active) {
				throw runtime_error("The module is already active.");
			} else {
				i.m_active = true;
				return;
			}
		}
	}
	throw runtime_error("The module does not exist.");
}

void system::deactivate(string name)
{
	for (auto i : m_modules) {
		if (i.m_module.name == name) {
			if (!i.m_active) {
				throw runtime_error("The module is already inactive.");
			} else {
				i.m_active = false;
				return;
			}
		}
	}
	throw runtime_error("The module does not exist.");

}

bool system::active(string name)
{
	for (auto i : m_modules)
		if (i.m_module.name == name)
			return i.m_active;
	throw runtime_error("The module does not exist.");
}

void system::init()
{
	for (auto i : m_modules)
		if (i.m_active)
			i.m_module.init();
}

void system::update()
{
	for (auto i : m_modules)
		if (i.m_active && m_running)
			i.m_module.update();
}

bool system::running()
{
	return m_running;
}

} // namespace system
} // namespace engine
