#include "manager/log/manager.hpp"

#include <iostream>

namespace engine {
namespace manager {
namespace log {

manager::manager(std::ostream &out) : m_out(out) {}

instance &manager::make_instance(std::string user)
{
	if (m_instances.find(user) == m_instances.end())
		m_instances.emplace(user, std::make_unique<instance>(user, *this));
	return *(m_instances[user].get());
}

stream manager::info(std::string name, std::string sep, std::string end)
{
	return stream(m_out, m_mutex, prefix(name, "info"), sep, end);
}

stream manager::warning(std::string name, std::string sep, std::string end)
{
	return stream(m_out, m_mutex, prefix(name, "warning"), sep, end);
}

stream manager::error(std::string name, std::string sep, std::string end)
{
	return stream(m_out, m_mutex, prefix(name, "error"), sep, end);
}

stream manager::debug(std::string name, std::string sep, std::string end)
{
	return stream(m_out, m_mutex, prefix(name, "debug"), sep, end);
}

std::string manager::prefix(std::string name, std::string log_level)
{
    return name + " (" + log_level + "): ";
}

} // namespace log
} // namespace manager
} // namespace engine
