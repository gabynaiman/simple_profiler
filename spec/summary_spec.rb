require 'minitest_helper'

describe 'Summary' do

  let(:events) do
    [
      SimpleProfiler::Event.new(Struct, :class, :run, [], Time.now, Time.now+1, 5, 10),
      SimpleProfiler::Event.new(Struct, :class, :run, [], Time.now, Time.now+1, 10, 15),
      SimpleProfiler::Event.new(Struct, :instance, :run, [], Time.now, Time.now+1, 15, 16)
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
    ranking[1][:klass].must_equal 'Struct'
    ranking[1][:target].must_equal :instance
    ranking[1][:method].must_equal :run
    ranking[1][:hits].must_equal 1
  end

end