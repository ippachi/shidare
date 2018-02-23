require_relative './support/user/user_registration'

RSpec.describe Shidare::Registration do
  describe '#signup_as' do
    let(:action) { SignupAs.new }
    let(:params) { { user: { name: 'test_name', email: 'test@example.com', password: 'password' } } }
    context 'vaild parameter' do
      it 'returns 200' do
        response = action.call(params)
        expect(response[0]).to eq 200
      end
    end
  end
end
