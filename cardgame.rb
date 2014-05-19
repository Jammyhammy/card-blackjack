# Blackjack Card Game by AK/Jammyhammy
# Written in Ruby 2.0.0

# Pretty self-explanatory. A blackjack card game.
# Requires ruby 2.0.0, and executed in a cmdline terminal with "ruby cardgame.rb"
# Some features I'd like to add/change:
# 	Change the code of player, card, and add in a deck class so we can play different card games
#	Deploy as a web application using rails.
# 	Some refactoring for the nested conditional statements in the Blackjack class
#	Move VALUES to the blackjack class (to keep Card clean).
#	The dealer is extremely easy to beat. Up the difficulty by swapping cards.

# Sample Run is in sample.txt
#!/usr/bin/env ruby

class Card

	#	Have an enumerable to keep track of the card RANKS and each card's value. A is defined as an 11.
	RANKS = %w( 2 3 4 5 6 7 8 9 10 J Q K A )
	VALUES = [ 2,3,4,5,6,7,8,9,10,10,10,10,11 ]

	#	Member variables: rank, value
	attr_accessor :rank, :value

	#	Methods: initialize()
	def initialize()

		# Simulates drawing a card object at random. 
		# Doesn't follow a standard deck, a player can draw 5 aces.
		i = rand(13)
		@rank = RANKS[i]
		@value = VALUES[i]

	end
end
	
class Player

#	Member variables: hand, aces, name, hand_value
	attr_accessor :hand, :aces, :name, :hand_value
	
#	Methods: initialize(name), hit_card(), disp_cards(num_cards)
	def initialize(name)
		@name = name
		@hand = Array.new
		@aces = 0
		@hand_value = 0
	end	

	# hit_card(): Draws a card for the player.
	def hit_card()

	c = Card.new
		# Put the card into the hand.
		@hand << c
		
		# Keep track of aces, they can count either as 1 or 11
		if c.rank == "A"
			@aces = aces + 1
		end
		
		# Add to the player's hand_value
		@hand_value = hand_value + c.value
		
		# If the player's hand goes over 21, count an ace as a 1 instead of 11
		# as long as the player has aces.
		while aces > 0 && hand_value > 21
			@aces = aces - 1
			@hand_value = hand_value - 10
		end
	end
	
# 	disp_cards(num_cards): Displays num_cards number of cards face-up and the rest as ?.
#	If we specify a string such as "all", display all cards.
	def disp_cards(num_cards)
		print "#{name}'s cards: "
		
		# For each card in the hand, we either want to display it's rank or just print ?
		hand.each do |cards|
			# If a numberic arg was passed just display that many cards face-up.
			if num_cards.is_a? Numeric
				if num_cards > 0 
					print "#{cards.rank} "
					num_cards = num_cards - 1
				else
					print "? "
				end
			
			# If a string arg was passed, display all cards face-up.
			elsif num_cards.is_a? String
				print "#{cards.rank} "
			end
			
		end
		# Print out a newline.
		print "\n"	
	end
end

class Blackjack
#	Private variables: tokens 
	attr_accessor :tokens
#	Methods: initialize(tokens), game_main()

	def initialize(tokens)
		# Start the game with number of tokens specified in the tokens arg
		@tokens = tokens
	end
	
	def game_main()
		puts "Welcome to blackjack!"
		
		begin
			# Readability between different games on terminal.
			puts "---------------------------------------------------"
			
			# Create player and dealer.
			p1 = Player.new("Player 1")	
			dealer = Player.new("Dealer")		
			puts "Tokens: #{tokens} \nYou bet a token."
			@tokens = tokens - 1
			puts "---------------------------------------------------"			
			
			# Dealer will go first, draw 2 cards
			2.times {dealer.hit_card}
			
			# Dealer will keep on hitting until their hand is worth 18 or more.
			while dealer.hand_value < 18
				dealer.hit_card
			end
			
			# Display a card face-up and the rest face-down.
			dealer.disp_cards(1)
			
			# If dealer busted, set hand_value to 0.
			dealer.hand_value > 21 ? dealer.hand_value = 0 : nil
			
			# Begin player's turn.
			done = 0
			
			# Draw 2 cards for player.
			2.times {p1.hit_card}
			
			# Begin the loop for the player's turn.
			begin
				# Display all of the player's cards and their total value.
				p1.disp_cards("all")
				puts "#{p1.name}'s Hand Value: #{p1.hand_value}"
				
				# Prompt player whether to hit or hold.
				puts "Input h to hit, anything else to hold."
				i = gets.chomp
				
				# If player hits, draw a card, otherwise the turn's done.
				i == "h" ? p1.hit_card : done = 1
			end while done == 0
			
			# If player busted, their hand value is 0.
			p1.hand_value > 21 ? p1.hand_value = 0 : nil
			
			# Nested conditional loop to check who won. 
			# Tie case.
			if p1.hand_value == dealer.hand_value
				puts "Draw."
				@tokens = tokens + 1
				
			# Player won case.
			elsif p1.hand_value > dealer.hand_value
				puts "You win. You gain 2 tokens."
				@tokens = tokens + 2
			
			# Player lost case.
			elsif dealer.hand_value > p1.hand_value
				puts "You lose."
			end

			# If player or dealer busted, replace the 0 with Bust.
			p1.hand_value = p1.hand_value == 0 ? "Bust" : p1.hand_value
			dealer.hand_value =  dealer.hand_value == 0 ? "Bust" : dealer.hand_value
			
			# Display the actual values of the player and dealer's hand.
			puts "Your Value: #{p1.hand_value} vs. Dealer's Value: #{dealer.hand_value}"
		
			# Check if player has any more tokens to bet. If they do, ask if they want to play another round.
			if @tokens > 0
				puts "Press enter to play again or q + enter to quit. "
				input = gets.chomp	
				input == "q" ? @tokens = 0 : nil
			else
				puts "No more tokens left."
				puts "Would you like to flip the table?"
				flip_table = gets.chomp
				if flip_table == "yes"
					puts "You flip the table and walk out."
				end
			end
		end while tokens > 0
	end
end

# Initialize the blackjack game with 5 tokens initially.
cardgame = Blackjack.new(5)

# Start the app loop.
cardgame.game_main()