RSpec.describe SubscriptionsController do

  describe 'EDIT subscription' do
    it 'load a subscriptions for the edit form' do

      log_in_as_super_admin

      ActiveResource::HttpMock.respond_to do |mock|
        mock.post "/subscriptions.json",  [{"Authorization"=>"Basic c2NobGV1ZGVyOmlpMTIzNDU2Nzg5aWk=", "Content-Type"=>"application/json"}], {"email":"hello"}, 201
        mock.get  "/subscriptions/1.json", {"Authorization"=>"Basic c2NobGV1ZGVyOmlpMTIzNDU2Nzg5aWk=", "Accept"=>"application/json"}, {"id"=>191, "list_id"=>147, "email"=>"paz@localhost", "fingerprint"=>"52507B0163A8D9F0094FFE03B1A36F08069E55DE", "admin"=>false, "delivery_enabled"=>true, "created_at"=>"2017-05-05T10:50:25.630Z", "updated_at"=>"2017-05-16T10:45:29.840Z"}.to_json, 200
        mock.get  "/lists/147.json", {"Authorization"=>"Basic c2NobGV1ZGVyOmlpMTIzNDU2Nzg5aWk=", "Accept"=>"application/json"}, {"id"=>147, "updated_at"=>"2017-05-16T10:45:29.840Z"}.to_json, 200
      end

      get :edit, id: 1
      expect(response.code).to eq( "200" )

      expected_request = ActiveResource::Request.new(:get,
                                                     "/subscriptions/1.json",
                                                     {},
                                                     {
                                                       "Authorization"=>"Basic c2NobGV1ZGVyOmlpMTIzNDU2Nzg5aWk=",
                                                       "Accept"=>"application/json"
                                                     }
                                                     )

      expect(ActiveResource::HttpMock.requests).to include( expected_request )
      log_out
    end
  end

  describe 'CREATE subscription' do
    xit 'sends the correct params when creating a subscription' do

      log_in_as_super_admin

      ActiveResource::HttpMock.respond_to do |mock|
        mock.post "/subscriptions.json", {"Authorization"=>"Basic c2NobGV1ZGVyOmlpMTIzNDU2Nzg5aWk=", "Content-Type"=>"application/json"}, {}, 201,  {"Location" => "/subscriptions/1.json"}
        mock.get  "/subscriptions/1.json", {"Authorization"=>"Basic c2NobGV1ZGVyOmlpMTIzNDU2Nzg5aWk=", "Accept"=>"application/json"}, {"id"=>191, "list_id"=>147, "email"=>"paz@localhost", "fingerprint"=>"52507B0163A8D9F0094FFE03B1A36F08069E55DE", "admin"=>false, "delivery_enabled"=>true, "created_at"=>"2017-05-05T10:50:25.630Z", "updated_at"=>"2017-05-16T10:45:29.840Z"}.to_json, 200
        mock.get  "/lists/147.json", {"Authorization"=>"Basic c2NobGV1ZGVyOmlpMTIzNDU2Nzg5aWk=", "Accept"=>"application/json"}, {"id"=>147, "updated_at"=>"2017-05-16T10:45:29.840Z"}.to_json, 200
      end

      post :create, {subscription: {email: 'hello@example.org', list_id: 147, admin: 1, delivery_enabled: 1}}

      expect(response.code).to eq( "200" )

      expected_request = ActiveResource::Request.new(:post,
                                                     "/subscriptions/1.json",
                                                     {},
                                                     {
                                                       "Authorization"=>"Basic c2NobGV1ZGVyOmlpMTIzNDU2Nzg5aWk=",
                                                       "Accept"=>"application/json"
                                                     }
                                                     )

      expect(ActiveResource::HttpMock.requests).to include( expected_request )
      log_out
    end
  end

end
