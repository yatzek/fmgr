# == Schema Information
#
# Table name: game_definitions
#
#  id         :integer          not null, primary key
#  day        :string(255)
#  time       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  disabled   :boolean
#

require 'chronic'

class GameDefinition < ActiveRecord::Base

  validates :day, :time, :presence => true
  validates :time, :uniqueness => {:scope => :day}
  attr_default :disabled, false

  CREATE_GAME_BEFORE_DAYS = 5 * 24 * 60 * 60

  def next_game_time
    Chronic.parse "next #{day} #{time}"
  end

  # game instance creation
  # run daily
  def self.create_games(include_disabled = false)
    game_definitions = GameDefinition.where(include_disabled ? {} : {disabled: false})

    game_definitions.each do |game_definition|
      now = Time.now
      next_game_time = game_definition.next_game_time

      # if less than 5 days to the next game
      if now + CREATE_GAME_BEFORE_DAYS > next_game_time

        game = Game.where(game_definition_id: game_definition.id).last
        # if next game instance does not exist yet
        unless game && game.time == next_game_time
          Game.create!(game_definition: game_definition, time: next_game_time)
        end

      end
    end

  end


end
