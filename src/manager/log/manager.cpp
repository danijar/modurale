#include "manager.hpp"

#include <iostream>

namespace engine {
namespace manager {
using namespace std;

log::stream::stream(ostream &out, boost::mutex &mutex, string name, string sep, string end) : m_out(out), m_mutex(mutex), m_name(name), m_sep(sep), m_end(end) {}

log::stream::~stream()
{
	if (m_touched) {
		m_out << m_end;
		m_out.flush();
		m_mutex.unlock();
	}
}

log::instance &log::make_instance(string user)
{
	if (m_instances.find(user) == m_instances.end())
		m_instances.emplace(user, make_unique<instance>(user, *this));
	return *(m_instances[user].get());
}

log::stream log::info(std::string name, string sep, string end)
{
	return stream(m_out, m_mutex, name, sep, end);
}

log::stream log::warning(std::string name, string sep, string end)
{
	return stream(m_out, m_mutex, name, sep, end);
}

log::stream log::error(std::string name, string sep, string end)
{
	return stream(m_out, m_mutex, name, sep, end);
}

log::stream log::debug(std::string name, string sep, string end)
{
	return stream(m_out, m_mutex, name, sep, end);
}

log::instance::instance(string name, log &manager) : m_name(name), m_manager(manager) {}

log::stream log::instance::info(string sep, string end)
{
	return m_manager.info(m_name, sep, end);
}

log::stream log::instance::warning(string sep, string end)
{
	return m_manager.warning(m_name, sep, end);
}

log::stream log::instance::error(string sep, string end)
{
	return m_manager.error(m_name, sep, end);
}

log::stream log::instance::debug(string sep, string end)
{
	return m_manager.debug(m_name, sep, end);
}

} // namespace manager
} // namespace engine
