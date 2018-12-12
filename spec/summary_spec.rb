require 'minitest_helper'

describe 'Summary' do

  let(:events) do
    now = Time.now

    [
      SimpleProfiler::Event.new(Struct, :class, :run, [], now, now+1, 5, 10),
      SimpleProfiler::Event.new(Struct, :class, :run, [], now, now+2, 10, 12),
      SimpleProfiler::Event.new(Struct, :instance, :run, [], now, now+1, 15, 20)
    ]
  end
  
  it 'Accumulate events' do
    summary = SimpleProfiler::Reporters::Summary.new
    events.each do |event|
      summary.notify event
    end

    summary.events.must_equal events
  end

  it 'Ranking' do
    summary = SimpleProfiler::Reporters::Summary.new
    events.each do |event|
      summary.notify event
    end
    ranking = summary.ranking(sort_by: :hits)

    ranking.count.must_equal 2

    ranking[0][:klass].must_equal 'Struct'
    ranking[0][:target].must_equal :class
    ranking[0][:method].must_equal :run
    ranking[0][:hits].must_equal 2
    ranking[0][:total_time].must_equal 3.0
    ranking[0][:avg_time].must_equal 1.5
    ranking[0][:variance_time].must_equal 0.5
    ranking[0][:total_memory].must_equal 7
    ranking[0][:avg_memory].must_equal 3.5
    ranking[0][:variance_memory].must_equal 4.5

    ranking[1][:klass].must_equal 'Struct'
    ranking[1][:target].must_equal :instance
    ranking[1][:method].must_equal :run
    ranking[1][:hits].must_equal 1
    ranking[1][:total_time].must_equal 1
    ranking[1][:avg_time].must_equal 1
    ranking[1][:variance_time].must_equal 0
    ranking[1][:total_memory].must_equal 5
    ranking[1][:avg_memory].must_equal 5
    ranking[1][:variance_memory].must_equal 0
  end

end