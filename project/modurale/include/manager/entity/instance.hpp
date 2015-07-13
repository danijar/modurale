#pragma once

#include "manager.hpp"
#include "std_function.hpp"

namespace engine {
namespace manager {
namespace entity {

class instance {
public:
    instance(std::string name, entity::manager &manager);

    // Manage properties
    id create();
    template<typename T>
    T &add(id entity);
    template<typename T>
    T &get(id entity) const;
    template<typename T>
    bool check(id entity) const;
    unsigned int check(id entity) const;
    template<typename T>
    void remove(id entity);
    void remove(id entity);

    // Iterate over all properties of one type
    template<typename T> typename
    std::enable_if<!is_std_function<T>::value>::type each(T iterator);
    template<typename T>
    void each(std::function<void(T)> iterator);
    template<typename T>
    void each(std::function<void(T, id)> iterator);
    template<typename T>
    void each(std::function<void(T&)> iterator);
    template<typename T>
    void each(std::function<void(T&, id)> iterator);

    // Public helpers for underlying vector and locking
    template<typename T>
    id resolve(size_t index) const;
    template<typename T>
    size_t size() const;
    template<typename T>
    std::recursive_mutex &mutex();

private:
    // Templated helper functions for convenience
    template<typename T>
    property<T> &get_property() const;
    template<typename T>
    size_t get_index(property<T> &p, id entity) const;

    std::string m_name;
    manager &m_manager;
};

} // namespace entity
} // namespace manager
} // namespace engine

#include "instance.inl"
