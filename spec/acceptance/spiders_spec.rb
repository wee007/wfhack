require 'acceptance_helper'

feature 'Spiders' do
  include_context 'spiders'

  describe 'Major customer console pages' do
    scenario 'are responding on the network as expected' do
      major_console_pages.each do |p|
        log "#{p[:name]}: #{p[:url]}"
        visit p[:url]
        expect(page).to have_content p[:content]
      end
    end
  end
end