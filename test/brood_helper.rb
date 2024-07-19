# frozen_string_literal: true

## Copyright (c) 2024 John Newton
## SPDX-License-Identifier: Apache-2.0

module BroodHelper
  def department_brood
    Brood.new.tap do |brood|
      widgets_qc = brood.create(
        %i[department widgets_qc],
        {
          name: "Widgets Quality Control"
        }
      )

      brood.create(
        %i[user alice],
        {
          id: 32_432,
          name: "Alice",
          department: widgets_qc
        }
      ) do |user|
        widgets_qc.users << user
      end

      brood.create(
        %i[user anne],
        id: 8932,
        name: "Anne",
        department: widgets_qc
      ) do |user|
        widgets_qc.users << user
        user
      end

      brood.create(%i[user bill],
        {
          id: 3232,
          name: "Bill",
          department: widgets_qc
        }) do |user|
        widgets_qc.users << user
      end
      brood.create(%i[user ivan],
        {
          id: 12,
          name: "Ivan",
          department: widgets_qc
        }) do |user|
        widgets_qc.users << user
      end

      gizmos_qc = brood.create(%i[department gizmos_qc],
        {
          name: "Gizmos Quality Control"
        })

      brood.create(%i[user henry],
        {
          name: "Henry",
          department: gizmos_qc
        })

      brood.create(%i[user sam],
        {
          name: "Sam",
          department: gizmos_qc
        })

      brood.create(%i[user irina],
        {
          name: "Irina",
          department: gizmos_qc
        })

      brood.build(%i[user foobar],
        {
          name: "Foobar",
          department: gizmos_qc
        })
    end
  end
end
