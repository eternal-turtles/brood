# frozen_string_literal: true

## Copyright (c) 2024 John Newton
## SPDX-License-Identifier: Apache-2.0

require "test_helper"
require_relative "brood_helper"

describe Brood do
  include BroodHelper

  before do
    @brood = department_brood
  end

  describe "department brood" do
    describe "brood data" do
      it "loads objects to the store" do
        store = @brood.instance_variable_get(:@store)
        refute_nil(store)
        assert_equal(2, store.dig(:department, :objects).length)
        assert_equal(8, store.dig(:user, :objects).length)
      end
    end

    describe "#create" do
      it "creates an object" do
        department_count = -> {
          @brood.instance_variable_get(:@store).dig(:department, :objects).size
        }
        user_count = -> {
          @brood.instance_variable_get(:@store).dig(:user, :objects).size
        }

        assert_equal(2, department_count.call)
        assert_equal(8, user_count.call)

        @brood.create(%i[user jimbo],
          {
            id: 1_234,
            name: "Jimbo"
          })

        assert_equal(9, user_count.call)

        user_objects = @brood.instance_variable_get(:@store).dig(:user, :objects)
        user_objects.each do |object_name, object|
          assert_instance_of(Symbol, object_name)
          assert_instance_of(User, object)
        end
        assert_instance_of(Department, @brood.get(%i[department widgets_qc]))
        assert_instance_of(Department, @brood.get(%i[department gizmos_qc]))
        assert_instance_of(User, @brood.get(%i[user jimbo]))
        assert_equal("Jimbo", @brood.get(%i[user jimbo]).name)
      end

      it "raises an exception on invalid arguments" do
        assert_raises(ArgumentError) {
          @brood.create([:user, :foo]) {}
        }
        assert_raises(ArgumentError) {
          @brood.create(["user", :baar], {id: 21_322})
        }
        assert_raises(ArgumentError) {
          @brood.create([:user, "foo"], {id: 23_420})
        }
        assert_raises(TypeError) {
          @brood.create([:user, :baaz], 2432)
        }
        assert_raises(TypeError) {
          @brood.create([:user, :baaz], "xyz")
        }
      end

      it "raises an exception when an object is already defined for the identifier" do
        assert_raises(Brood::ObjectAlreadyDefinedError) do
          @brood.create(%i[user alice],
            {
              id: 5_325,
              name: "Alice"
            })
        end
      end
    end

    describe "#build" do
      it "builds an object" do
        department_count = -> {
          @brood.instance_variable_get(:@store).dig(:department, :objects).size
        }
        user_count = -> {
          @brood.instance_variable_get(:@store).dig(:user, :objects).size
        }

        assert_equal(2, department_count.call)
        assert_equal(8, user_count.call)

        @brood.build(%i[user jimbo],
          {
            id: 1_234,
            name: "Jimbo"
          })

        assert_equal(9, user_count.call)

        user_objects = @brood.instance_variable_get(:@store).dig(:user, :objects)
        user_objects.each do |object_name, object|
          assert_instance_of(Symbol, object_name)
          assert_instance_of(User, object)
        end
        assert_instance_of(Department, @brood.get(%i[department widgets_qc]))
        assert_instance_of(Department, @brood.get(%i[department gizmos_qc]))
        assert_instance_of(User, @brood.get(%i[user jimbo]))
        assert_equal("Jimbo", @brood.get(%i[user jimbo]).name)
      end

      it "raises an exception on invalid arguments" do
        assert_raises(ArgumentError) {
          @brood.build([:user, :foo]) {}
        }
        assert_raises(ArgumentError) {
          @brood.build(["user", :baar], {id: 21_322})
        }
        assert_raises(ArgumentError) {
          @brood.build([:user, "foo"], {id: 23_420})
        }
        assert_raises(TypeError) {
          @brood.build([:user, :baaz], 2432)
        }
        assert_raises(TypeError) {
          @brood.build([:user, :baaz], "xyz")
        }
      end

      it "raises an exception when an object is already defined for the identifier" do
        assert_raises(Brood::ObjectAlreadyDefinedError) do
          @brood.build(%i[user alice],
            {
              id: 5_325,
              name: "Alice"
            })
        end
      end
    end

    describe "#get" do
      it "retrieves an object instantiated with 'create' from the store" do
        object = @brood.get(%i[user alice])
        assert_instance_of(User, object)
      end

      it "retrieves an object instantiated with 'build' from the store" do
        object = @brood.get(%i[user foobar])
        assert_instance_of(User, object)
      end

      it "raises an exception when the object is not found in the store" do
        assert_raises(Brood::ObjectNotFoundError) do
          @brood.get(%i[user bob])
        end
      end

      it "passes the object as an argument to the optional block, returning the object from the block" do
        user = @brood.get(%i[user sam]) do |user|
          assert_instance_of(User, user)
          user.counter = 100
        end
        assert_instance_of(User, user)
        assert(100, user.counter)
      end

      it "locks the object in the block, allowing for threadsafe updates" do
        threads = []

        10.times do
          threads << Thread.new do
            1000.times do
              @brood.get(%i[user alice]) do |user|
                current_value = user.counter
                sleep 0.0001
                user.counter = current_value + 1
              end
            end
          end
        end

        threads.each(&:join)

        assert_equal 10000, @brood.get(%i[user alice]).counter
      end
    end
  end
end
