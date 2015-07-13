#include "manager/log/stream.hpp"

namespace engine {
namespace manager {
namespace log {

stream::stream(std::ostream &out, boost::mutex &mutex, std::string begin,
    std::string sep, std::string end) : m_out(out), m_mutex(mutex), m_sep(sep),
    m_end(end)
{
    m_content << begin;
}

stream::stream(stream &&other) : m_out(other.m_out), m_mutex(other.m_mutex),
    m_sep(other.m_sep), m_end(other.m_end), m_first(other.m_first),
    m_content(std::move(other.m_content))
{
    // Prevent old stream instance from printing
    other.m_forwarded = true;
}

stream::~stream()
{
    if (m_forwarded)
        return;
    m_content << m_end;
    m_mutex.lock();
    m_out << m_content.str();
    m_out.flush(); // TODO: Needed?
    m_mutex.unlock();
}

} // namespace log
} // namespace manager
} // namespace engine
