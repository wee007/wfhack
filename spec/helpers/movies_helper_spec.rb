require 'spec_helper'
describe MoviesHelper do

  context "#days" do

    describe "When we want to show 5 days in to the future for movies" do
      describe "When no date has been chosen" do
        before(:each) do
          @days = days(5.days.from_now.to_s, 'bondijunction')
          @days_as_document = @days.map{|day| HTML::Document.new(day).root}
        end
        it "returns the days" do
          assert_select(@days_as_document[0], 'a', text: "Today")
          assert_select(@days_as_document[1], 'a', text: "Tomorrow")
          assert_select(@days_as_document[2], 'a', text: 2.days.from_now.localtime.strftime("%A %-d"))
          assert_select(@days_as_document[3], 'a', text: 3.days.from_now.localtime.strftime("%A %-d"))
          assert_select(@days_as_document[4], 'a', text: 4.days.from_now.localtime.strftime("%A %-d"))
        end
        it "should link to the movies index page" do
          5.times do |i|
            assert_select(@days_as_document[i], 'a', attributes: {href: centre_movies_path('bondijunction', date: i.days.from_now.localtime.strftime('%d-%m-%Y'))})
          end
        end
        it "should mark today as chosen by default" do
          assert_select(@days_as_document[0], 'a', attributes: {class: 'selected'}, text: "Today")
          assert_select(@days_as_document[1], 'a', attributes: {class: ''}, text: "Tomorrow")
        end
      end
      describe "When a date has been chosen" do
        before(:each) do
          @days = days(5.days.from_now.to_s, 'bondijunction', 1.days.from_now.localtime.strftime("%A %-d"))
          @days_as_document = @days.map{|day| HTML::Document.new(day).root}
        end
        it "should mark the chosen day as selected" do
          assert_select(@days_as_document[0], 'a', attributes: {class: ''}, text: "Today")
          assert_select(@days_as_document[1], 'a', attributes: {class: 'selected'}, text: "Tomorrow")
        end
      end
    end
    
    describe "When we want to show 5 days in to the future for movies" do
      before(:each) do
        @days = days(5.days.from_now.to_s, 'bondijunction', nil, '557')
        @days_as_document = @days.map{|day| HTML::Document.new(day).root}
      end
      it "should link to the movie show page" do
        5.times do |i|
          assert_select(@days_as_document[i], 'a', attributes: {href: centre_movie_path('bondijunction', '557', date: i.days.from_now.localtime.strftime('%d-%m-%Y'))})
        end
      end
    end
  end

end
