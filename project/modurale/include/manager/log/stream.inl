#pragma once

#include "stream.hpp"

namespace engine {
namespace manager {
namespace log {

template<typename T>
stream &stream::operator<<(const T &content)
{
    if (m_first)
        m_first = false;
    else
        m_content << m_sep;
    m_content << content;
	return *this;
}

} // namespace log
} // namespace manager
} // namespace engine
