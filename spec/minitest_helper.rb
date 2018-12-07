require 'coverage_helper'
require 'simple_profiler'
require 'minitest/autorun'
require 'minitest/colorin'
require 'pry-nav'

class Minitest::Spec

  let(:temp_path) {File.expand_path "./tmp", File.dirname(__FILE__)}

  before do
    FileUtils.mkpath temp_path
  end

  after do
    FileUtils.rm_rf temp_path
  end
end