#include "manager/event/instance.hpp"

namespace engine {
namespace manager {
namespace event {

instance::instance(std::string name, event::manager &manager) : m_name(name),
    m_manager(manager) {}

void instance::rethrow()
{
    m_manager.rethrow();
}

} // namespace event
} // namespace manager
} // namespace engine
