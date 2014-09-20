#include "module.hpp"

#include <iostream>
#include <SFML/Window.hpp>
#include "../../type/window/type.hpp"

namespace engine {
namespace module {
using namespace std;
using namespace sf;

window::window(string name) : module(name) {}

void window::init()
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
	manager.entity.each<type::window>([=](type::window &window, id entity) {
		// Handle window events
		Event e;
		while (window.m_handle->isOpen() && window.m_handle->pollEvent(e)) {
			switch (e.type) {
			case Event::Closed:
				close(entity);
				break;
			case Event::KeyPressed:
				manager.event.fire("type:window:key", entity, e.key.code);
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
			window.m_fullscreen = !window.m_fullscreen;
			open(entity);
			break;
		}
	});
}

void window::open(window::id entity)
{
	// Get window or create new one
	auto window = manager.entity.add<type::window>(entity);

	// Close if open
	if (window.m_handle->isOpen())
		window.m_handle->close();

	// Open window
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
	manager.log.debug() << "Close window" << "'" + window.m_title + "'";
	window.m_handle->close();
	manager.entity.remove(entity);
}

} // namespace module
} // namespace engine
