#pragma once

#include <string>
#include <unordered_map>
#include <iostream>
#include <boost/thread/mutex.hpp>

namespace engine {
namespace manager {

class log {
public:
	struct stream {
		stream(std::ostream &out, boost::mutex &mutex, std::string name, std::string sep, std::string end);
		~stream();
		template<typename T> stream &operator<<(const T &v);
	private:
		bool m_touched = false;
		std::ostream &m_out;
		boost::mutex &m_mutex;
		std::string m_name;
		std::string m_sep;
		std::string m_end;
	};
	class instance;

	instance &make_instance(std::string user);
	stream info   (std::string name, std::string sep, std::string end);
	stream warning(std::string name, std::string sep, std::string end);
	stream error  (std::string name, std::string sep, std::string end);
	stream debug  (std::string name, std::string sep, std::string end);

private:
	std::ostream &m_out = std::cout;
	boost::mutex m_mutex;
	std::unordered_map<std::string, std::unique_ptr<instance>> m_instances;
};

class log::instance {
public:
	instance(std::string name, log &manager);
	stream info   (std::string sep = " ", std::string end = ".\n");
	stream warning(std::string sep = " ", std::string end = ".\n");
	stream error  (std::string sep = " ", std::string end = ".\n");
	stream debug  (std::string sep = " ", std::string end = ".\n");

private:
	std::string m_name;
	log &m_manager;
};

} // namespace manager
} // namespace engine

#include "manager.inl"
