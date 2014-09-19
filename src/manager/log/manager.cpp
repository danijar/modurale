#include "manager.hpp"

#include <iostream>

namespace engine {
namespace manager {
using namespace std;

void log::print(const string message)
{
	cout << message << endl;
}

void log::debug(const string message)
{
	cout << message << endl;
}

} // namespace manager
} // namespace engine
