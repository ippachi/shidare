require 'hanami/controller'
require 'hanami/action/session'
require 'shidare'
require 'setup'

RSpec.describe Shidare do
  let(:params) { {id: 1, email: 'user@example.com'} }
  describe Shidare::Authentication do

    describe '#login_as' do
      let(:action) { Login.new }
      it 'success' do
        expect(action.call(params)[0]).to eq 200
      end
    end

    describe '#logout_from' do
      let(:action) { Logout.new }
      it 'success' do
        expect(action.call(params)[0]).to eq 200
      end
    end

    describe '#current_user' do
      pending
    end
  end
end
