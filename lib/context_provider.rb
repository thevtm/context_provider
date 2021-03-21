# frozen_string_literal: true

require 'concurrent-ruby'

require 'context_provider/version'

# A +ContextProvider+ allows data to be passed down the call stack in a explicit
# way while avoiding having to pass parameters just so it can be used by a
# nested function.
#
# @example
#   context = ContextProvider.new
#
#   context.provide("bar") do
#     context.get #=> "bar"
#   end
class ContextProvider
  class Error < StandardError; end

  class ContextAlreadyProvidedError < Error; end

  class ContextNotProvidedError < Error; end

  def initialize
    @provided = Concurrent::ThreadLocalVar.new
    @provide_call_stack = Concurrent::ThreadLocalVar.new
  end

  # Provided value that can be accessed using +get+ inside the nested block.
  #
  # @raise [ContextAlreadyDefinedError] if context has already been provide
  #
  # @param [Object] value Value to be passed down the stack
  # @param [Proc] block Block where provided value is going to be available.
  def provide(value, &block)
    if value_provided?
      raise ContextAlreadyProvidedError,
            'Failed to provide context because it has already been provided!'
    end

    begin
      set_provided_value(value)
      block.call
    ensure
      unset_provided_value
    end
  end

  # Gets value from provided by the context.
  #
  # @raises [ContextNotProvidedError] if no value has been provided
  #
  # @return [Object] provided value
  def get
    unless value_provided?
      raise ContextNotProvidedError,
            'Unable to get context value as it has not been defined!'
    end

    @provided.value
  end

  # Returns +true+ when value has been provided (inside a +provide+ block)
  # +false+ otherwise.
  #
  # @return [Boolean]
  def value_provided?
    @provide_call_stack.value != nil
  end

  # Returns the callstack for where +provide+ was called.
  #
  # @raise [ContextNotProvidedError] if no value has been provided
  #
  # @return [Array] callstack for where +provide+ was called
  def where_provide_was_called
    unless value_provided?
      raise ContextNotProvidedError,
            'Unable to get the provide callstack because context has not been ' \
            'provided!'
    end

    @provide_call_stack.value
  end

  # Sets provided value.
  # Doesn't perform any checks.
  # Doesn't clean up (see +dangerously_unset_provided_value+).
  # Should only be used as a last resort.
  #
  # @param [Object] value
  def dangerously_set_provided_value(value)
    set_provided_value(value)
  end

  # Unsets provided value.
  # Doesn't perform any checks.
  # Meant to be used in conjunction with +dangerously_set_provided_value+.
  # Should only be used as a last resort.
  def dangerously_unset_provided_value
    unset_provided_value
  end

  private

  # rubocop:disable Naming/AccessorMethodName
  def set_provided_value(value)
    @provide_call_stack.value = caller(2)
    @provided.value = value
  end
  # rubocop:enable Naming/AccessorMethodName

  def unset_provided_value
    @provided.value = nil
    @provide_call_stack.value = nil
  end
end
