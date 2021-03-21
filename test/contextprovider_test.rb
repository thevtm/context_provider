# frozen_string_literal: true

require 'test_helper'

describe ContextProvider do
  it 'has a version number' do
    refute_nil ::ContextProvider::VERSION
  end

  describe '#provide' do
    it 'provides the given value' do
      context = ContextProvider.new
      context.provide('foo') do
        assert_equal context.get, 'foo'
      end
    end

    it 'cleans up after executing' do
      context = ContextProvider.new
      context.provide('foo') { nil }
      assert_equal context.value_provided?, false
    end

    it 'raises an error when the context is overwritten' do
      context = ContextProvider.new

      context.provide('foo') do
        assert_raises(ContextProvider::ContextAlreadyProvidedError) do
          context.provide('foo') { nil }
        end
      end
    end
  end

  describe '#get' do
    it 'raises an error when not provided' do
      context = ContextProvider.new
      assert_raises(ContextProvider::ContextNotProvidedError) do
        context.get
      end
    end
  end

  describe '#where_provide_was_called' do
    it 'raises ContextNotProvidedError when context has not been ' \
      'provided' do
      assert_raises(ContextProvider::ContextNotProvidedError) do
        ContextProvider.new.where_provide_was_called
      end
    end
  end

  it 'records provide caller' do
    def dummy_method
      context = ContextProvider.new

      context.provide('foo') do
        assert context.where_provide_was_called.first.include?('dummy_method')
      end
    end

    dummy_method
  end

  # rubocop:disable Naming/VariableNumber
  it 'is thread safe' do
    # Be careful when modifying this test not to cause infinite loops
    context = ContextProvider.new

    failure_occurred = false

    thread_started = false
    thread_1_initialized = false
    thread_2_ended = false

    thread_1 = Thread.new do
      thread_1_initialized = true
      true until thread_started

      begin
        context.provide('value_1') do
          assert_equal context.get, 'value_1'
        end
      rescue StandardError
        failure_occurred = true
      end

      true until thread_2_ended
    end

    thread_2 = Thread.new do
      true until thread_1_initialized && thread_started

      begin
        context.provide('value_2') do
          assert_equal context.get, 'value_2'
        end
      rescue StandardError
        failure_occurred = true
      end

      thread_2_ended = true
    end

    thread_started = true

    thread_1.join
    thread_2.join

    assert_equal failure_occurred, false
  end
  # rubocop:enable Naming/VariableNumber
end
