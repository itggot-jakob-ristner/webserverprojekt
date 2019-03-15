require_relative 'spec_helper'

feature 'Account_creation' do
    scenario 'creating a new user' do
        visit '/'
        expect(page).to have_content 'Please log in'
    end
end

