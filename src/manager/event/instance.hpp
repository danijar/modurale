#pragma once

#include <string>
#include "manager.hpp"

namespace engine {
namespace manager {
namespace event {

class instance {
public:
    instance(std::string name, event::manager &manager);
    template<typename F> void listen(std::string const &event, F &&callback);
    template<typename... Args> void fire(std::string const &event, Args const&... args);
    void rethrow();

private:
    std::string m_name;
    manager &m_manager;
};

} // namespace event
} // namespace manager
} // namespace engine

#include "instance.inl"
