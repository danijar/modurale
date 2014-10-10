#pragma once
#include "manager.hpp"

#include <boost/thread/locks.hpp>

namespace engine {
namespace manager {

template<typename T>
T &entity::add(id entity)
{
	// Get type
	auto key = std::type_index(typeid(T));
	if (m_properties.find(key) == m_properties.end())
		m_properties[key] = unique_ptr<abstract_property>(new property<T>);
	auto &p = *((property<T>*)m_properties[key].get());

	// Check if already existing
	if (p.m_indices.find(entity) != p.m_indices.end())
		return get<T>(entity);

	// Emplace element and return pointer
	boost::unique_lock<boost::shared_mutex> lock(p.m_values_mutex);
	size_t index = p.m_values.size();
	p.m_indices[entity] = index;
	p.m_ids[index] = entity;
	p.m_values.emplace_back();
	return p.m_values.back();
}

template<typename T>
T &entity::get(id entity) const
{
	// Return modifiable reference to element
	auto &p = get_property<T>();
	boost::shared_lock<boost::shared_mutex> lock(p.m_values_mutex);
	size_t index = get_index(p, entity);
	return p.m_values[index];
}

template<typename T>
bool entity::check(id entity) const
{
	// Check if property is attached
	auto key = std::type_index(typeid(T));
	auto find = m_properties.find(key);
	if (find == m_properties.end())
		return false;
	return find->second->check();
}

template<typename T>
typename std::enable_if<!entity::is_std_function<T>::value>::type entity::each(T iterator)
{
	// All iterators that aren't already std::function use this overload. They
	// get then converted to an std::function to allow signature distinction.
	typename deduce_std_function<decltype(&T::operator())>::type std_function_iterator = iterator;
	each(std_function_iterator);
}

template<typename T>
void entity::each(std::function<void(T)> iterator)
{
	// Read only iterate over copies of all properties
	auto &p = get_property<T>();
	boost::shared_lock<boost::shared_mutex> lock(p.m_values_mutex);
	for (auto &i : p.m_values)
		iterator(*i);
}

template<typename T>
void entity::each(std::function<void(T, id)> iterator)
{
	// Read only iterate over copies of all properties
	auto &p = get_property<T>();
	boost::shared_lock<boost::shared_mutex> lock(p.m_values_mutex);
	for (size_t i = 0; i < p.m_values.size(); i++)
		iterator(p.m_values[i], p.m_ids[i]);
}

template<typename T>
void entity::each(std::function<void(T&)> iterator)
{
	// Read and write iterate over references of all properties
	auto &p = get_property<T>();
	boost::shared_lock<boost::shared_mutex> lock(p.m_values_mutex);
	for (auto &i : p.m_values)
		iterator(*i);
}

template<typename T>
void entity::each(std::function<void(T&, id)> iterator)
{
	// Read and write iterate over references of all properties
	auto &p = get_property<T>();
	boost::shared_lock<boost::shared_mutex> lock(p.m_values_mutex);
	for (size_t i = 0; i < p.m_values.size(); i++)
		iterator(p.m_values[i], p.m_ids[i]);
}

template<typename T>
size_t entity::size() const
{
	// Return number of properties of one type
	auto key = std::type_index(typeid(T));
	auto find = m_properties.find(key);
	if (find == m_properties.end())
		return 0;
	auto &p = *((property<T>*)find->second.get());
	return p.m_values.size();
}

template<typename T>
entity::id entity::resolve(size_t index) const
{
	// Get id by property type and index
	auto &p = get_property<T>();
	if (index < p.m_values.size())
		return p.m_ids[index];
	return 0;
}

template<typename T>
void entity::property<T>::remove(id entity)
{
	// Check if entity exists
	if (m_indices.find(entity) == m_indices.end())
		throw runtime_error("Entity does not have this property.");
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

template<typename T>
bool entity::property<T>::check(id entity) const
{
	// Check if property has this entity
	return m_indices.find(entity) != m_indices.end();
}

template<typename T>
entity::property<T> &entity::get_property() const
{
	// Get reference to property struct by type
	auto key = std::type_index(typeid(T));
	auto find = m_properties.find(key);
	if (find == m_properties.end())
		throw runtime_error("Property does not exist.");
	return *((property<T>*)find->second.get());
}

template<typename T>
size_t entity::get_index(property<T> &p, id entity) const
{
	if (p.m_indices.find(entity) == p.m_indices.end())
		throw runtime_error("Entity does not have this property.");
	return p.m_indices[entity];
}

} // namespace manager
} // namespace engine
