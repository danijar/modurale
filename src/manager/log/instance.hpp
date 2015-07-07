#pragma once

#include "manager.hpp"
#include "stream.hpp"

namespace engine {
namespace manager {
namespace log {

class instance {
public:
    instance(std::string name, log::manager &manager);
    stream info   (std::string sep = " ", std::string end = ".\n");
    stream warning(std::string sep = " ", std::string end = ".\n");
    stream error  (std::string sep = " ", std::string end = ".\n");
    stream debug  (std::string sep = " ", std::string end = ".\n");

private:
    std::string m_name;
    manager &m_manager;
};

} // namespace log
} // namespace manager
} // namespace engine
