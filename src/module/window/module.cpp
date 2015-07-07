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
		window.m_dirty = true; // TODO: Should not be needed since it's the default.
	}
}

void window::update()
{
	// Loop over all windows
	manager.entity.each([&](type::window &window, id entity) {
		// Adapt to property changes
		if (window.m_dirty)
			apply(entity);

		// Handle window events
		Event e;
		while (window.m_handle->pollEvent(e)) {
			switch (e.type) {
			case Event::Closed:
				window.m_remove = true;
				window.m_dirty = true;
				return;
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
			// Remove window on escape
			window.m_remove = true;
			window.m_dirty = true;
			break;
		case Key::F11:
			// Toggle fullscreen on F11
			window.m_fullscreen = !window.m_fullscreen;
			window.m_dirty = true;
			break;
		case Key::N:
			if (!control)
				break;
			// Create new window on Ctrl + N
			id entity = manager.entity.create();
			auto window = manager.entity.add<type::window>(entity);
			window.m_dirty = true;
			break;
		}
	});
}

void window::apply(window::id entity)
{
	// Get window property
	auto &window = manager.entity.get<type::window>(entity);

	// Close first so new state can be created
	if (window.m_handle->isOpen()) {
		// Store size and position to restore after fullscreen
		if (window.m_fullscreen) {
			window.m_size     = window.m_handle->getSize();
			window.m_position = window.m_handle->getPosition();
		}

		// Close first
		if (window.m_handle->isOpen())
			window.m_handle->close();
	}

	// Remove entity
	if (window.m_remove) {
		manager.log.debug() << "Remove window" << entity;

		// Don't open window again and enqueue to remove entity
		window.m_open = false;
		manager.entity.remove(entity);
	}

	// Newly create handle from attributes
	if (window.m_open) {
		manager.log.debug() << "Open window" << entity;

		// Open up new window
		auto resolution = window.m_fullscreen ? VideoMode::getDesktopMode() : VideoMode(window.m_size.x, window.m_size.y);
		auto decoration = window.m_fullscreen ? Style::Fullscreen : Style::Default;
		window.m_handle->create(resolution, window.m_title, decoration, ContextSettings(0, 0, 0, 3, 3));

		// Restore size and position if windowed mode
		if (!window.m_fullscreen) {
			window.m_handle->setSize(window.m_size);
			if (window.m_position != Vector2i())
				window.m_handle->setPosition(window.m_position);
		}
	}

	// Everything done
	window.m_dirty = false;
}

} // namespace module
} // namespace engine
