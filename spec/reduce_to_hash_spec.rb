require 'reduce_to_hash'

class TestUser
  attr_accessor :id
  attr_accessor :email

  def initialize(id, email)
    @id = id
    @email = email
  end
end

RSpec.describe Array, '#reduce_to_hash' do
  context "given a simple block" do
    it 'maps every element using the block' do
      arr = [{id: 1, email: 'a@my.com'}, {id: 2, email: 'b@my.com'}]
      hash = arr.reduce_to_hash { |u| {u[:email].gsub(/@.*/, '') => "XX-#{u[:id]}"} }
      expect(hash).to eq({'a' => 'XX-1', 'b' => 'XX-2'})
    end
  end

  context "given a conditional block" do
    it 'maps specific elements using the block' do
      arr = [
          {id: 1, email: 'a@my.com'},
          {id: 2, email: 'b@my.com'}
      ]
      hash = arr.reduce_to_hash do |u|
        {u[:email].gsub(/@.*/, '') => "XX-#{u[:id]}"} unless (u[:id] % 2).zero?
      end
      expect(hash).to eq({'a' => 'XX-1'})
    end
  end

  context "given a symbol" do
    context "operating on non-hash objects" do
      it 'uses the symbol as a method to extract the key, and uses the entire object as the value' do
        arr = [
            u1 = TestUser.new(1, 'a@my.com'),
            u2 = TestUser.new(2, 'b@my.com')
        ]
        hash = arr.reduce_to_hash :email
        expect(hash).to eq({
                               u1.email => u1,
                               u2.email => u2
                           })
      end
    end

    context "operating on hash objects" do
      it 'uses the symbol as a key into the hash, and uses the entire hash as the value' do
        arr = [
            {id: 1, email: 'a@my.com'},
            {id: 2, email: 'b@my.com'}
        ]
        hash = arr.reduce_to_hash :email
        expect(hash).to eq({
                               arr[0][:email] => arr[0],
                               arr[1][:email] => arr[1]
                           })
      end
    end
  end

  context "given a hash" do
    context "operating on hash objects" do
      it "uses [] on both sides of the hash" do
        arr = [
            {id: 1, email: 'a@my.com'},
            {id: 2, email: 'b@my.com'}
        ]
        hash = arr.reduce_to_hash :email => :id
        expect(hash).to eq({
                               arr[0][:email] => arr[0][:id],
                               arr[1][:email] => arr[1][:id]
                           })
      end
    end

    context "operating on non-hash objects" do
      it "uses send() on both sides of the hash" do
        arr = [
            u1 = TestUser.new(1, 'a@my.com'),
            u2 = TestUser.new(2, 'b@my.com')
        ]
        hash = arr.reduce_to_hash :email => :id
        expect(hash).to eq({
                               arr[0].email => arr[0].id,
                               arr[1].email => arr[1].id
                           })
      end
    end

  end
end