#include "../system/system.hpp"
#include "../module/window/module.hpp"

using namespace engine;

int main()
{
	system::system system;

	module::window window("window");
	system.attach(window);

	system.init();
	while (system.running())
		system.update();

	system.detach("window");

	return 0;
}
