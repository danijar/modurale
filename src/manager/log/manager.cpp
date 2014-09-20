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

log::stream log::info(string sep, string end)
{
	return stream(m_out, m_mutex, "Name", sep, end);
}

log::stream log::debug(string sep, string end)
{
	return stream(m_out, m_mutex, "Name", sep, end);
}

} // namespace manager
} // namespace engine
