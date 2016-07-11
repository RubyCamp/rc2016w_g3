require 'dxruby'
require 'smalrubot'
require_relative 'background'


Window.caption = "毎日鞦韆"
Window.width   = 800
Window.height  = 600


board = Smalrubot::Board.new(Smalrubot::TxRx::Serial.new)

$scr = {player1: 0, player2: 0, player3: 0, player4: 0}
$tp = 0
bgm = Sound.new("tamco03.mid")
ts = Sound.new("title.wav")
se1 = Sound.new("swing.wav")
god = Sound.new("god.wav")
suta = Sound.new("tyakuchi.wav")
$junni = Image.load("junni.png")
tf = 0
gf = 0
sf = 0

4.times do |i|
	sleep 0.5

	si = 179
	r = 95
	shake_log = 0
	cnt = 0
	cnt2 = 0
	omg = 0
	v0 = 0
	$bgimage = Image.load("bg5_#{i}.png")
	image = Image.load("c_ningen.png")
	start = Image.load("title.png")
    $button = 0
	$push = 0
	t = 0
	font = Font.new(80)
	font1 = Font.new(35)
	font2 = Font.new(45)
	vx = 0

	haikei = []

	Window.loop do
		
		if $tp == 0

			Window.loop do
				if tf == 0
					ts.play
					tf = 1
				end
				Window.draw(0,0,start)
				$tp = board.digital_read(3)
				if $tp == 1
					ts.stop
					break
				end
			end	
			bgm.play
			sleep 0.5
		end

		Window.loop do

			if $push == 1
				break
			end

			Window.draw(0,0,$bgimage,z=0) 
			$rad = (si * Math::PI / 180.0)
			$x = r * Math.cos($rad) + 105
			$y = r * Math.sin($rad) + 390
			v0 = (2*r)**(1/2.0)*omg*0.15
			shake = board.digital_read(2)
			$push = board.digital_read(3)
			if omg >= 8 && $x <= 11
				se1.play
			end
	 			
			if shake_log != shake
	 			shake_log = shake
	 			cnt += 1
	 			omg += 0.00005*cnt**2
			end
			if omg >= 20
	 			omg = 20	
	 		end
			si -= omg

			
			Window.draw_line(142.5,440,$x+37.5,$y+50,C_BLACK,z=1)
	 		Window.draw_rot($x,$y,image,si - 90,37.5,50)
	 		Window.draw_font(550,65,"0m",font,{color:C_BLACK,edge:true})
	 		Window.draw_font(5,5,"player#{i + 1}",font1,{color:[255,115,20],edge:true})
			sleep 0.001
	 	end

	 	if $button == 1
			break
		end
	 		
	 	
		vx = v0 * Math.cos($rad - Math::PI/2.0)
		vy = v0 * Math.sin($rad - Math::PI/2.0) + 0.1 * t

		if cnt2 == 0
			haikei << Background.new(0, 0, vx,"bg5_#{i}.png" )
			haikei << Background.new(haikei[0].image.width, 0,vx, 'bg3.png' , true)
			cnt2 = 1
		end
		Sprite.update(haikei)
	 	Sprite.draw(haikei)
		t += 1
		$x += vx
		$y += vy

		if $x >= Window.width / 2
			Window.draw_rot(Window.width / 2,$y,image,si - 90)
		else
			Window.draw_rot($x,$y,image,si - 90)
		end

		si -= 10
		$x1 = $x.to_i 
		Window.draw_font(550,65,"#{( $x1 - 75 )/15}m",font,{color:C_BLACK,edge:true})
		Window.draw_font(5,5,"player#{i + 1}",font1,{color:[255,115,20],edge:true})

		if ( $y >= 450 ) && vy >= 0
			Window.loop do
				Sprite.draw(haikei)

				if ( ( ( $x1 - 75 ) / 15 ) / 50 ) < 0
					life = Image.load("life0.png")
					life.set_color_key([255, 255, 255])
				elsif ( ( $x1 - 75 ) / 15 ) >= 1050
					life = Image.load("life23.png")
				else
					p = ( ( ( $x1 - 75 ) / 15 ) / 50 ) + 1
					life = Image.load("life#{p}.png")
					life.set_color_key([255, 255, 255])
				end
				if $x >= Window.width / 2

					if ( ( $x1 - 75 ) / 15 ) >= 1050
						bgm.stop
						if gf == 0
							god.play
							gf = 1
						end
						Window.draw_rot(0,0,life,0)
						if sf == 0
							suta.play
							sf = 1
						end
					else

						Window.draw_rot(Window.width / 2,450,life,0)
						if sf == 0
							suta.play
							sf = 1
						end
					end
					Window.draw_font(Window.width / 2,400,"#{( ( $x1 - 75 ) / 15 ) / 10}歳",font2,{color:C_BLACK,edge:true})
				else
					Window.draw_rot($x,450,life,0)
					if sf == 0
						suta.play
						sf = 1
					end
					Window.draw_font($x,400,"#{( ( $x1 - 75 ) / 15 ) / 10}歳",font2,{color:C_BLACK,edge:true})
				end
				Window.draw_font(550,65,"#{( $x1 - 75 ) / 15}m",font,{color:C_BLACK,edge:true})
				Window.draw_font(5,5,"player#{i + 1}",font1,{color:[255,115,20],edge:true})
				$button = board.digital_read(3)
				if $button == 1
					god.stop
					if gf == 1
						bgm.play
						gf = 0
					end
					sf = 0
					break
				end
			end

		end
	end
	$scr[:"player#{i + 1}"] = ( ( $x1 - 75 ) / 15 )
end
sleep 0.5
$scr = $scr.sort_by {|a, b| -b }
font = Font.new(30)
Window.loop do
	syuryo = board.digital_read(3)
	if syuryo == 1
		break
	end
	Window.draw(0,0,$bgimage,z=0)
	Window.draw(200,180,$junni,z=1)
	Window.draw_font(320,215,"#{$scr[0][0].to_s}\n #{$scr[0][1]}m",font,{color:C_BLACK,edge:true})
	Window.draw_font(225,330,"#{$scr[1][0].to_s}\n #{$scr[1][1]}m",font,{color:C_BLACK,edge:true})
	Window.draw_font(425,345,"#{$scr[2][0].to_s}\n #{$scr[2][1]}m",font,{color:C_BLACK,edge:true})
	Window.draw_font(570,440,"#{$scr[3][0].to_s}\n #{$scr[3][1]}m",font,{color:C_BLACK,edge:true})
end