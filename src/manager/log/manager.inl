#pragma once
#include "manager.hpp"

namespace engine {
namespace manager {
using namespace std;

template<typename T>
log::stream &log::stream::operator<<(const T &v)
{
	if (!m_touched) {
		m_touched = true;
		m_mutex.lock();
		m_out << m_name << ": ";
		m_out << v;
	} else {
		m_out << m_sep << v;
	}
	return *this;
}

} // namespace manager
} // namespace engine
