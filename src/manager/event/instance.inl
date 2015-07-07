#pragma once

#include "instance.hpp"

namespace engine {
namespace manager {
namespace event {

template<typename F> void instance::listen(std::string const &event, F &&callback)
{
    m_manager.listen(m_name, event, callback);
}

template<typename... Args> void instance::fire(std::string const &event, Args const&... args)
{
    m_manager.fire(m_name, event, args...);
}

} // namespace event
} // namespace manager
} // namespace engine
