#pragma once

#include <string>
#include <memory>
#include <SFML/Graphics/RenderWindow.hpp>

namespace engine {
namespace type {

struct window {
	std::shared_ptr<sf::RenderWindow> m_handle{ new sf::RenderWindow }; // Do I need a pointer here?
	std::string m_title = "Window";
	sf::Vector2u m_size{ 800, 600 };
	sf::Vector2i m_position;
	bool m_open = true, m_fullscreen = false, m_remove = false, m_dirty = true;
};

} // namespace type
} // namespace engine
