#include "instance.hpp"

namespace engine {
namespace manager {
namespace entity {

instance::instance(std::string name, entity::manager &manager) : m_name(name),
    m_manager(manager) {}

id instance::create()
{
    return m_manager.m_generator();
}

unsigned int instance::check(id entity) const
{
    // Counter number of attached properties
    unsigned int counter = 0;
    for (auto &i : m_manager.m_properties)
        if (i.second->check(entity))
            counter++;
    return counter;
}

void instance::remove(id entity)
{
    for (auto &i : m_manager.m_properties) {
        if (i.second->check(entity)) {
            auto &p = *i.second.get();
            std::lock_guard<std::recursive_mutex> lock(p.m_expired_mutex);
            p.m_expired.insert(entity);
        }
    }
}

} // namespace entity
} // namespace manager
} // namespace engine
