# require 'spec_helper'
# describe MovieService do
#   
#   context "When we pass sessions to build" do
#     context "When there are future sessions" do
#       it "should find the next session for each movie" do
#         session_1 = double("session1",start_time: 1.day.from_now.to_s, movie_id:1)
#         session_2 = double("session2",start_time: 3.day.from_now.to_s, movie_id:1)
#         session_3 = double("session3",start_time: 2.day.from_now.to_s, movie_id:2)
#         session_4 = double("session4",start_time: 1.day.from_now.to_s, movie_id:2)
#         movie_sessions = [session_1,session_2,session_3,session_4]
#         movies_json = [
#           {id:1,title: "Movie1",image_url: "example1.jpg",synopsis: "test",classification: "M" },
#           {id:2,title: "Movie2",image_url: "example2.jpg",synopsis: "test",classification: "G"}
#         ]
#         mock_response = double(:body => movies_json)
#         movies = MovieService.build(mock_response, movie_sessions)
#         expect(movies[0].next_session).to eql(session_1)
#         expect(movies[1].next_session).to eql(session_4)
#       end
#     end
#   end
# end
