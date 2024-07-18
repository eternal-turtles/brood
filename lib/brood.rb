# frozen_string_literal: true
# typed: true

## Copyright (c) 2024 John Newton
## SPDX-License-Identifier: Apache-2.0

require "fabrication"

require_relative "brood/version"

# Brood: object canister for modular test fixtures.
class Brood
  # Base class for Brood errors.
  class Error < StandardError; end

  # Error raised when attempting to re-define an object for the given key.
  class ObjectAlreadyDefinedError < Error; end

  # Error raised when an object is not found for the given key.
  class ObjectNotFoundError < Error; end

  # Error raised when an object does not match its specified type.
  class ObjectTypeError < Error; end

  # Error raised when attempting to retrieve an unknown object-type.
  class UnknownObjectTypeError < Error; end

  def initialize
    @store = {}
    @object_mutexes = {}
  end

  # Adds an object to the store.
  #
  # @param key [Array<Symbol, Symbol>] The key representing the object type and name.
  # @param attributes [Hash] Optional attributes for the object.
  # @yield Optional block to customize the object.
  # @raise [ArgumentError] If the arguments are invalid.
  # @raise [ObjectAlreadyDefinedError] If an object is already defined for the key.
  # @return [Object] The fabricated object.
  def set(key, attributes, &)
    object_type, object_name = key
    validate_arguments(object_type, object_name)

    create_object(object_type, object_name, attributes, &)
  end

  # Retrieves an object from the store.
  #
  # @param key [Array<Symbol, Symbol>] The key representing the object type and name.
  # @yield Optional block to customize the object; the object is locked.
  # @raise [ArgumentError] If the arguments are invalid.
  # @raise [ObjectNotFoundError] If the object is not found.
  # @return [Object] The fabricated object.
  def get(key, &block)
    object_type, object_name = key
    validate_arguments(object_type, object_name)

    if block
      retrieve_object(object_type, object_name, &block)
    else
      retrieve_object(object_type, object_name)
    end
  end

  private

  def validate_arguments(object_type, object_name)
    unless object_type.is_a?(Symbol)
      raise ArgumentError,
        "Invalid argument type: object_type must be a symbol."
    end

    unless object_name.is_a?(Symbol)
      raise ArgumentError,
        "Invalid argument type: object_name must be a symbol."
    end
  end

  def create_object(object_type, object_name, attributes, &)
    @store[object_type] ||= {}
    @store[object_type][:objects] ||= {}
    if @store[object_type][:objects].key?(object_name)
      raise ObjectAlreadyDefinedError,
        "A object is already defined: (#{object_type} #{object_name})"
    end
    @store[object_type][:objects][object_name] = Fabricate(
      object_type, **attributes, &
    )
  end

  def retrieve_object(object_type, object_name, &block)
    unless @store.key?(object_type)
      raise UnknownObjectTypeError,
        "Unknown object-type: #{object_type}"
    end
    object = @store.dig(object_type, :objects, object_name)
    unless object
      raise ObjectNotFoundError,
        "The specified object does not exist: (type: #{object_type} name: #{object_name})"
    end
    if block
      lock_object(object_type, object_name) do
        block.call(object)
        object
      end
    else
      object
    end
  end

  def lock_object(object_type, object_name, &block)
    @object_mutexes[object_type] ||= {}
    @object_mutexes[object_type][object_name] ||= Mutex.new

    @object_mutexes[object_type][object_name].synchronize do
      block.call
    end
  end
end
