# frozen_string_literal: true

## Copyright (c) 2024 John Newton
## SPDX-License-Identifier: Apache-2.0

Fabricator(:user) do
  department
  id { sequence(:user_id, 1) }
  name { Faker::Name.name }
  counter 0
end
