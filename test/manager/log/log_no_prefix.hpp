#pragma once

#include "../src/manager/log/manager.hpp"

class log_no_prefix : public engine::manager::log::manager {
public:
    log_no_prefix(std::ostream &out) :
        engine::manager::log::manager::manager(out) {}
protected:
    std::string prefix(std::string name, std::string log_level)
    {
        return "";
    }
};
