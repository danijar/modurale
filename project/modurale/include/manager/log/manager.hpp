#pragma once

#include <string>
#include <unordered_map>
#include <string>
#include <memory>
#include <iostream>
#include <functional>
#include <boost/thread/mutex.hpp>
#include "stream.hpp"

namespace engine {
namespace manager {
namespace log {

class instance;

// Parameters are instance name and log level and it returns the prefix
using prefix_callback = std::function<std::string(std::string, std::string)>;

class manager {
public:
    manager(std::ostream &out = std::cout);
    instance &make_instance(std::string user);
    stream info   (std::string name, std::string sep, std::string end);
    stream warning(std::string name, std::string sep, std::string end);
    stream error  (std::string name, std::string sep, std::string end);
    stream debug  (std::string name, std::string sep, std::string end);

protected:
    // Changing the prefix is mainly useful in tests
    virtual std::string prefix(std::string name, std::string log_level);

private:
    std::ostream &m_out;
    boost::mutex m_mutex;
    std::unordered_map<std::string, std::unique_ptr<instance>> m_instances;
};

} // namespace log
} // namespace manager
} // namespace engine

#include "instance.hpp"
