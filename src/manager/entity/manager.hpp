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
	using id = boost::uuids::uuid;
	using id_hash = boost::hash<boost::uuids::uuid>;

	entity();
	~entity();
	id create();
	template <typename T> T&add(id entity);
	template <typename T> T &get(id entity) const;
	template <typename T> bool check(id entity) const;
	unsigned int check(id entity) const;
	// Template whole iterator, not just parameter type because they can't automatically get deducted.
	// template <typename T> void each(std::function<void(T)> iterator);
	// template <typename T> void each(std::function<void(T, id)> iterator);
	// template <typename T> void each(std::function<void(T&)> iterator);
	template <typename T> void each(std::function<void(T&, id)> iterator);
	template <typename T> void remove(id entity);
	void remove(id entity);
	template <typename T> id resolve(size_t index) const;
	template <typename T> size_t size() const;

private:
	struct abstract_property {
		virtual void remove(id entity) = 0;
		virtual bool check(id entity) const = 0;

		std::unordered_map<id, size_t, id_hash> m_indices;
		std::unordered_map<size_t, id> m_ids;
		boost::shared_mutex m_values_mutex, m_expired_mutex;
		std::set<id> m_expired;
	};
	template <typename T> struct property : abstract_property {
		void remove(id entity);
		bool check(id entity) const;

		std::vector<T> m_values;
	};

	template <typename T> property<T> &get_property() const;
	template <typename T> size_t get_index(property<T> &p, id entity) const;
	void update();

	boost::uuids::random_generator m_generator;
	std::unordered_map<std::type_index, std::unique_ptr<abstract_property>> m_properties;
	std::atomic<bool> m_update_running{ true };
	std::thread m_update;
};

} // namespace manager
} // namespace engine

#include "manager.inl"
