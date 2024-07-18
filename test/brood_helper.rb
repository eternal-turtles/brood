# frozen_string_literal: true

## Copyright (c) 2024 John Newton
## SPDX-License-Identifier: Apache-2.0

module BroodHelper
  def department_brood
    Brood.new.tap do |brood|
      widgets_qc = brood.set(
        %i[department widgets_qc],
        {
          name: "Widgets Quality Control"
        }
      )

      brood.set(
        %i[user alice],
        {
          id: 32_432,
          name: "Alice",
          department: widgets_qc
        }
      ) do |user|
        widgets_qc.users << user
      end

      brood.set(
        %i[user anne],
        id: 8932,
        name: "Anne",
        department: widgets_qc
      ) do |user|
        widgets_qc.users << user
        user
      end

      brood.set(%i[user bill],
        {
          id: 3232,
          name: "Bill",
          department: widgets_qc
        }) do |user|
        widgets_qc.users << user
      end
      brood.set(%i[user ivan],
        {
          id: 12,
          name: "Ivan",
          department: widgets_qc
        }) do |user|
        widgets_qc.users << user
      end

      gizmos_qc = brood.set(%i[department gizmos_qc],
        {
          name: "Gizmos Quality Control"
        })

      brood.set(%i[user henry],
        {
          name: "Henry",
          department: gizmos_qc
        })

      brood.set(%i[user sam],
        {
          name: "Sam",
          department: gizmos_qc
        })

      brood.set(%i[user irina],
        {
          name: "Irina",
          department: gizmos_qc
        })
    end
  end
end
