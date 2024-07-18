# frozen_string_literal: true

## Copyright (c) 2024 John Newton
## SPDX-License-Identifier: Apache-2.0

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "brood"
require "minitest/autorun"
require "faker"

class Department
  attr_accessor :id, :name, :users
end

class User
  attr_accessor :id, :name, :department, :counter
end
