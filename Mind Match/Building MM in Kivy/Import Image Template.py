"""
Mind Match Program
Enjoy the game :)
Yours, D'Cypher

Example Input Key:
emj;8;0;emj;4;1;emj;6;3;emj2;1;1;emj;9;2;emj;11;1;emj;5;2;emj;8;3;emj;7;2;emj;6;3;p-def;Random Random

"""

#Import Default Modules
import random
import math
import time

#Import GUI Modules
from kivy.app import App
from kivy.loader import Loader
from kivy.clock import Clock
from kivy.uix.widget import Widget
from kivy.uix.button import Button
from kivy.graphics import Color, Rectangle
from kivy.core.window import Window
from kivy.uix.image import Image


#Import Dictionary Modules
import premise_dict as premise_dictionary

###========Import Images and Globals=========
class ImageInfo:
    def __init__(self, center, size, radius = 0):
        self.center = center
        self.size = size
        self.radius = radius

    def get_center(self):
        return self.center

    def get_size(self):
        return self.size

    def get_radius(self):
        return self.radius

CANVAS_WIDTH = 334
CANVAS_HEIGHT = 600

#iphone_info = ImageInfo([580/2+10, 1200/2+30], [540, 1080])
#iphone_image = simplegui.load_image("https://static-cdn.fullcontact.com/images/website/iphone5.png")

BACKGROUND_IMAGE = "C:/Users/wcai/Desktop/5 Personal Projects/My Courses/Kivy/Example Projects/r1chardj0n3s-kivy-game-tutorial-a8275f381cd7/flappy/images/background.png"
#BIRD_IMAGE = "C:/Users/wcai/Desktop/5 Personal Projects/My Courses/Kivy/Example Projects/r1chardj0n3s-kivy-game-tutorial-a8275f381cd7/flappy/images/bird.png"
BIRD_IMAGE = "bird_anim.png"

splash_info = ImageInfo([56, 46], [80, 85])
splash_image = Loader.image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/splash.png")

lock_button_info = ImageInfo([512/2, 512/2], [512, 512])
lock_button_image = Loader.image("http://open.az/templates/slide/images/closed.png")

lock_buttonRed_info = ImageInfo([512/2, 512/2], [512, 512])
lock_buttonRed_image = Loader.image("http://cdn.mysitemyway.com/etc-mysitemyway/icons/legacy-previews/icons/simple-red-square-icons-business/128651-simple-red-square-icon-business-lock6-sc48.png")

logo_info = ImageInfo([175/2, 175/2], [175, 175])
logo_image = Loader.image("http://a4.mzstatic.com/us/r30/Purple2/v4/62/64/96/6264960b-783f-52d7-5c5c-dc0d7fe5c25d/icon175x175.jpeg")

#Themes
theme_emoji = Loader.image("https://s3-us-west-1.amazonaws.com/rappler-assets/1014A8772D75442E93D092B9D451652D/img/5CBD86790FEB412C96F9B4E16E1A71CA/twitter-emoji-feature-20140403-1.jpg?AWSAccessKeyId=AKIAJZT25YUX4PJDIYZA&Expires=1712143319&Signature=GAxzBNxHun2708GGo3J1%2FsOYAB4%3D")
theme_emoji2 = Loader.image("http://getemoji.com/assets/og/mobile.png")

#Card Size and Center
CARD_SIZE =(80, 85)
CARD_CENTER = (56, 72)

#Tile Image Card Coordinates
CARD_COLUMN = range(17)
CARD_ROW = range(5)

#Initialize global variables
questions_GLOBAL = 0
flags_GLOBAL = 0

#Helper fomula: Distance formula
def dist_formula(p, q):
    return math.sqrt((p[0] - q[0]) ** 2 + (p[1] - q[1]) ** 2)

###=======Define class objects==========

