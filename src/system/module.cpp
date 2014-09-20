#include "module.hpp"

namespace engine {
namespace system {
using namespace std;

module::module(string name) : name(name), manager(name) {}

void module::set(bool *running)
{
	m_running = running;
}

void module::init() {}

void module::update() {}

void module::exit()
{
	if (!m_running)
		throw runtime_error("Cannot exit system during initialization.");
	manager.log.info() << "Exit the system";
	*m_running = false;
}

} // namespace system
} // namespace engine
