require 'minitest_helper'

describe SimpleProfiler do

  class TestRunner
    def self.run
      'profile_class_methods OK'
    end
    def run
      'profile_instance_methods OK'
    end
  end

  class TestReporter
    def initialize(filename)
      @filename = filename
    end
    def notify(event)
      File.write @filename, "#{event.klass}-#{event.method}"
    end
  end

  SimpleProfiler.configure do |config|
    SimpleProfiler.profile_class_methods    TestRunner, :run
    SimpleProfiler.profile_instance_methods TestRunner, :run
  end

  it 'Profile class methods' do
    filename = File.join temp_path, "file_#{(Time.now.to_f * 1000).to_i}.txt"

    SimpleProfiler.configure do |config|
      config.reporters = [TestReporter.new(filename)]
    end

    TestRunner.run.must_equal 'profile_class_methods OK'
    File.exist?(filename).must_equal true
    File.read(filename).must_equal "TestRunner-run"
  end

  it 'Profile instance methods' do
    filename = File.join temp_path, "file_#{(Time.now.to_f * 1000).to_i}.txt"

    SimpleProfiler.configure do |config|
      config.reporters = [TestReporter.new(filename)]
    end

    TestRunner.new.run.must_equal 'profile_instance_methods OK'
    File.exist?(filename).must_equal true
    File.read(filename).must_equal "TestRunner-run"
  end

  it 'Profile with logger' do
    filename = File.join temp_path, "file_#{(Time.now.to_f * 1000).to_i}.log"
    logger = ::Logger.new filename

    SimpleProfiler.configure do |config|
      config.reporters = [SimpleProfiler::Reporters::Logger.new(logger)]
    end

    3.times do
      TestRunner.run.must_equal 'profile_class_methods OK'
    end

    File.exist?(filename).must_equal true
    file = File.read(filename)
    file.lines.count.must_equal 4
  end

  it 'Profile with summary' do
    SimpleProfiler.configure do |config|
      config.reporters = [SimpleProfiler::Reporters::Summary.new]
    end

    3.times do
      TestRunner.run.must_equal 'profile_class_methods OK'
    end

    summary = SimpleProfiler.reporters.first
    ranking = summary.ranking
    
    ranking.count.must_equal 1
    ranking[0][:klass].must_equal 'TestRunner'
    ranking[0][:method].must_equal :run
    ranking[0][:hits].must_equal 3
  end

end