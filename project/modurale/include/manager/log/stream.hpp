#pragma once

#include <string>
#include <iostream>
#include <sstream>
#include <memory>
#include <boost/thread/mutex.hpp> // TODO: Try to use std threads2

namespace engine {
namespace manager {
namespace log {

struct stream {
    stream(std::ostream &out, boost::mutex &mutex, std::string begin,
        std::string sep, std::string end);
    stream(stream&) = delete;
    stream(stream&& other);
    ~stream();
    template<typename T>
    stream &operator<<(const T &content);

    // After being forwarded, the old stream should print on destruction
    bool m_forwarded = false;

private:
    std::ostream &m_out;
    boost::mutex &m_mutex;
    std::string m_sep, m_end;
    std::ostringstream m_content;
    bool m_first = true;
};

} // namespace log
} // namespace manager
} // namespace engine

#include "stream.inl"
