#pragma once

#include "property.hpp"

namespace engine {
namespace manager {
namespace entity {

template<typename T>
bool entity::property<T>::check(id entity) const
{
    // Check if property has this entity
    return m_indices.find(entity) != m_indices.end();
}

template<typename T>
void entity::property<T>::remove(id entity)
{
    // Check if entity exists
    if (m_indices.find(entity) == m_indices.end())
        throw std::runtime_error("Entity does not have this property.");
    size_t index = m_indices[entity];

    // Copy last element over
    id last = m_ids[m_values.size() - 1];
    m_indices[last] = index;
    m_ids[index] = last;
    m_values[index] = m_values.back();

    // Remove free space and reference
    m_values.pop_back();
    m_indices.erase(entity);
}

} // namespace entity
} // namespace manager
} // namespace engine
