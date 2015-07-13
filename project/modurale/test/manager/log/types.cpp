#include <catch.hpp>
#include <sstream>
#include <string>
#include <boost/uuid/uuid_generators.hpp>
#include "log_no_prefix.hpp"
#include "manager/entity/id.hpp"

TEST_CASE("manager-log-types") {
    std::stringstream out;
    log_no_prefix log(out);
    auto instance = log.make_instance("user");

    SECTION("fundamental types can be logged")
    {
        instance.info() << 42;
        REQUIRE(out .str() == "42.\n");
        out.str("");

        instance.info() << 0.5;
        REQUIRE(out.str() == "0.5.\n");
        out.str("");

        instance.info() << 'a';
        REQUIRE(out.str() == "a.\n");
        out.str("");

        instance.info() << "text";
        REQUIRE(out.str() == "text.\n");
    }

    SECTION("standard library types can be logged")
    {
        instance.info() << std::string("text");
        REQUIRE(out.str() == "text.\n");
    }

    SECTION("boost::uuids::uuid can be logged")
    {
        using engine::manager::entity::id;
        using boost::uuids::string_generator;

        id entity = string_generator()("a309434c-daaa-4bd8-8229-6b2033cf2cd1");
        instance.info() << entity;
        REQUIRE(out.str() == "a309434c-daaa-4bd8-8229-6b2033cf2cd1.\n");
    }
}
