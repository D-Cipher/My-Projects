import random
import math
import kivy

from kivy.app import App
from kivy.uix.widget import Widget
from kivy.uix.button import Button
from kivy.graphics import Color, Rectangle, Line
from kivy.core.window import Window
from kivy.loader import Loader
from kivy.uix.image import Image
from kivy.core.image import Image as CoreImage
from kivy.uix.label import Label
from kivy.logger import Logger
from kivy.metrics import Metrics

###============Helper Functions=============
def dist_formula(p, q):
    #Distance Formula
    return math.sqrt((p[0] - q[0]) ** 2 + (p[1] - q[1]) ** 2)

###============Define Class Objects=============
class BG_Sprite(Image):
    """
    Creates the background image for the Canva which the game classes will be drawn on.
    Made to be adjusted for Iphone screen sizes. (Background image of Flappy Birds)
    """
    def __init__(self, **kwargs):
        #super(BG_Sprite, self).__init__(**kwargs) #Does not Account for Screen Adjustment
        #self.size = self.texture_size #Does not Account for Screen Adjustment
        #self.size = (200,200) #for testing ONLY

        super(BG_Sprite, self).__init__(allow_stretch=True, **kwargs)
        self.texture.mag_filter = 'nearest'
        w, h = self.texture_size
        self.size = (PARAMS.scale * w, PARAMS.scale * h)


class Card(Widget):
    """
    Creates the card class object and all of it's properties.
    Takes coordinates of the card and position and draws the card on the canvas.

    Uses a texture lookup from a sprite sheet. The texture is lookup based on the coordinates,
    then uses ".texture.get_region" to set as the texture of a Rectangle.
    """
    def __init__(self, col_input = 0, row_input = 0, pos = (100,100), theme = "emj", select = False,
                 eliminate = False, secret_card = False, back = True, lifespan = None,
                 animated = False, radius = 45):
        super(Card, self).__init__()

        #Image Specs
        self.card_center = (16, 386)
        self.card_size = (80, 85)

        #Object Properties
        self.zoom = .65  * PARAMS.scale #Adjusted size: (56, 59.5)
        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)
        self.obj_coord = [self.pos[0] +(self.card_size[0]*self.zoom)/2,
                          self.pos[1] +(self.card_size[1]*self.zoom)/2]

        self.c_col = col_input
        self.c_row = row_input

        self.select = select
        self.eliminate = eliminate
        self.radius = radius

    def draw(self):
        #Card Locator
        card_column = range(17)
        card_row = range(5)
        card_loc = (self.card_center[0] + self.card_size[0] * card_column.index(self.c_col)
                    + math.floor((card_column.index(self.c_col)+1)/2),
                    self.card_center[1] - self.card_size[1] * card_row.index(self.c_row))

        #Texture Specs
        self.texture = CoreImage("images/theme_emoji.jpg"
                                 ).texture.get_region(card_loc[0], card_loc[1],
                                                      self.card_size[0], self.card_size[1])
        self.size = (self.card_size[0]*self.zoom, self.card_size[1]*self.zoom)

        #Card Draw
        if self.select == False:
            self.rect_bg = Rectangle(
                pos=(self.pos[0]-(self.size[0]/10),self.pos[1]-(self.size[0]/10)),
                size=(self.size[0]*1.2,self.size[1]*1.2), color=Color(.6, 1, .5, .7))

            self.rect_bg = Rectangle(
                pos=self.pos, size=self.size, texture=self.texture, color=Color(1, 1, 1, 1))

        elif self.select == True:
            self.rect_bg = Rectangle(
                pos=(self.pos[0]-(self.size[0]/10),self.pos[1]-(self.size[0]/10)),
                size=(self.size[0]*1.2,self.size[1]*1.2), color=Color(0.1, 0.1, .1, 1))

            self.rect_bg = Rectangle(
                pos=self.pos, size=self.size, texture=self.texture, color=Color(1, 1, 1, 1))

        #Line(circle=(self.pos[0]+self.size[0]/2, self.pos[1]+self.size[1]/2, 45)) #for testing

        #-----------------NOTES-----------------------
        #Colors for Each Card State:
        #Normal: Light green = Color(.6, 1, .5, .7), White = Color(1, 1, 1, 1)
        #Selected: Black = Color(0.1, 0.1, .1, 1), White = Color(1, 1, 1, 1)
        #Eliminated: Transparent = Color(.5, .5, .5, .5), Transparent = Color(1, 1, 1, .5))
        #Alternatively Eliminated: Transparent = Color(.5, .5, .5, .5),  Grey overlay = Color(.6, .6, .6, 1)
        #Secret Card Revealed: Red = Color(.8, 0, 0, 1), Grey overlay = Color(.6, .6, .6, 1)
        #Color(1, .5, .5, 1)

    def selectable(self, click_pos):
        self.select_logic = (dist_formula(self.obj_coord, click_pos.pos) < self.radius
                             and self.select == False and self.eliminate == False)
        if self.select_logic == True:
            return True
        else:
            return False

    def select_click(self, click_pos = None):
        if click_pos == None:
            self.select = True
        else:
            if self.select_logic == True:
                self.select = True
            else:
                pass

    def deselectable(self, click_pos):
        self.deselect_logic = (dist_formula(self.obj_coord, click_pos.pos) < self.radius
                             and self.select == True)
        if self.deselect_logic == True:
            return True
        else:
            return False

    def deselect_click(self, click_pos = None):
        if click_pos == None:
            self.select = False
        else:
            if self.deselect_logic == True:
                self.select = False
            else:
                pass

