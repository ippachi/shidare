require_relative './support/user/user_registration'

RSpec.describe Shidare::Registration do
  describe '#sign_up_as' do
    let(:action) { SignupAs.new }

    context 'vaild parameter' do
      let(:params) do
        { user: {name: 'test_name', email: 'test@example.com', password: 'password' } }
      end

      it 'returns 200 and location is root' do
        response = action.call(params)
        expect(response[0]).to eq 200
      end
    end
  end
end
