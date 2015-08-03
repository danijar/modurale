#include <exception>
#include <iostream>
#include "modurale/system/system.hpp"
#include "modurale/system/managers.hpp"
#include "modurale/module/window/module.hpp"

int main()
{
	try {
		engine::system::system system;
		engine::system::managers managers;

		engine::module::window window("window", managers);
		system.attach(window);

		while (system.running())
			system.update();

		system.detach("window");
	} catch (std::exception &e) {
		std::cerr << "Uncaught exception: " << e.what() << std::endl;
		std::cin.get();
	}

	return 0;
}
