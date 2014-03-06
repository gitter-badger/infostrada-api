module Infostrada
  # The class containing the methods used by the command line tool.
  class Commands
    class << self
      attr_accessor :selected_edition

      def selected_edition_string
        if @selected_edition
          "#{@selected_edition.competition_name} #{@selected_edition.season}"
        end
      end

      def editions
        get_editions.each do |edition|
          print_id_col(edition.id)
          print "#{edition.competition_name} #{edition.season}\n".bold
        end
      end

      def select_edition(edition_id)
        get_editions
        @selected_edition = @editions.find { |edition| edition.id == edition_id.to_i }
      end

      def show_teams
        edition_teams = @selected_edition.teams
        edition_teams.each do |team|
          print_id_col(team.id)
          print "#{team.name}\n".bold
        end
      end

      def show_squad(team_id)
        players = Squad.where(edition_id: @selected_edition.id, team_id: team_id)
        players.each do |player|
          print_id_col(player.person_id)
          print "#{player.function[0]} ".bold.red
          print "#{player.name}\n".bold
        end
      end

      def show_player(person_id)
        person = PersonInfo.where(person_id: person_id)
        nickname = person.nickname

        print_person(person, nickname)
      end

      private

      def print_person(person, nickname)
        print "#{person.public_name}".bold.yellow
        print nickname ? " (#{nickname})\n" : "\n"

        puts "Date of birth: #{person.birthdate}
                     Weight: #{person.weight}
                     Height: #{person.height}
                     Born: #{person.birth_city} / #{person.birth_country}"
      end

      def print_id_col(id)
        id = sprintf('%9s', id)
        print '[' << "#{id}".yellow << '] '
      end

      def get_editions
        @editions ||= Edition.all
      end

      def get_edition(edition_id)
        get_editions.each do |edition|
          return edition if edition.id == edition_id.to_i
        end
      end
    end
  end
end