class Card:
    """
    Creates the card class object and all of it's properties.
    Takes coordinates of the card and position
    and draws the card on the canvaas.
    """

    def __init__(self, col_input = 0, row_input = 0, pos = (100,100), theme = "emj", select = False,
                 eliminate = False, secret_card = False, back = True, lifespan = None,
                 animated = False, radius = 40):

        if (col_input in CARD_COLUMN) and (row_input in CARD_ROW):
            self.c_col = col_input
            self.c_row = row_input
        else:
            self.c_col = None
            self.c_row = None
            print ("Invalid card: ", col_input, row_input)

        self.obj_coord = [pos[0] + CARD_CENTER[0], pos[1] + CARD_CENTER[1]]

        if lifespan:
            self.lifespan = lifespan
        else:
            self.lifespan = float('inf')

        self.theme = theme
        self.animated = animated
        self.select = select
        self.eliminate = eliminate
        self.secret_card = secret_card
        self.back = back
        self.radius = radius

    def __str__(self):
        return str(self.theme) +";"+ str(self.c_col) +";"+ str(self.c_row)

    def get_cardID(self):
        return tuple([self.c_col,self.c_row])

    def get_card_string(self):
        return str(self.theme) +";"+ str(self.c_col) +";"+ str(self.c_row)

    def get_radius(self):
        return self.radius

    def get_lifespan(self):
        return self.lifespan

    def get_animated(self):
        return self.animated

    def get_selected(self):
        return self.select

    def get_eliminated(self):
        return self.eliminate

    def get_secret_card(self):
        return self.secret_card

    def get_theme(self):
        return self.theme

    def change_c_col(self, c_col):
        self.c_col = c_col

    def change_c_row(self, c_row):
        self.c_row = c_row

    def change_theme(self, theme):
        self.theme = theme

    def theme_lookup(self):
        dict_theme = {"emj": theme_emoji,
                      "emj2": theme_emoji2}

        return dict_theme[self.theme]

    def make_secret(self):
        self.secret_card = True

    def make_nonsecret(self):
        self.secret_card = False

    def eliminate_card(self):
        self.eliminate = True
        if self.select == True:
            self.select = False
        else:
            pass

    def uneliminate_card(self):
        self.eliminate = False

    def flip_card(self):
        if self.back == True:
            self.back = False
        elif self.back == False:
            self.back = True
            self.eliminate = False
            self.select = False
        else:
            pass

    def draw(self, canvas):
        topleft_x = self.obj_coord[0]-.465*CARD_SIZE[0]
        topleft_y = self.obj_coord[1]-.45*CARD_SIZE[1]
        topright_x = self.obj_coord[0]+.465*CARD_SIZE[0]
        topright_y = self.obj_coord[1]-.45*CARD_SIZE[1]
        bottomright_x = self.obj_coord[0]+.465*CARD_SIZE[0]
        bottomright_y = self.obj_coord[1]+.45*CARD_SIZE[1]
        bottomleft_x = self.obj_coord[0]-.465*CARD_SIZE[0]
        bottomleft_y = self.obj_coord[1]+.45*CARD_SIZE[1]

        card_loc = (CARD_CENTER[0] + CARD_SIZE[0] * CARD_COLUMN.index(self.c_col)
                    + math.floor((CARD_COLUMN.index(self.c_col)+1)/2),
                    CARD_CENTER[1] + CARD_SIZE[1] * CARD_ROW.index(self.c_row))

        if (self.eliminate == True and self.secret_card == False):
            canvas.draw_polygon([[topleft_x, topleft_y],
                                [topright_x, topright_y],
                                [bottomright_x, bottomright_y],
                                [bottomleft_x, bottomleft_y]], 2.5, "Grey", "Green")

        elif (self.eliminate == True and self.secret_card == True):
            canvas.draw_polygon([[topleft_x, topleft_y],
                                [topright_x, topright_y],
                                [bottomright_x, bottomright_y],
                                [bottomleft_x, bottomleft_y]], 2.5, "Red", "Red")

        elif self.eliminate == False:
            if self.select == True:
                canvas.draw_polygon([[topleft_x, topleft_y],
                                     [topright_x, topright_y],
                                     [bottomright_x, bottomright_y],
                                     [bottomleft_x, bottomleft_y]], 2.5, "Grey", "Black")
            elif self.select == False:
                canvas.draw_polygon([[topleft_x, topleft_y],
                                     [topright_x, topright_y],
                                     [bottomright_x, bottomright_y],
                                     [bottomleft_x, bottomleft_y]], 2.5, "Darkseagreen", "Darkseagreen")
            else:
                pass
        else:
            pass

        if self.back == False:
            canvas.draw_image(self.theme_lookup(), card_loc, CARD_SIZE, self.obj_coord, [.8*CARD_SIZE[0],.8*CARD_SIZE[0]])
        else:
            canvas.draw_image(logo_image, logo_info.get_center(), logo_info.get_size(),
                              self.obj_coord, [.8*CARD_SIZE[0],.8*CARD_SIZE[0]])

        if self.eliminate == True:
            canvas.draw_image(splash_image, splash_info.get_center(), splash_info.get_size(),
                              self.obj_coord, [.8*CARD_SIZE[0],.8*CARD_SIZE[0]])
        else:
            pass

    def selectable(self, click_pos):
        self.select_logic = (dist_formula(self.obj_coord, click_pos) < self.radius
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
        self.deselect_logic = (dist_formula(self.obj_coord, click_pos) < self.radius
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

###=======Initializes Class Objects==========
card1 = Card(1, 3, [17, 100], select = False, eliminate = False, back = False)
card2 = Card(8, 1, [112, 100], select = False, eliminate = False, back = False)
card3 = Card(16, 1, [205, 100], select = False, eliminate = False, back = False)
card4 = Card(1, 1, [17, 200-5], select = False, eliminate = False, back = False)
card5 = Card(8, 2, [112, 200-5], select = False, eliminate = False, back = False)
card6 = Card(6, 1, [205, 200-5], select = False, eliminate = False, back = False)
card7 = Card(5, 3, [17, 300-10], select = False, eliminate = False, back = False)
card8 = Card(9, 2, [112, 300-10], select = False, eliminate = False, back = False)
card9 = Card(16, 1, [205, 300-10], select = False, eliminate = False, back = False)

###=======Register Handlers and Initialize Frame==========
def draw(canvas):
    #canvas.draw_image(iphone_image, iphone_info.get_center(), iphone_info.get_size(),
                      #[CANVAS_WIDTH / 2, CANVAS_HEIGHT / 2], [CANVAS_WIDTH, CANVAS_HEIGHT])

    card1.draw(canvas)
    card2.draw(canvas)
    card3.draw(canvas)
    card4.draw(canvas)
    card5.draw(canvas)
    card6.draw(canvas)
    card7.draw(canvas)
    card8.draw(canvas)
    card9.draw(canvas)

class Sprite(Image):
    def __init__(self, **kwargs):
        super(Sprite, self).__init__(**kwargs)
        self.size = self.texture_size
        #self.width = 100

class BirdSprite(Image):
    def __init__(self, **kwargs):
        super(BirdSprite, self).__init__(**kwargs)
        self.keep_data = True
        self.size = [100,100]
        #self. = [50,0]
        #self.width = 50

class Bird(BirdSprite):
    def __init__(self, pos):
        super(Bird, self).__init__(source=BIRD_IMAGE, pos=pos)
        self.velocity_y = 0
        self.gravity = -.3

    def update(self):
        self.velocity_y += self.gravity
        self.velocity_y = max(self.velocity_y, -10)
        self.y += self.velocity_y

    def on_touch_down(self, *ignore):
        self.velocity_y = 5.5

class Game(Widget):
    def __init__(self):
        super(Game, self).__init__()
        self.background = Sprite(source=BACKGROUND_IMAGE)
        self.size = self.background.size
        self.add_widget(self.background)
        self.bird = Bird(pos=(20, self.height / 2))
        self.add_widget(self.bird)
        Clock.schedule_interval(self.update, 5/60.0)

    def update(self, *ignore):
        self.bird.update()

class GameApp(App):
    def build(self):
        #return Game()
        game = Game()
        Window.size = game.size
        return game

if __name__ == "__main__":
    GameApp().run()
