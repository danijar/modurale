#pragma once

#include <string>

namespace engine {
namespace manager {

class log {
public:
	void print(const std::string message);
	void debug(const std::string message);
};

} // namespace manager
} // namespace engine
