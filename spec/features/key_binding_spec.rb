require 'spec_helper'

describe 'key_binding', type: :feature, js: true do

  before(:each) do
    visit images_path
    page.first('a[href="/assets/1-full.png"]').click
    page.should have_css('img.current') # Wait for loading before testing
  end

  # TODO: Not working as expected, works with every key (:Enter, :Left, etc.)
  it 'hides image when escape key is sent' do
    page.should have_css('div#hermitage div#close-button')
    page.find("html").native.send_keys(:Escape)
    page.should_not have_css('div#hermitage div#close-button')
  end

  it 'shows next image when right key is sent' do
    page.find("html").native.send_keys(:Right)
    page.should have_no_css('img[src="/assets/1-full.png"]')
    page.should have_css('img[src="/assets/2-full.png"]')
    page.all('img.current').length.should == 1
  end

  it 'shows previous image when left key is sent' do
    page.find("html").native.send_keys(:Left)
    page.should have_no_css('img[src="/assets/1-full.png"]')
    page.should have_css('img[src="/assets/0-full.png"]')
    page.all('img.current').length.should == 1
  end
end
