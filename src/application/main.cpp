#include <exception>
#include <iostream>
#include "../system/system.hpp"
#include "../module/window/module.hpp"

using namespace std;
using namespace engine;

int main()
{
	try {
		system::system system;

		module::window window("window");
		system.attach(window);

		while (system.running())
			system.update();

		system.detach("window");
	} catch (std::exception &e) {
		cerr << "Uncaught exception: " << e.what() << endl;
		cin.get();
	}

	return 0;
}
