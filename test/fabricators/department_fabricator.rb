# frozen_string_literal: true

## Copyright (c) 2024 John Newton
## SPDX-License-Identifier: Apache-2.0

Fabricator(:department) do
  users { [] }
  id { sequence(:department_id, 1) }
  name { Faker::Name.name }
end
