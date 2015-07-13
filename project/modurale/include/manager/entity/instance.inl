#pragma once

#include "instance.hpp"
#include <stdexcept>
#include <boost/thread/locks.hpp>

namespace engine {
namespace manager {
namespace entity {

template<typename T>
T &instance::add(id entity)
{
    // Get type
    auto key = std::type_index(typeid(T));
    if (m_manager.m_properties.find(key) == m_manager.m_properties.end())
        m_manager.m_properties[key] = std::unique_ptr<abstract_property>(new property<T>);
    auto &p = *((property<T>*)m_manager.m_properties[key].get());

    // Check if already existing
    if (p.m_indices.find(entity) != p.m_indices.end())
        return get<T>(entity);

    // Emplace element and return pointer
    std::lock_guard<std::recursive_mutex> lock(p.m_values_mutex);
    size_t index = p.m_values.size();
    p.m_indices[entity] = index;
    p.m_ids[index] = entity;
    p.m_values.emplace_back();
    return p.m_values.back();
}

template<typename T>
T &instance::get(id entity) const
{
    // Return modifiable reference to element
    auto &p = get_property<T>();
    std::lock_guard<std::recursive_mutex> lock(p.m_values_mutex);
    size_t index = get_index(p, entity);
    return p.m_values[index];
}

template<typename T>
bool instance::check(id entity) const
{
    // Check if property is attached
    auto key = std::type_index(typeid(T));
    auto find = m_manager.m_properties.find(key);
    if (find == m_manager.m_properties.end())
        return false;
    return find->second->check(entity);
}

template<typename T>
typename std::enable_if<!is_std_function<T>::value>::type instance::each(T iterator)
{
    // All iterators that aren't already std::function use this overload. They
    // get then converted to an std::function to allow signature distinction.
    typename deduce_std_function<decltype(&T::operator())>::type std_function_iterator = iterator;
    each(std_function_iterator);
}

template<typename T>
void instance::each(std::function<void(T)> iterator)
{
    // Read only iterate over copies of all properties
    auto &p = get_property<T>();
    std::lock_guard<std::recursive_mutex> lock(p.m_values_mutex);
    for (auto &i : p.m_values)
        iterator(*i);
}

template<typename T>
void instance::each(std::function<void(T, id)> iterator)
{
    // Read only iterate over copies of all properties
    auto &p = get_property<T>();
    std::lock_guard<std::recursive_mutex> lock(p.m_values_mutex);
    for (size_t i = 0; i < p.m_values.size(); i++)
        iterator(p.m_values[i], p.m_ids[i]);
}

template<typename T>
void instance::each(std::function<void(T&)> iterator)
{
    // Read and write iterate over references of all properties
    auto &p = get_property<T>();
    std::lock_guard<std::recursive_mutex> lock(p.m_values_mutex);
    for (auto &i : p.m_values)
        iterator(*i);
}

template<typename T>
void instance::each(std::function<void(T&, id)> iterator)
{
    // Read and write iterate over references of all properties
    auto &p = get_property<T>();
    std::lock_guard<std::recursive_mutex> lock(p.m_values_mutex);
    for (size_t i = 0; i < p.m_values.size(); i++)
        iterator(p.m_values[i], p.m_ids[i]);
}

template<typename T>
size_t instance::size() const
{
    // Return number of properties of one type
    auto key = std::type_index(typeid(T));
    auto find = m_manager.m_properties.find(key);
    if (find == m_manager.m_properties.end())
        return 0;
    auto &p = *((property<T>*)find->second.get());
    return p.m_values.size();
}

template<typename T>
std::recursive_mutex &instance::mutex()
{
    auto &p = get_property<T>();
    return p.m_values_mutex;
}

template<typename T>
id instance::resolve(size_t index) const
{
    // Get id by property type and index
    auto &p = get_property<T>();
    if (index < p.m_values.size())
        return p.m_ids[index];
    return 0;
}

template<typename T>
entity::property<T> &instance::get_property() const
{
    // Get reference to property struct by type
    auto key = std::type_index(typeid(T));
    auto find = m_manager.m_properties.find(key);
    if (find == m_manager.m_properties.end())
        throw std::runtime_error("Property does not exist.");
    return *((property<T>*)find->second.get());
}

template<typename T>
size_t instance::get_index(property<T> &p, id entity) const
{
    if (p.m_indices.find(entity) == p.m_indices.end())
        throw std::runtime_error("Entity does not have this property.");
    return p.m_indices[entity];
}

} // namespace entity
} // namespace manager
} // namespace engine
