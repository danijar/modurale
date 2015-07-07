#pragma once

#include <vector>
#include <unordered_map>
#include <mutex>
#include "id.hpp"

namespace engine {
namespace manager {
namespace entity {

// Collection of all properties of one type
struct abstract_property {
    virtual void remove(id entity) = 0;
    virtual bool check(id entity) const = 0;

    std::unordered_map<id, size_t, id_hash> m_indices;
    std::unordered_map<size_t, id> m_ids;
    std::recursive_mutex m_values_mutex, m_expired_mutex;
    std::set<id> m_expired;
};

template<typename T>
struct property : abstract_property {
    void remove(id entity);
    bool check(id entity) const;

    std::vector<T> m_values;
};

} // namespace entity
} // namespace manager
} // namespace engine

#include "property.inl"
