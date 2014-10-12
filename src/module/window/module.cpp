#include "module.hpp"

#include <iostream>
#include <SFML/Window.hpp>
#include "../../type/window/type.hpp"

namespace engine {
namespace module {
using namespace std;
using namespace sf;

window::window(string name, system::managers &managers) : module(name, managers)
{
	// Register listeners
	listeners();

	// Create window if none
	if (!manager.entity.size<type::window>())
		open(manager.entity.create());
}

void window::update()
{
	// Loop over all windows
	manager.entity.each([&](type::window &window, id entity) {
		// Handle window events
		Event e;
		while (window.m_handle->pollEvent(e)) {
			switch (e.type) {
			case Event::Closed:
				close(entity);
				break;
			case Event::KeyPressed:
				manager.event.fire("type:window:key", entity, e.key.code, e.key.control);
				break;
			}
		}

		// Display what other modules have drawn and reset canvas
		window.m_handle->display();
		window.m_handle->clear(Color(100, 149, 237));
	});

	// Exit if last window was closed
	if (!manager.entity.size<type::window>())
		exit();
}

void window::listeners()
{
	using Key = Keyboard::Key;

	manager.event.listen("type:window:key", [=](id entity, Key code) {
		// Get window property
		auto &window = manager.entity.get<type::window>(entity);

		// Handle different keys
		switch (code) {
		case Key::Escape:
			close(entity);
			break;
		case Key::F11:
			// Move in own function and aquire lock
			window.m_fullscreen = !window.m_fullscreen;
			// This doesn't work. The window will be opened in the window of the
			// event manager. But window events must be polled in the thread it
			// was created in.
			open(entity);
			break;
		}
	});
}

void window::open(window::id entity)
{
	// Get window or create new one
	auto window = manager.entity.add<type::window>(entity);

	boost::unique_lock<boost::shared_mutex> lock(manager.entity.mutex<type::window>());

	// Close if open first
	if (window.m_handle->isOpen())
		window.m_handle->close();

	// Open up new window
	auto resolution = window.m_fullscreen ? VideoMode::getDesktopMode() : VideoMode(800, 600);
	auto decoration = window.m_fullscreen ? Style::Fullscreen : Style::Default;
	window.m_handle->create(resolution, window.m_title, decoration, ContextSettings(0, 0, 0, 3, 3));

	// Store position to restore after fullscreen
	window.m_position = window.m_handle->getPosition();
}

void window::close(window::id entity)
{
	// Close window and remove entity
	auto &window = manager.entity.get<type::window>(entity);
	
	boost::unique_lock<boost::shared_mutex> lock(manager.entity.mutex<type::window>());
	manager.log.debug() << "Close window" << "'" + window.m_title + "'";
	window.m_handle->close();
	lock.unlock();

	manager.entity.remove(entity);
}

} // namespace module
} // namespace engine
