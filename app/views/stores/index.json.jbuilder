json.array!(@stores) do |store|
  json.extract! store, :id, :access_token, :name
  json.url store_url(store, format: :json)
end
