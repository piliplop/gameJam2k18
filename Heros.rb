require_relative 'Personnage'
require_relative 'Gun'

class Heros < Personnage
  attr_reader :img, :gun

  # Intensité initiale du jump
  # (Il montera de GRAVITY_JUMP + GRAVITY_JUMP-1 + ... + 1 pixels)
  GRAVITY_JUMP = -25

  # Constantes de classe
  NB_FRAME_JUMP = 30

  SIZE_X = 37
  SIZE_Y = 50

  SPRITE_GAUCHE = ["resources/sprites/ChevalierG1.png","resources/sprites/ChevalierG2.png"]
  SPRITE_DROITE = ["resources/sprites/ChevalierD1.png","resources/sprites/ChevalierD2.png"]

  VELOCITY_H = 8

  def initialize map, x, y
    @sizeX = SIZE_X
    @sizeY = SIZE_Y

    @vX = 0
    @vY = 0
    @frameJump = 0

    # Création du gun du menz
    @gun = Gun.new

    super map, x, y, VELOCITY_H, @sizeX, @sizeY, SPRITE_GAUCHE, SPRITE_DROITE
  end

  def draw    
    super

    # Ajout d'un recul après le tir
    if @gun.pullBack then
      @vX -= @tourneVersDroite ? @gun.getPullBack : -@gun.getPullBack
    end
    @gun.draw @x,@y,@tourneVersDroite
  end

  def jump
    if !@jumping
      @jumping = true
      @vY = GRAVITY_JUMP
    end
  end

  # Tir du héros
  def shoot
    @gun.shoot @x,@y,@tourneVersDroite
  end

  # Experimental : changer d'arme
  def switchWeapon
    nb = rand(1..Gun.NB_WEAPONS-1)
    while (@gun.allGuns[nb][0] == @gun.currentGun[0])
      nb = rand(1..Gun.NB_WEAPONS-1)
    end
    @gun.setWeapon(nb)

    return nb
  end

  def self.SIZE
    return [SIZE_X, SIZE_Y]
  end

  def move
    super
    @vX = 0
    # Saut
    if @vY < 0
      (arrondiN(-@vY)).times { if @map.obstAt?([@x,@y-1]) then @vY = 0 else @y -= 1 end }
    end
  end
end