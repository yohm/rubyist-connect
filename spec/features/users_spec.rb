require 'rails_helper'

feature 'Users spec' do
  scenario 'ログイン - 登録情報変更 - ユーザ検索 - ログアウトができること' do
    sign_in_as_new_user

    expect(page).to have_content 'ユーザ情報の更新'

    fill_in '自己紹介文', with: 'よろしくお願いします。'
    fill_in 'Twitter ユーザ名', with: 'alice-twitter'
    fill_in 'Facebook ユーザ名', with: 'alice-facebook'
    fill_in 'Qiita ユーザ名', with: 'alice-qiita'
    fill_in '名前', with: 'ありす'
    click_on '更新'

    expect(page).to have_content 'ありす'
    expect(page).to have_content 'よろしくお願いします'
    # TODO TwitterやFacebookのリンク存在チェックもしたい

    within '.navbar form' do
      fill_in 'User Search', with: 'あり'
      find('.btn').click
    end
    expect(page).to have_content 'ありす'

    within '.navbar form' do
      fill_in 'User Search', with: 'facebook'
      find('.btn').click
    end
    expect(page).to have_content 'ありす'

    within '.navbar form' do
      fill_in 'User Search', with: 'twitter'
      find('.btn').click
    end
    expect(page).to have_content 'ありす'

    within '.navbar form' do
      fill_in 'User Search', with: 'qiita'
      find('.btn').click
    end
    expect(page).to have_content 'ありす'

    within '.navbar form' do
      fill_in 'User Search', with: '12345'
      find('.btn').click
    end
    expect(page).to_not have_content 'ありす'

    click_on 'Sign out'
    expect(page).to have_content 'Rubyist は、すぐそこに'
  end

  scenario '退会ができること' do
    sign_in_as_new_user

    expect(page).to have_content 'ユーザ情報の更新'

    expect{click_link '退会'}.to change{User.count}.by(-1)

    expect(page).to have_content 'Rubyist は、すぐそこに'
  end

  scenario '存在しないユーザーを表示しようとした場合はNot foundとすること' do
    sign_in_as_new_user

    expect{visit user_path('alice')}.to_not raise_error
    expect{visit user_path('Tom')}.to raise_error ActiveRecord::RecordNotFound
  end
end