class Guess_Clicker(object):
    """
    Creates multiple Card objects. Takes a list and creates
    a list of objects and puts them into play.
    """
    def __init__(self, cards_inplay):
        self.cards_inplay = cards_inplay

    def __str__(self):
        return str(self.cards_inplay)

    def click_loop(self, click_pos): #, game): <- later
        for i in range(len(self.cards_inplay)):
            if (self.cards_inplay[i].selectable(click_pos) == True): #and
                #len(game.get_hand_list()) <= 2):
                self.cards_inplay[i].select_click(click_pos)
                #game.add_hand(self.cards_inplay[i])
            elif self.cards_inplay[i].deselectable(click_pos) == True:
                self.cards_inplay[i].deselect_click(click_pos)
                #game.remove_hand(self.cards_inplay[i])
            else:
                pass

class Blank(Widget):
    """
    Creates a frame that contains the game, like a viewport. The game will only
    care about anything inside the viewport and nothing outside it.
    """
    def __init__(self, pos, size):
        super(Blank, self).__init__()
        with self.canvas:
            Color(0, 0, 0)
            Rectangle(pos=pos, size=size)
            Color(1, 1, 1)


###============Register Handlers==================
class Game(Widget):
    """
    Creates the game, essentially compile and innitates all of the class objects, draws,
    updates everything upon interaction.
    """
    def __init__(self):
        super(Game, self).__init__()
        #Background
        self.background = BG_Sprite(source="images/background.png")
        self.size = self.background.size
        self.add_widget(self.background)

        #Innitialize Class Objects
        self.card1 = Card(0, 3, (25, 190), select = False, eliminate = False)
        self.card2 = Card(8, 1, (100, 190), select = False, eliminate = False)
        self.card3 = Card(16, 2, (175, 190), select = False, eliminate = False)
        self.card4 = Card(1, 1, (25, 270), select = False, eliminate = False, secret_card = True)
        self.card5 = Card(8, 2, (100, 270), select = False, eliminate = False)
        self.card6 = Card(6, 1, (175, 270), select = False, eliminate = False)
        self.card7 = Card(5, 3, (25, 350), select = False, eliminate = False)
        self.card8 = Card(9, 2, (100, 350), select = False, eliminate = False)
        self.card9 = Card(16, 1, (175, 350), select = False, eliminate = False)

        self.guesser = Guess_Clicker([self.card1,self.card2,self.card3,
                                      self.card4,self.card5,self.card6,
                                      self.card7,self.card8,self.card9])

        #Create Widgets
        self.add_widget(self.card1)
        self.add_widget(self.card2)
        self.add_widget(self.card3)
        self.add_widget(self.card4)
        self.add_widget(self.card5)
        self.add_widget(self.card6)
        self.add_widget(self.card7)
        self.add_widget(self.card8)
        self.add_widget(self.card9)

        #Draw on Canvas
        self.update()

        #Blank Rectangle viewport
        self.add_widget(Blank(*PARAMS.blank_rect))

    def update(self):
        #Update Canvas
        with self.canvas:
            self.card1.draw()
            self.card2.draw()
            self.card3.draw()
            self.card4.draw()
            self.card5.draw()
            self.card6.draw()
            self.card7.draw()
            self.card8.draw()
            self.card9.draw()

    def on_touch_down(self, click):
        self.guesser.click_loop(click)
        self.update()

###===========Launch Game==========
class GameApp(App):
    """
    Builds the Game!
    """
    def build(self):
        Window.size = (256, 454.4) #For Testing
        PARAMS.init() #Initializes Screen Adjustment
        game = Game()
        return game

###============Globals=============
class params(object):
    """
    Adjusts for different screen sizes.
    """
    def init(self):
        self.bg_width, self.bg_height = 256, 454.4
        self.width, self.height = Window.size
        self.center = Window.center
        ws = float(self.width) / self.bg_width
        hs = float(self.height) / self.bg_height
        self.scale = min(ws, hs)
        Logger.info('size=%r; dpi=%r; density=%r; SCALE=%r',
            Window.size, Metrics.dpi, Metrics.density, self.scale)
        if ws > hs:
            gap = self.width - (self.bg_width * hs)
            self.blank_rect = ((self.width - gap, 0), (gap, self.height))
        else:
            gap = self.height - (self.bg_height * ws)
            self.blank_rect = ((0, self.height - gap), (self.width, gap))
PARAMS = params()

if __name__ == "__main__":
    GameApp().run()