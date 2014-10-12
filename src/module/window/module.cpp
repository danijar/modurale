#include "module.hpp"

#include <iostream>
#include <SFML/Window.hpp>

namespace engine {
namespace module {
using namespace std;
using namespace sf;

window::window(string name, system::managers &managers) : module(name, managers)
{
	// Register listeners
	listeners();

	// Create window if none
	if (!manager.entity.size<type::window>()) {
		id entity = manager.entity.create();
		auto window = manager.entity.add<type::window>(entity);
		window.m_dirty = true;
	}
}

void window::update()
{
	// Loop over all windows
	manager.entity.each([&](type::window &window, id entity) {
		// Adapt to property changes
		if (window.m_remove) {
			remove(entity);
			return;
		}
		apply(window);

		// Handle window events
		Event e;
		while (window.m_handle->pollEvent(e)) {
			switch (e.type) {
			case Event::Closed:
				remove(entity);
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

	manager.event.listen("type:window:key", [=](id entity, Key code, bool control) {
		// Get window property
		auto &window = manager.entity.get<type::window>(entity);

		// Handle different keys
		switch (code) {
		case Key::Escape:
			remove(entity);
			break;
		case Key::F11:
			window.m_fullscreen = !window.m_fullscreen;
			window.m_dirty = true;
			break;
		case Key::N:
			if (control) {
				manager.log.info() << "Open new window";
				id entity = manager.entity.create();
				auto window = manager.entity.add<type::window>(entity);
				window.m_dirty = true;
			}
		}
	});
}

void window::apply(type::window &window)
{	
	// No changes made
	if (!window.m_dirty)
		return;

	if (window.m_handle->isOpen()) {
		// Store position to restore after fullscreen
		if (window.m_fullscreen)
			window.m_position = window.m_handle->getPosition();

		// Close first
		if (window.m_handle->isOpen())
			window.m_handle->close();
	}

	if (window.m_open) {
		// Open up new window
		auto resolution = window.m_fullscreen ? VideoMode::getDesktopMode() : VideoMode(800, 600);
		auto decoration = window.m_fullscreen ? Style::Fullscreen : Style::Default;
		window.m_handle->create(resolution, window.m_title, decoration, ContextSettings(0, 0, 0, 3, 3));

		// Restore position if windowed mode
		if (!window.m_fullscreen)
			if (window.m_position != Vector2i())
				window.m_handle->setPosition(window.m_position);
	}

	// Everything done
	window.m_dirty = false;
}

void window::remove(window::id entity)
{
	// Close window and remove entity
	auto &window = manager.entity.get<type::window>(entity);
	manager.log.debug() << "Remove window" << "'" + window.m_title + "'";
	window.m_handle->close();
	manager.entity.remove(entity);
}

} // namespace module
} // namespace engine
