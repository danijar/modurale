#include <thread>
#include <chrono>
#include <atomic>
#include <catch/catch.hpp>
#include "../src/manager/event/manager.hpp"

struct custom_type {
	custom_type(int number) : number(number) {}
	int number = 0;
};

TEST_CASE("event manager") {
	engine::manager::event event;
	auto instance_one = event.make_instance("first user");
	auto instance_two = event.make_instance("second user");
	std::chrono::milliseconds delay(10);

	SECTION("events of one instance will be heard by the other") {
		bool success = false;
		instance_one.listen("event", [&]() {
			success = true;
		});
		instance_two.fire("event");

		std::this_thread::sleep_for(delay);
		REQUIRE(success);
		REQUIRE_NOTHROW(event.rethrow());
	}

	SECTION("events of one instance will be heard by itself") {
		bool success = false;
		instance_one.listen("event", [&]() {
			success = true;
		});
		instance_one.fire("event");

		std::this_thread::sleep_for(delay);
		REQUIRE(success);
		REQUIRE_NOTHROW(event.rethrow());
	}

	SECTION("parameters can be passed") {
		int number = 0;
		instance_one.listen("event", [&](int parameter) {
			number = parameter;
		});
		instance_two.fire("event", 42);

		std::this_thread::sleep_for(delay);
		REQUIRE(number == 42);
		REQUIRE_NOTHROW(event.rethrow());
	}

	SECTION("custom types can be used as parameters") {
		int number = 0;
		instance_one.listen("event", [&](custom_type parameter) {
			number += parameter.number;
		});
		instance_two.fire("event", custom_type(42));

		std::this_thread::sleep_for(delay);
		REQUIRE(number == 42);
		REQUIRE_NOTHROW(event.rethrow());
	}

	SECTION("not all parameters have to be used") {
		std::atomic_int number{ 0 };
		instance_one.listen("event", [&]() {
			number++;
		});
		instance_one.listen("event", [&](int parameter) {
			number += parameter;
		});
		instance_one.listen("event", [&](int ignore, double parameter) {
			number += static_cast<int>(parameter);
		});
		instance_two.fire("event", 42, 3.14);

		std::this_thread::sleep_for(delay);
		REQUIRE(number == 46);
		REQUIRE_NOTHROW(event.rethrow());
	}

	SECTION("at least the expected parameters need to be provided") {
		instance_one.listen("event", [&](int one, double two) {});
		instance_two.fire("event", 42);

		std::this_thread::sleep_for(delay);
		REQUIRE_THROWS_AS(event.rethrow(), engine::manager::event::bad_arity);
		REQUIRE_NOTHROW(event.rethrow());
	}

	SECTION("the provided parameters must match in type") {
		instance_one.listen("event", [&](int one, double two) {});
		instance_two.fire("event", 42, "second");

		std::this_thread::sleep_for(delay);
		REQUIRE_THROWS_AS(event.rethrow(), engine::manager::event::bad_types);
		REQUIRE_NOTHROW(event.rethrow());
	}

	SECTION("callbacks are called asynchronously") {
		bool success = false;
		instance_one.listen("event", [&]() {
			std::this_thread::sleep_for(delay / 2);
			success = true;
		});
		instance_two.fire("event");

		REQUIRE_FALSE(success);
		std::this_thread::sleep_for(delay);
		REQUIRE(success);
		REQUIRE_NOTHROW(event.rethrow());
	}

	SECTION("callbacks are executed in registration order") {
		int number = 0;
		instance_one.listen("event", [&]() {
			number = 42;
		});
		instance_two.listen("event", [&]() {
			number = 13;
		});
		for (int i = 0; i < 5; i++)
			instance_two.fire("event");

		std::this_thread::sleep_for(5 * delay);
		REQUIRE(number == 13);
		REQUIRE_NOTHROW(event.rethrow());
	}
}
