require 'coverage_helper'
require 'simple_profiler'
require 'minitest/autorun'
require 'turn'
require 'pry-nav'

Turn.config do |c|
  c.format = :pretty
  c.natural = true
  c.ansi = true
end

class Minitest::Spec

  let(:temp_path) {File.expand_path "./tmp", File.dirname(__FILE__)}

  before do
    FileUtils.mkpath temp_path
  end

  after do
    FileUtils.rm_rf temp_path
  end
end