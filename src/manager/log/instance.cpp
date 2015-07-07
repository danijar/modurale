#include "instance.hpp"

namespace engine {
namespace manager {
namespace log {

instance::instance(std::string name, log::manager &manager) : m_name(name),
    m_manager(manager) {}

stream instance::info(std::string sep, std::string end)
{
    return m_manager.info(m_name, sep, end);
}

stream instance::warning(std::string sep, std::string end)
{
    return m_manager.warning(m_name, sep, end);
}

stream instance::error(std::string sep, std::string end)
{
    return m_manager.error(m_name, sep, end);
}

stream instance::debug(std::string sep, std::string end)
{
    return m_manager.debug(m_name, sep, end);
}

} // namespace log
} // namespace manager
} // namespace engine
