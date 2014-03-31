require 'spec_helper'

describe "Micropost pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    let(:user2) { FactoryGirl.create(:user) }
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as wrong user" do
      before { sign_in user2 }
      before { visit user_path(user) }

      it { should_not have_link("delete") }
    end
  end

  describe "pagination" do
    after(:all) { user.microposts.delete_all unless user.microposts.nil? }
    after(:all) { user.delete }
    it "should paginate the feed" do
     40.times { FactoryGirl.create(:micropost, user: user) }
     visit root_path
     expect(page).to have_selector('div.pagination')
    end
  end
end