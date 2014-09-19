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

namespace engine {
namespace manager {

class entity {
public:
	typedef uint64_t id;

	entity();
	~entity();
	id create();
	template <typename T> T&add(id entity);
	template <typename T> T &get(id entity);
	template <typename T> bool check(id entity);
	unsigned int check(id entity);
	// Template whole iterator, not just parameter type because they can't automatically get deducted.
	// template <typename T> void each(std::function<void(T)> iterator);
	// template <typename T> void each(std::function<void(T, id)> iterator);
	// template <typename T> void each(std::function<void(T&)> iterator);
	template <typename T> void each(std::function<void(T&, id)> iterator);
	template <typename T> void remove(id entity);
	void remove(id entity);
	template <typename T> id resolve(size_t index);
	template <typename T> size_t size();

private:
	struct abstract_property {
		virtual void remove(id entity) = 0;
		virtual bool check(id entity) = 0;

		std::unordered_map<id, size_t> m_indices;
		std::unordered_map<size_t, id> m_ids;
		boost::shared_mutex m_values_mutex, m_expired_mutex;
		std::set<id> m_expired;
	};
	template <typename T> struct property : abstract_property {
		void remove(id entity);
		bool check(id entity);

		std::vector<T> m_values;
	};

	template <typename T> property<T> &get_property();
	template <typename T> size_t get_index(property<T> &p, id entity);
	void update();

	std::unordered_map<std::type_index, std::unique_ptr<abstract_property>> m_properties;
	std::atomic<bool> m_update_running{ true };
	std::thread m_update;
};

} // namespace manager
} // namespace engine

#include "manager.inl"
