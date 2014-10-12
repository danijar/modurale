#pragma once

#include <vector>
#include <unordered_map>
#include <set>
#include <cinttypes>
#include <typeindex>
#include <memory>
#include <thread>
#include <atomic>
#include <functional>
#include <boost/thread/shared_mutex.hpp>
#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_generators.hpp>
#include <boost/functional/hash.hpp>

namespace engine {
namespace manager {

class entity {
public:
	// Identifyer type for entities
	using id = boost::uuids::uuid;
	using id_hash = boost::hash<boost::uuids::uuid>;

	// Decide whether a template type is an std::function specialization
	template<class T> struct is_std_function : std::false_type {};
	template<class T> struct is_std_function<std::function<T>> : std::true_type{};

	// Collection of all properties of one type
	struct abstract_property {
		virtual void remove(id entity) = 0;
		virtual bool check(id entity) const = 0;

		std::unordered_map<id, size_t, id_hash> m_indices;
		std::unordered_map<size_t, id> m_ids;
		boost::shared_mutex m_values_mutex, m_expired_mutex;
		std::set<id> m_expired;
	};
	template<typename T> struct property : abstract_property{
		void remove(id entity);
		bool check(id entity) const;

		std::vector<T> m_values;
	};

	class instance;

	entity();
	~entity();
	instance &make_instance(std::string user);

	std::unordered_map<std::type_index, std::unique_ptr<abstract_property>> m_properties;
	boost::uuids::random_generator m_generator;

private:
	// Get std::function specialization from general template type
	template<typename T> struct deduce_std_function;
	template<typename R, typename C, typename... T> struct deduce_std_function<R(C::*)(T...)> {
		using type = std::function<R(T...)>;
	};
	template<typename R, typename C, typename... T> struct deduce_std_function<R(C::*)(T...) const> {
		using type = std::function<R(T...)>;
	};

	// Regular updates from asynchronous thread
	void update();

	std::atomic<bool> m_update_running{ true };
	std::thread m_update;
	std::unordered_map<std::string, std::unique_ptr<instance>> m_instances;
};

class entity::instance {
public:
	instance(std::string name, entity &manager);

	// Manage properties
	id create();
	template<typename T> T &add(id entity);
	template<typename T> T &get(id entity) const;
	template<typename T> bool check(id entity) const;
	unsigned int check(id entity) const;
	template<typename T> void remove(id entity);
	void remove(id entity);

	// Iterate over all properties of one type
	template<typename T> typename std::enable_if<!is_std_function<T>::value>::type each(T iterator);
	template<typename T> void each(std::function<void(T)> iterator);
	template<typename T> void each(std::function<void(T, id)> iterator);
	template<typename T> void each(std::function<void(T&)> iterator);
	template<typename T> void each(std::function<void(T&, id)> iterator);

	// Public helpers for underlying vector and locking
	template<typename T> id resolve(size_t index) const;
	template<typename T> size_t size() const;
	template<typename T> boost::shared_mutex &mutex();

private:
	// Templated helper functions for convenience
	template<typename T> property<T> &get_property() const;
	template<typename T> size_t get_index(property<T> &p, id entity) const;

	std::string m_name;
	entity &m_manager;
};

} // namespace manager
} // namespace engine

#include "manager.inl"
