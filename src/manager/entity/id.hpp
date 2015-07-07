#pragma once

#include <iostream>
#include <boost/uuid/uuid.hpp>
#include <boost/functional/hash.hpp>
#include <boost/uuid/uuid_io.hpp>

namespace engine {
namespace manager {
namespace entity {

using id = boost::uuids::uuid;
using id_hash = boost::hash<boost::uuids::uuid>;

} // namespace entity
} // namespace manager
} // namespace engine
