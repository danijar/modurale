#pragma once

#include <string>
#include "managers.hpp"

namespace engine {
namespace system {

class module {
public:
	module(std::string name);
	void set(bool *running);
	virtual void update();
	const std::string name;

protected:
	managers manager;
	void exit();

private:
	bool *m_running;
};

} // namespace system
} // namespace engine
