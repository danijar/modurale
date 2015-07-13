#include <catch.hpp>
#include <sstream>
#include <array>
#include <string>
#include "manager/log/manager.hpp"
#include "log_no_prefix.hpp"

TEST_CASE("manager-log") {
    std::stringstream out;
    log_no_prefix log(out);
    auto instance = log.make_instance("user");

    SECTION("logged text will be formatted according to user and log level")
    {
        engine::manager::log::manager log(out);
        auto instance = log.make_instance("user");

        instance.info() << "text";
        REQUIRE(out.str() == "user (info): text.\n");
        out.str("");

        instance.error() << "text";
        REQUIRE(out.str() == "user (error): text.\n");
        out.str("");

        instance.warning() << "text";
        REQUIRE(out.str() == "user (warning): text.\n");
        out.str("");

        instance.debug() << "text";
        REQUIRE(out.str() == "user (debug): text.\n");
    }

    SECTION("multiple messages can be logged")
    {
        instance.info() << "one";
        instance.info() << "two";
        REQUIRE(out.str() == "one.\ntwo.\n");
    }

    SECTION("non-string types are serialized")
    {
        instance.info() << 42;
        REQUIRE(out.str() == "42.\n");
    }

    SECTION("multiple inputs can be streamed")
    {
        instance.info() << "one" << "two" << "three";
        REQUIRE(out.str() == "one two three.\n");
    }

    SECTION("the separator can be customized")
    {
        std::array<std::string, 4> seps = {" ", "", "\n", "SEP"};
        for (auto sep : seps) {
            instance.info(sep) << "one" << "two" << "three";
            std::string result = "one" + sep + "two" + sep + "three.\n";
            REQUIRE(out.str() == result);
            out.str("");
        }
    }

    SECTION("the end can be customized")
    {
        std::array<std::string, 5> ends = {".", "\n", "\n\n", "END", ""};
        for (auto end : ends) {
            instance.info(" ", end) << "one" << "two" << "three";
            std::string result = "one two three" + end;
            REQUIRE(out.str() == result);
            out.str("");
        }
    }
}
