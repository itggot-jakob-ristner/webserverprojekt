require_relative 'spec_helper'

feature 'Account' do
    scenario 'creating a new user' do
        visit '/register'
        expect(page).to have_button('Log in')
        expect(page).to have_button('Register')

        within '//[@id="register"]' do
            fill_in 'first_name', with: 'John'
            fill_in 'last_name', with: 'Smith'
            fill_in 'email', with: 'john.smith@useremail.com'
            fill_in 'password', with: 'userpassword'
            click_button 'Register'
        end
    end

    scenario 'logging in' do
        visit '/'
        expect(page).to have_content('Please log in')
        within '//[@id="login"]' do
            fill_in 'email', with: 'user1@gmail.com'
            fill_in 'password', with: 'user1p'
            click_button 'Log in'
        end
    end
end

feature 'Tasks' do
    before :each do
        visit '/'
        expect(page).to have_content('Please log in')
        within '//[@id="login"]' do
            fill_in 'email', with: 'user1@gmail.com'
            fill_in 'password', with: 'user1p'
            click_button 'Log in'
        end
    end

    scenario 'creating task' do
        visit '/tasks'
        expect(page).not_to have_content('task1')
        within '//[@id="task_add"]' do
            fill_in 'name', with: 'task1'
            fill_in 'date_due', with: '2019-03-26'
            click_button 'Add Task'
        end
        expect(page).to have_content('task1')
    end
end
