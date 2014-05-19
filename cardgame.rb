# Card Game Program
class Card
#	Private variables: @ranks
	RANKS = %w( 2 3 4 5 6 7 8 9 10 J Q K A )
	VALUES = [ 2,3,4,5,6,7,8,9,10,10,10,10,11 ]
	attr_accessor :rank, :value
#	Methods: init(id)
	def initialize()
		i = rand(13)
		@rank = RANKS[i]
		@value = VALUES[i]		
	end
end
	
class Player

#	Private variables: hand, aces, value, name	
	attr_accessor :hand, :aces, :name, :hand_value
	
#	Methods: init, hit, disp_hand
	def initialize(name)
		@name = name
		@hand = Array.new
		@aces = 0
		@hand_value = 0
	end	
	
	def hit_card()
		c = Card.new
		@hand << c
		if c.rank == "A"
			@aces = aces + 1
		end
		@hand_value = hand_value + c.value
		while aces > 0 && hand_value > 21
			@aces = aces - 1
			@hand_value = hand_value - 10
		end
	end
# 	Displays num_cards cards and the rest as ?, else all cards.	
	def disp_cards(num_cards)
		print "#{name}'s cards: "
		hand.each do |cards|
			if num_cards.is_a? Numeric
				if num_cards > 0 
					print "#{cards.rank} "
					num_cards = num_cards - 1
				else
					print "? "
				end
			elsif num_cards.is_a? String
				print "#{cards.rank} "
			end
		end
		print "\n"	
	end
end

class Blackjack
#	Private variables: 
	attr_accessor :tokens
#	Methods: 
	def initialize(tokens)
		@tokens = tokens
	end
	
	def game_main()
		puts "Welcome to blackjack!"

		begin
			p1 = Player.new("Player 1")	
			dealer = Player.new("Dealer")		
			puts "Tokens: #{tokens} \nYou bet a token."
			
			2.times {dealer.hit_card}
			while dealer.hand_value < 18
				dealer.hit_card
			end
			dealer.disp_cards(1)
			dealer.hand_value > 21 ? dealer.hand_value = 0 : nil
			
			done = 0
			2.times {p1.hit_card}
			begin
				p1.disp_cards("all")
				puts "#{p1.name}'s Hand Value: #{p1.hand_value}"
				puts "Input H to hit, anything else to hold."
				i = gets.chomp
				i == "H" ? p1.hit_card : done = 1
			end while done == 0
			p1.hand_value > 21 ? p1.hand_value = 0 : nil
			
			#Precedence:  check for tie -> compare for higher number
			
			if p1.hand_value == dealer.hand_value
				puts "Draw."
			elsif p1.hand_value > dealer.hand_value
				puts "You win. You gain 2 tokens."
				@tokens = tokens + 2
			elsif dealer.hand_value > p1.hand_value
				puts "You lose."
			end

			
			p1.hand_value = p1.hand_value == 0 ? "Bust" : p1.hand_value
			dealer.hand_value =  dealer.hand_value == 0 ? "Bust" : dealer.hand_value
			puts "Your Value: #{p1.hand_value} vs. Dealer's Value: #{dealer.hand_value}"
		
			
			puts "Input Y to play again."
			input = gets.chomp	
			input == "Y" ? @tokens = tokens - 1 : @tokens = 0
		
		end while tokens > 0
	
	end
end

cardgame = Blackjack.new(5)
cardgame.game_main()