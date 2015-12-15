"""
Mind Match Program - Quizzer Side
Enjoy the game :)
Yours, D'Cypher

To Do:
-Change Premise
-Change Theme

"""

import random
import math
import kivy

from kivy.app import App
from kivy.core.window import Window
from kivy.uix.widget import Widget
from kivy.uix.button import Button
from kivy.graphics import Color, Rectangle, Line
from kivy.loader import Loader
from kivy.uix.image import Image
from kivy.core.image import Image as CoreImage
from kivy.uix.label import Label
from kivy.logger import Logger
from kivy.metrics import Metrics
from kivy.clock import Clock

import premise_dict as premise_dictionary

###============Helper Functions=============
def dist_formula(p,q):
    #Distance Formula
    return math.sqrt((p[0] - q[0]) ** 2 + (p[1] - q[1]) ** 2)

###============Define Class Objects=============
class BG_Sprite(Image):
    """
    Creates the background image for the Canvas which the game classes will be drawn on.
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

class Premise(Widget):
    """
    Creates the premise class object and all of it's properties.
    Takes a code and looks it up in a dictionary. Draws the
    returned value
    """

    def __init__(self, p_code = "p-def", pos = (17,385),custom_text = "None"):
        super(Premise, self).__init__()

        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)
        self.size = (PARAMS.scale * 210, PARAMS.scale * 50)

        self.p_code = p_code
        self.custom = custom_text

    def get_p_code(self):
        return self.p_code

    def change_premise(self, p_code):
        self.p_code = p_code #Note: Decryptionizer returns a list.

    def get_premise(self):
        return premise_dictionary.p_lookup(self.p_code)

    def change_custom_prem(self, text):
        self.custom = str(text) #Note: Decryptionizer returns a list.

    def get_custom_prem(self):
        return self.custom

    def draw(self):
        with self.canvas:
            self.canvas.clear()

            if self.p_code == "p-custom":
                self.over_label = Label(center=self.center, text=self.get_custom_prem(),
                                    font_size=14*PARAMS.scale, text_size=self.size,
                                        bold=True, color=(1,1,1,1))
            else:
                self.over_label = Label(center=self.center, text=self.get_premise(),
                                    font_size=14*PARAMS.scale, text_size=self.size,
                                        bold=True, color=(1,1,1,1))

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

        # Image Specs
        self.card_center = (16, 386)
        self.card_size = (80, 85)

        #Object Properties
        self.zoom = .7  * PARAMS.scale #Adjusted size: (56, 59.5)
        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)
        self.obj_coord = [self.pos[0] +(self.card_size[0]*self.zoom)/2,
                          self.pos[1] +(self.card_size[1]*self.zoom)/2]

        self.c_col = col_input
        self.c_row = row_input

        self.select = select
        self.eliminate = eliminate
        self.radius = radius

        self.theme = theme
        self.secret_card = secret_card
        self.back = back

    def get_cardID(self):
        return tuple([self.c_col,self.c_row])

    def get_card_string(self):
        return str(self.theme) +";"+ str(self.c_col) +";"+ str(self.c_row)

    def get_radius(self):
        return self.radius

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
        dict_theme = {"emj": "images/theme_emoji.jpg",
                      "emj2": "images/mobile.png"}

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

    def draw(self):
        #Card Locator
        card_column = range(17)
        card_row = range(5)
        card_loc = (self.card_center[0] + self.card_size[0] * card_column.index(self.c_col)
                    + math.floor((card_column.index(self.c_col)+1)/2),
                    self.card_center[1] - self.card_size[1] * card_row.index(self.c_row))

        #Texture Specs
        if self.back == False:
            self.texture = CoreImage(self.theme_lookup()
                                     ).texture.get_region(card_loc[0], card_loc[1],
                                                          self.card_size[0], self.card_size[1])
            self.size = (self.card_size[0]*self.zoom, self.card_size[1]*self.zoom)
        else:
            self.texture = CoreImage("images/logo.jpeg"
                                     ).texture.get_region(0, 0, 175, 175)
            self.size = (self.card_size[0]*self.zoom, self.card_size[1]*self.zoom)

        #Canvas Draw
        with self.canvas:
            self.canvas.clear()

            if (self.eliminate == True and self.secret_card == True): #Secret Card Revealed
                self.rect_bg = Rectangle(
                    pos=(self.pos[0]-(self.size[0]/10),self.pos[1]-(self.size[0]/10)),
                    size=(self.size[0]*1.2,self.size[1]*1.2), color=Color(.8, 0, 0, 1))

                self.rect_bg = Rectangle(
                    pos=self.pos, size=self.size, texture=self.texture, color=Color(.8, .8, .8, 1))

            elif (self.eliminate == True and self.secret_card == False): #Non Secret Card Eliminated
                self.rect_bg = Rectangle(
                    pos=(self.pos[0]-(self.size[0]/10),self.pos[1]-(self.size[0]/10)),
                    size=(self.size[0]*1.2,self.size[1]*1.2), color=Color(.4, .4, .4, .5))

                self.rect_bg = Rectangle(
                    pos=self.pos, size=self.size, texture=self.texture, color=Color(.6, .6, .6, .7))

            elif self.eliminate == False:
                if self.select == True: #Selected
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/10),self.pos[1]-(self.size[0]/10)),
                        size=(self.size[0]*1.2,self.size[1]*1.2), color=Color(0.1, 0.1, .1, 1))

                    self.rect_bg = Rectangle(
                        pos=self.pos, size=self.size, texture=self.texture, color=Color(1, 1, 1, 1))

                elif self.select == False: #Normal
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/10),self.pos[1]-(self.size[0]/10)),
                        size=(self.size[0]*1.2,self.size[1]*1.2), color=Color(.6, 1, .5, .7))

                    self.rect_bg = Rectangle(
                        pos=self.pos, size=self.size, texture=self.texture, color=Color(1, 1, 1, 1))

            #Line(circle=(self.pos[0]+self.size[0]/2, self.pos[1]+self.size[1]/2, 45)) #for testing

        #-----------------NOTES-----------------------
        #Colors for Each Card State:
        #Normal: Light green = Color(.6, 1, .5, .7), White = Color(1, 1, 1, 1)
        #Selected: Black = Color(0.1, 0.1, .1, 1), White = Color(1, 1, 1, 1)
        #Eliminated: Transparent Dark grey = Color(.4, .4, .4, .5), Transparent Light grey = Color(.6, .6, .6, .7))
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

class Quizzer_Clicker(object):
    """
    This is where all of the click logic for the cards resides for each state of the game.

    Basically takes a card list and tracks of when cards are removed from the list and placed into
    a players hand and when cards are then removed from the players hand and placed back into the card list.

    """

    def __init__(self, gmstate_class, premise_class, card_list, next_button, selectall_button,
                 morecards_button, theme_button, repick_button, startgame_button,
                 encryptionizer):
        self.gmstate_class = gmstate_class
        self.premise_class = premise_class
        self.card_list = card_list
        self.cards_in_game = []

        self.next_button = next_button
        self.selectall_button = selectall_button
        self.morecards_button = morecards_button
        self.theme_button = theme_button
        self.repick_button = repick_button
        self.startgame_button = startgame_button

        self.encryptionizer = encryptionizer

        for i in range(len(self.card_list)):
            self.cards_in_game.append(self.card_list[i])

        self.hand_list = []

        #Initial button status:
        self.next_button.deactivate()
        self.next_button.mk_invisible()
        self.repick_button.deactivate()
        self.repick_button.mk_invisible()
        self.selectall_button.deactivate()
        self.selectall_button.mk_invisible()
        self.startgame_button.deactivate()
        self.startgame_button.mk_invisible()
        self.morecards_button.deactivate()
        self.morecards_button.mk_invisible()
        self.theme_button.deactivate()
        self.theme_button.mk_invisible()

        self.new_card_IDs()

    def __str__(self):
        return str(self.card_list) + "," + str(self.hand_list)

    def get_card_list(self):
        return self.card_list

    def get_cards_in_game(self):
        return self.cards_in_game

    def get_hand_list(self):
        return self.hand_list

    def new_card_IDs(self):
        max_len = len(self.card_list) + len(self.hand_list)

        temp_hand = []
        final_rand_ls = set([])

        #Transform cards into tuples and adds to final_rand_ls
        if len(self.hand_list) > 0:
            for i in range(len(self.hand_list)):
                nonrand_item = self.hand_list[i].get_cardID()
                temp_hand.append(nonrand_item)
                final_rand_ls.add(nonrand_item)
        else:
            pass

        #Creates the new random cards
        while (len(final_rand_ls) < max_len):
            rand_item = tuple([random.randrange(0,17),
                               random.randrange(0,5)])
            final_rand_ls.add(rand_item)

        #Removes the cards in hand from final_rand_ls
        if len(self.hand_list) > 0:
            for i in range(len(temp_hand)):
                final_rand_ls.remove(temp_hand[i])
        else:
            pass

        #Changes all cards in play to new IDs
        new_card_ls = list(final_rand_ls)

        for i in range(len(self.card_list)):
            self.card_list[i].change_c_col(new_card_ls[i][0])
            self.card_list[i].change_c_row(new_card_ls[i][1])

        #return self.card_list #For Testing
        #return new_card_ls #For Testing

    def flip_all(self):
        for i in range(len(self.card_list)):
            self.card_list[i].flip_card()

    def add_hand(self, card):
        if len(self.card_list) >= 1:
            self.hand_list.append(card)
            self.card_list.remove(card)
        else:
            pass

        #print(self.card_list) ##for testing

    def remove_hand(self, card):
        if len(self.hand_list) >= 1:
            self.hand_list.remove(card)
            self.card_list.append(card)
        else:
            pass

        #print(self.card_list) ##for testing

    def eliminate_hand(self):
        if len(self.hand_list) >= 1:
            for i in range(len(self.hand_list)):
                self.hand_list[i].eliminate_card()
        else:
            pass

    def new_list(self, card_list):
        self.card_list = card_list
        self.hand_list = []
        for i in range(len(self.card_list)):
            self.card_list[i].deselect_click()
            self.card_list[i].uneliminate_card()
            self.card_list[i].make_nonsecret()
        self.new_card_IDs()

    def single_click_loop(self, click_pos):
        if self.gmstate_class.get_gmstate() == 1:
            for i in range(len(self.cards_in_game)):
                if (self.cards_in_game[i].selectable(click_pos) == True and
                        len(self.get_hand_list()) <= 0):
                    self.cards_in_game[i].select_click(click_pos)
                    self.add_hand(self.cards_in_game[i])
                elif self.cards_in_game[i].deselectable(click_pos) == True:
                    self.cards_in_game[i].deselect_click(click_pos)
                    self.remove_hand(self.cards_in_game[i])
                elif (self.cards_in_game[i].selectable(click_pos) == True and
                        len(self.get_hand_list()) > 0):
                    self.get_hand_list()[0].deselect_click()
                    self.remove_hand(self.get_hand_list()[0])
                    self.cards_in_game[i].select_click(click_pos)
                    self.add_hand(self.cards_in_game[i])
                else:
                    pass
        else:
            pass

    def click_loop(self, click_pos):
        if self.gmstate_class.get_gmstate() == 2:
            for i in range(len(self.cards_in_game)):
                if (self.cards_in_game[i].selectable(click_pos) == True):
                    self.cards_in_game[i].select_click(click_pos)
                    self.add_hand(self.cards_in_game[i])
                elif self.cards_in_game[i].deselectable(click_pos) == True:
                    self.cards_in_game[i].deselect_click(click_pos)
                    self.remove_hand(self.cards_in_game[i])
                else:
                    pass
        else:
            pass

        #Activate  / deactivate buttons: Select all, More, Theme
        if (self.gmstate_class.get_gmstate() == 2 and
            len(self.get_card_list()) <= 0): #All cards selected
            self.morecards_button.deactivate()
            self.theme_button.deactivate()
            #print("selectall.deactivate, morecards.deactivate, theme.deactivate")
        elif (self.gmstate_class.get_gmstate() == 2 and
              len(self.get_card_list()) > 0): #Not all cards selected
            self.morecards_button.activate()
            self.theme_button.activate()
            #print("selectall.activate, morecards.activate, theme.activate")
        else:
            pass

        #Activate / deactivate buttons: Next
        if (self.gmstate_class.get_gmstate() == 1 and
            len(self.get_hand_list()) >= 1):
            self.next_button.activate()
            self.next_button.mk_visible()
        elif (self.gmstate_class.get_gmstate() == 1 and
            len(self.get_hand_list()) < 1):
            self.next_button.deactivate()
            self.next_button.mk_visible()
        elif (self.gmstate_class.get_gmstate() == 2 and
            len(self.get_card_list()) <= 0):
            self.next_button.activate()
            self.next_button.mk_visible()
            self.selectall_button.deactivate()
            self.selectall_button.mk_invisible()
        elif (self.gmstate_class.get_gmstate() == 2 and
            len(self.get_card_list()) > 0):
            self.next_button.deactivate()
            self.next_button.mk_invisible()
            self.selectall_button.activate()
            self.selectall_button.mk_visible()
        else:
            pass

    def splash(self, click):
        if self.gmstate_class.started == False:
            self.gmstate_class.started = True
            self.gmstate_class.advance_gmstate(1)
            self.flip_all()
        else:
            pass

        if self.gmstate_class.get_gmstate() == 1:
            self.next_button.deactivate()
            self.next_button.mk_visible()
            self.repick_button.deactivate()
            self.repick_button.mk_visible()
            self.selectall_button.deactivate()
            self.selectall_button.mk_invisible()
            self.startgame_button.deactivate()
            self.startgame_button.mk_invisible()
            self.morecards_button.activate()
            self.morecards_button.mk_visible()
            self.theme_button.activate()
            self.theme_button.mk_visible()
        else:
            pass

    def next_click_loop(self, click_pos):

        if self.next_button.button_logic(click_pos) == True:
            if (self.gmstate_class.get_gmstate() == 1 and
                    len(self.get_hand_list()) == 1):
                self.get_hand_list()[0].make_secret()
                self.eliminate_hand()
            elif (self.gmstate_class.get_gmstate() == 2):
                self.eliminate_hand()
            else:
                pass

            self.gmstate_class.advance_gmstate()
            self.gmstate_class.print_gmstate() #for testing

            if self.gmstate_class.get_gmstate() == 2:
                self.next_button.deactivate()
                self.next_button.mk_invisible()
                self.repick_button.activate()
                self.repick_button.mk_visible()
                self.selectall_button.activate(delay_display = True)
                self.selectall_button.mk_visible()
                self.startgame_button.deactivate()
                self.startgame_button.mk_invisible()
                self.morecards_button.activate()
                self.morecards_button.mk_visible()
                self.theme_button.activate()
                self.theme_button.mk_visible()
            elif self.gmstate_class.get_gmstate() == 3:
                self.next_button.deactivate()
                self.next_button.mk_invisible()
                self.repick_button.activate()
                self.repick_button.mk_visible()
                self.selectall_button.deactivate()
                self.selectall_button.mk_invisible()
                self.startgame_button.activate(delay_display = True)
                self.startgame_button.mk_visible()
                self.morecards_button.deactivate()
                self.morecards_button.mk_invisible()
                self.theme_button.deactivate()
                self.theme_button.mk_invisible()
            else:
                pass
        else:
            pass

    def repick_click_loop(self, click_pos):

        if self.repick_button.button_logic(click_pos) == True:

            #Unselect Everything
            for i in range(len(self.cards_in_game)):
                if (self.cards_in_game[i] in self.hand_list) == True:
                    self.remove_hand(self.cards_in_game[i])
                else:
                    pass
                self.cards_in_game[i].deselect_click()
                self.cards_in_game[i].uneliminate_card()

            #Select the Secret Card, but make it unsecret
            for i in range(len(self.cards_in_game)):
                if self.cards_in_game[i].get_secret_card() == True:
                    self.cards_in_game[i].select_click()
                    self.cards_in_game[i].make_nonsecret()
                    self.add_hand(self.cards_in_game[i])
                else:
                    pass

            self.gmstate_class.advance_gmstate(1)

            if self.gmstate_class.get_gmstate() == 1:
                self.next_button.activate()
                self.next_button.mk_visible()
                self.repick_button.deactivate()
                self.repick_button.mk_visible()
                self.selectall_button.deactivate()
                self.selectall_button.mk_invisible()
                self.startgame_button.deactivate()
                self.startgame_button.mk_invisible()
                self.morecards_button.activate()
                self.morecards_button.mk_visible()
                self.theme_button.activate()
                self.theme_button.mk_visible()
            else:
                pass
        else:
            pass

    def selectall_click_loop(self, click_pos):

        if self.selectall_button.button_logic(click_pos) == True:
            for i in range(len(self.cards_in_game)):
                if (self.cards_in_game[i].get_selected() == False and
                        self.cards_in_game[i].get_eliminated() == False):
                    self.cards_in_game[i].select_click()
                    self.add_hand(self.cards_in_game[i])
                else:
                    pass
            self.selectall_button.deactivate()
            self.selectall_button.mk_invisible()
            self.next_button.activate()
            self.next_button.mk_visible()
            self.morecards_button.deactivate()
            self.theme_button.deactivate()
        else:
            pass

    def morecards_click_loop(self, click_pos):
        if self.morecards_button.button_logic(click_pos) == True:
            self.new_card_IDs()
        else:
            pass

    def theme_click_loop(self, click_pos):
        if self.theme_button.button_logic(click_pos) == True:
            print("Theme Changed")
        else:
            pass

    def startgame_click_loop(self, click_pos):
        if self.startgame_button.button_logic(click_pos) == True:
            print(self.encryptionizer.encrypt(self.premise_class, self.get_hand_list()))
        else:
            pass

class Next_Button(Widget):
    """
    Creates a Next button object and all its properties.
    Draws the button at the specified location.
    """

    def __init__(self, pos = (135,42), visible = False,
         active = False):
        super(Next_Button, self).__init__()

        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)
        self.visible = visible
        self.active = active

        self.delay_display = False
        self.age = 0
        self.lifespan = 1

    def get_visible(self):
        return self.visible

    def get_active(self):
        return self.active

    def mk_visible(self):
        self.visible = True

    def mk_invisible(self):
        self.visible = False

    def activate(self, delay_display = False):
        self.active = True
        self.delay_display = delay_display

    def deactivate(self):
        self.active = False

    def draw(self):

        zoom = .6 * PARAMS.scale
        self.size = (140*zoom, 55*zoom)

        with self.canvas:
            self.canvas.clear()

            if self.visible == True:
                if self.active == True and self.delay_display == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.3),self.pos[1]+(self.size[0]/3.5)),
                        text="Next", font_size=16*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                elif self.active == True and self.delay_display == True:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.3),self.pos[1]+(self.size[0]/3.5)),
                        text="Next", font_size=16*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                    self.time_delay()

                elif self.active == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(.65, .65, .65, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.661, .937, .661, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.3),self.pos[1]+(self.size[0]/3.5)),
                        text="Next", font_size=16*PARAMS.scale, text_size=self.size, bold=True,
                        color=(.65, .65, .65, 1))
                else:
                    pass
            else:
                self.canvas.clear()

            #Line(circle=(self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing

    def button_logic(self, click_pos):

        obj_radius = 20 * PARAMS.scale

        click_logic = ((dist_formula([self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5],
                                     click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius) and
                       self.get_visible() == True and
                       self.get_active() == True and
                       self.delay_display == False)

        #print("check_clicked") #For testing

        if click_logic == True:
            return True
        else:
            return False

    def time_delay(self):
        self.age += .3
        #print(self.age) #for testing
        if self.age > self.lifespan:
            self.delay_display = False
            self.age = 0
        else:
            pass

class Repick_Button(Widget):
    """
    Creates a Repick button object and all its properties.
    Draws the button at the specified location.
    """

    def __init__(self, pos = (35,42), visible = False,
         active = False):
        super(Repick_Button, self).__init__()

        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)
        self.visible = visible
        self.active = active

        self.delay_display = False
        self.age = 0
        self.lifespan = 1

    def get_visible(self):
        return self.visible

    def get_active(self):
        return self.active

    def mk_visible(self):
        self.visible = True

    def mk_invisible(self):
        self.visible = False

    def activate(self, delay_display = False):
        self.active = True
        self.delay_display = delay_display

    def deactivate(self):
        self.active = False

    def draw(self):

        zoom = .6 * PARAMS.scale
        self.size = (140*zoom, 55*zoom)

        with self.canvas:
            self.canvas.clear()

            if self.visible == True:
                if self.active == True and self.delay_display == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.45),self.pos[1]+(self.size[0]/3.5)),
                        text="Repick", font_size=16*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                elif self.active == True and self.delay_display == True:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.45),self.pos[1]+(self.size[0]/3.5)),
                        text="Repick", font_size=16*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                    self.time_delay()

                elif self.active == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(.65, .65, .65, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.661, .937, .661, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.45),self.pos[1]+(self.size[0]/3.5)),
                        text="Repick", font_size=16*PARAMS.scale, text_size=self.size, bold=True,
                        color=(.65, .65, .65, 1))
                else:
                    pass
            else:
                self.canvas.clear()

            #Line(circle=(self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing

    def button_logic(self, click_pos):

        obj_radius = 20 * PARAMS.scale

        click_logic = ((dist_formula([self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5],
                                     click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius) and
                       self.get_visible() == True and
                       self.get_active() == True and
                       self.delay_display == False)

        #print("check_clicked") #For testing

        if click_logic == True:
            return True
        else:
            return False

    def time_delay(self):
        self.age += .3
        #print(self.age) #for testing
        if self.age > self.lifespan:
            self.delay_display = False
            self.age = 0
        else:
            pass

class Selectall_Button(Widget):
    """
    Creates a Select all button object and all its properties.
    Draws the button at the specified location.
    """

    def __init__(self, pos = (135,42), visible = False,
         active = False):
        super(Selectall_Button, self).__init__()

        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)
        self.visible = visible
        self.active = active

        self.delay_display = False
        self.age = 0
        self.lifespan = 1

    def get_visible(self):
        return self.visible

    def get_active(self):
        return self.active

    def mk_visible(self):
        self.visible = True

    def mk_invisible(self):
        self.visible = False

    def activate(self, delay_display = False):
        self.active = True
        self.delay_display = delay_display

    def deactivate(self):
        self.active = False

    def draw(self):

        zoom = .6 * PARAMS.scale
        self.size = (140*zoom, 55*zoom)

        with self.canvas:
            self.canvas.clear()

            if self.visible == True:
                if self.active == True and self.delay_display == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.6),self.pos[1]+(self.size[0]/3.5)),
                        text="Select All", font_size=15*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                elif self.active == True and self.delay_display == True:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.6),self.pos[1]+(self.size[0]/3.5)),
                        text="Select All", font_size=15*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                    self.time_delay()

                elif self.active == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(.65, .65, .65, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.661, .937, .661, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.6),self.pos[1]+(self.size[0]/3.5)),
                        text="Select All", font_size=15*PARAMS.scale, text_size=self.size, bold=True,
                        color=(.65, .65, .65, 1))
                else:
                    pass
            else:
                self.canvas.clear()

            #Line(circle=(self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing

    def button_logic(self, click_pos):

        obj_radius = 20 * PARAMS.scale

        click_logic = ((dist_formula([self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5],
                                     click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius) and
                       self.get_visible() == True and
                       self.get_active() == True and
                       self.delay_display == False)

        #print("check_clicked") #For testing

        if click_logic == True:
            return True
        else:
            return False

    def time_delay(self):
        self.age += .3
        #print(self.age) #for testing
        if self.age > self.lifespan:
            self.delay_display = False
            self.age = 0
        else:
            pass

class Startgame_Button(Widget):
    """
    Creates a Start button object and all its properties.
    Draws the button at the specified location.
    """

    def __init__(self, pos = (135,42), visible = False,
         active = False):
        super(Startgame_Button, self).__init__()

        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)
        self.visible = visible
        self.active = active

        self.delay_display = False
        self.age = 0
        self.lifespan = 1

    def get_visible(self):
        return self.visible

    def get_active(self):
        return self.active

    def mk_visible(self):
        self.visible = True

    def mk_invisible(self):
        self.visible = False

    def activate(self, delay_display = False):
        self.active = True
        self.delay_display = delay_display

    def deactivate(self):
        self.active = False

    def draw(self):

        zoom = .6 * PARAMS.scale
        self.size = (140*zoom, 55*zoom)

        with self.canvas:
            self.canvas.clear()

            if self.visible == True:
                if self.active == True and self.delay_display == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.3),self.pos[1]+(self.size[0]/3.5)),
                        text="Start", font_size=16*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                elif self.active == True and self.delay_display == True:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.3),self.pos[1]+(self.size[0]/3.5)),
                        text="Start", font_size=16*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                    self.time_delay()

                elif self.active == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(.65, .65, .65, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.661, .937, .661, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.3),self.pos[1]+(self.size[0]/3.5)),
                        text="Start", font_size=16*PARAMS.scale, text_size=self.size, bold=True,
                        color=(.65, .65, .65, 1))
                else:
                    pass
            else:
                self.canvas.clear()

            #Line(circle=(self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing

    def button_logic(self, click_pos):

        obj_radius = 20 * PARAMS.scale

        click_logic = ((dist_formula([self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5],
                                     click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius) and
                       self.get_visible() == True and
                       self.get_active() == True and
                       self.delay_display == False)

        #print("check_clicked") #For testing

        if click_logic == True:
            return True
        else:
            return False

    def time_delay(self):
        self.age += .3
        #print(self.age) #for testing
        if self.age > self.lifespan:
            self.delay_display = False
            self.age = 0
        else:
            pass

class Morecards_Button(Widget):
    """
    Creates a More Cards button object and all its properties.
    Draws the button at the specified location.
    """

    def __init__(self, pos = (135,90), visible = False,
         active = False):
        super(Morecards_Button, self).__init__()

        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)
        self.visible = visible
        self.active = active

        self.delay_display = False
        self.age = 0
        self.lifespan = 1

    def get_visible(self):
        return self.visible

    def get_active(self):
        return self.active

    def mk_visible(self):
        self.visible = True

    def mk_invisible(self):
        self.visible = False

    def activate(self, delay_display = False):
        self.active = True
        self.delay_display = delay_display

    def deactivate(self):
        self.active = False

    def draw(self):

        zoom = .6 * PARAMS.scale
        self.size = (140*zoom, 55*zoom)

        with self.canvas:
            self.canvas.clear()

            if self.visible == True:
                if self.active == True and self.delay_display == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.72),self.pos[1]+(self.size[0]/3.5)),
                        text="More Cards", font_size=13*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                elif self.active == True and self.delay_display == True:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.72),self.pos[1]+(self.size[0]/3.5)),
                        text="More Cards", font_size=13*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                    self.time_delay()

                elif self.active == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(.65, .65, .65, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.661, .937, .661, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.72),self.pos[1]+(self.size[0]/3.5)),
                        text="More Cards", font_size=13*PARAMS.scale, text_size=self.size, bold=True,
                        color=(.65, .65, .65, 1))
                else:
                    pass
            else:
                self.canvas.clear()

            #Line(circle=(self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing

    def button_logic(self, click_pos):

        obj_radius = 20 * PARAMS.scale

        click_logic = ((dist_formula([self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5],
                                     click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius) and
                       self.get_visible() == True and
                       self.get_active() == True and
                       self.delay_display == False)

        #print("check_clicked") #For testing

        if click_logic == True:
            return True
        else:
            return False

    def time_delay(self):
        self.age += .3
        #print(self.age) #for testing
        if self.age > self.lifespan:
            self.delay_display = False
            self.age = 0
        else:
            pass

class Theme_Button(Widget):
    """
    Creates a Theme button object and all its properties.
    Draws the button at the specified location.
    """

    def __init__(self, pos = (35,90), visible = False,
         active = False):
        super(Theme_Button, self).__init__()

        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)
        self.visible = visible
        self.active = active

        self.delay_display = False
        self.age = 0
        self.lifespan = 1

    def get_visible(self):
        return self.visible

    def get_active(self):
        return self.active

    def mk_visible(self):
        self.visible = True

    def mk_invisible(self):
        self.visible = False

    def activate(self, delay_display = False):
        self.active = True
        self.delay_display = delay_display

    def deactivate(self):
        self.active = False

    def draw(self):

        zoom = .6 * PARAMS.scale
        self.size = (140*zoom, 55*zoom)

        with self.canvas:
            self.canvas.clear()

            if self.visible == True:
                if self.active == True and self.delay_display == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.75),self.pos[1]+(self.size[0]/3.5)),
                        text="New Theme", font_size=13*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                elif self.active == True and self.delay_display == True:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(1, 1, 0, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.561, .837, .561, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.75),self.pos[1]+(self.size[0]/3.5)),
                        text="New Theme", font_size=13*PARAMS.scale, text_size=self.size, bold=True,
                        color=(1, 1, 1, 1))

                    self.time_delay()

                elif self.active == False:
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0]-(self.size[0]/25),self.pos[1]-(self.size[0]/26)),
                        size=(self.size[0]*1.09,self.size[1]*1.20), color=Color(.65, .65, .65, 1))
                    self.rect_bg = Rectangle(
                        pos=(self.pos[0],self.pos[1]), size=(self.size[0],self.size[1]),
                        color=Color(.661, .937, .661, 1))
                    self.over_label = Label(center=(self.pos[0]+(self.size[0]/1.75),self.pos[1]+(self.size[0]/3.5)),
                        text="New Theme", font_size=13*PARAMS.scale, text_size=self.size, bold=True,
                        color=(.65, .65, .65, 1))
                else:
                    pass
            else:
                self.canvas.clear()

            #Line(circle=(self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing
            #Line(circle=(self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5, 20 * PARAMS.scale)) #for testing

    def button_logic(self, click_pos):

        obj_radius = 20 * PARAMS.scale

        click_logic = ((dist_formula([self.pos[0]+self.size[0]/5, self.pos[1]+self.size[0]/5],
                                     click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.9, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius or
                       dist_formula([self.pos[0]+self.size[0]/1.25, self.pos[1]+self.size[0]/5],
                                    click_pos.pos) < obj_radius) and
                       self.get_visible() == True and
                       self.get_active() == True and
                       self.delay_display == False)

        #print("check_clicked") #For testing

        if click_logic == True:
            return True
        else:
            return False

    def time_delay(self):
        self.age += .3
        #print(self.age) #for testing
        if self.age > self.lifespan:
            self.delay_display = False
            self.age = 0
        else:
            pass

class Game_State(Widget):
    """
    Creates a game state object that tracks the three
    phases of the game, and tracks whether game started or not.
    State 0: Splash screen
    State 1: Select secret card.
    State 2: Select other cards in the deck.
    State 3: Go Back or Generate the Key to Launch Guesser Side.
    """

    def __init__(self, pos = (25, 117)):
        super(Game_State, self).__init__()

        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)
        self.size = (PARAMS.scale * 210, PARAMS.scale * 50)

        self.started = False
        self.gmstate = 0

    def get_started(self):
        return self.started

    def get_gmstate(self):
        return self.gmstate

    def print_gmstate(self):
        print(self.gmstate)

    def advance_gmstate(self, specify = None):
        if specify != None:
            self.gmstate = specify
        elif specify == None:
            if self.gmstate < 3:
                self.gmstate += 1
            else:
                self.gmstate = 0
        else:
            pass

    def draw(self):

        with self.canvas:
            self.canvas.clear()

            if self.gmstate == 1:
                self.over_label = Label(center=self.center, text="Select your secret card!",
                                        font_size=14*PARAMS.scale, text_size=self.size,
                                        bold=True, color=(1,1,1,1), halign="center")
            elif self.gmstate == 2:
                self.over_label = Label(center=self.center, text="Select Other Cards in Your Deck!",
                                        font_size=13*PARAMS.scale, text_size=self.size,
                                        bold=True, color=(1,1,1,1), halign="center")
            elif self.gmstate == 3:
                self.over_label = Label(center=self.center, text="Now Lets Get Started!",
                                        font_size=14*PARAMS.scale, text_size=self.size,
                                        bold=True, color=(1,1,1,1), halign="center")
            else:
                self.canvas.clear()

class Encryptionizer(Widget):
    """
    Encryptionizer class that takes a list cards and randomizes and
    generates an encrypted code.

    Example:
    emj;14;0;emj;7;0;emj;2;3;emj;0;4;emj;15;4;emj;11;2;emj;16;0;emj;0;1;emj;3;1;emj;0;4;p-def;None
    """

    def __init__(self, code_string = None):
        super(Encryptionizer, self).__init__()
        self.code_string = code_string

    def get_code_string(self):
        return self.code_string

    def encrypt(self, premise_class, hand_ls):
        if len(hand_ls) <= 0:
            pass
        else:

            #Process hand
            string_ls = []
            for i in range(len(hand_ls)):
                string_ls.append(hand_ls[i].get_card_string())

            random.shuffle(string_ls)
            hand_string = str(";".join(string_ls))
            #return  hand_string #for testing

            #Process secret card
            secret_string = None
            for i in range(len(hand_ls)):
                if hand_ls[i].get_secret_card() == True:
                    secret_string = str(hand_ls[i].get_card_string())
                else:
                    pass
            #return secret_string #for testing

            #Process premise
            p_string = str(premise_class.get_p_code())
            p_cust_string = str(premise_class.get_custom_prem())

            #Process Final Code
            self.code_string = (hand_string + ";" + secret_string + ";" +
                                p_string + ";" + p_cust_string)

            return self.code_string

class Adv_State_Button(Widget):
    """
    Creates an advance game state button used
    purely for testing game mechanics purposes.
    """

    def __init__(self, gmstate_class, pos = (99, 115), animated = False, radius = 27, lifespan = 1):
        super(Adv_State_Button, self).__init__()

        self.gmstate_class = gmstate_class

        self.pos = (pos[0]* PARAMS.scale, pos[1]* PARAMS.scale)

        self.animated = animated
        self.radius = radius
        self.age = 0
        self.lifespan = lifespan

    def get_radius(self):
        return self.radius

    def get_lifespan(self):
        return self.lifespan

    def get_animated(self):
        return self.animated

    def draw(self):
        image_left_corner = (80, 80)
        image_size = (360, 360)
        zoom = .15 * PARAMS.scale

        #Canvas Draw
        with self.canvas:
            self.canvas.clear()

            if self.animated == True:
                self.texture = CoreImage("images/red_lockin.png"
                                ).texture.get_region(image_left_corner[0], image_left_corner[1],
                                                     image_size[0], image_size[1])
                self.size = (image_size[0]*zoom, image_size[1]*zoom)

                self.rect_bg = Rectangle(
                        pos=self.pos, size=self.size, texture=self.texture, color=Color(1, 1, 1, 1))
            else:
                self.texture = CoreImage("images/black_lockin.png"
                                ).texture.get_region(image_left_corner[0], image_left_corner[1],
                                                     image_size[0], image_size[1])
                self.size = (image_size[0]*zoom, image_size[1]*zoom)

                self.rect_bg = Rectangle(
                        pos=self.pos, size=self.size, texture=self.texture, color=Color(1, 1, 1, 1))

            #Line(circle=(self.pos[0]+self.size[0]/2, self.pos[1]+self.size[0]/2, 27)) #for testing

    def select_click(self, click_pos):

        self.center = (self.pos[0]+self.size[0]/2, self.pos[1]+self.size[0]/2)

        self.select_logic = (dist_formula(self.center, click_pos.pos) < self.radius)

        if self.select_logic == True:
            self.animated = True
            self.gmstate_class.advance_gmstate()
            self.gmstate_class.print_gmstate()
            #print("Clicked!") #For Testing
        else:
            self.animate = False
            pass

    def update(self):

        if self.animated == True:
            self.age += .7
        else:
            pass

        if self.age > self.lifespan:
            self.animated = False
            self.age = 0
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
    Creates the game, essentially compile and initates all of the class objects, draws,
    updates everything upon interaction.
    """
    def __init__(self):
        super(Game, self).__init__()

        #Background
        self.background = BG_Sprite(source="images/background.png")
        self.size = self.background.size
        self.add_widget(self.background)

        #Innitialize Class Objects
        self.premise = Premise()
        self.card1 = Card(0, 3, (25-2, 190-40), select = False, eliminate = False)
        self.card2 = Card(8, 1, (100-2, 190-40), select = False, eliminate = False)
        self.card3 = Card(16, 2, (175-2, 190-40), select = False, eliminate = False)
        self.card4 = Card(1, 1, (25-2, 270-40), select = False, eliminate = False)
        self.card5 = Card(8, 2, (100-2, 270-40), select = False, eliminate = False)
        self.card6 = Card(6, 1, (175-2, 270-40), select = False, eliminate = False)
        self.card7 = Card(5, 3, (25-2, 350-40), select = False, eliminate = False)
        self.card8 = Card(9, 2, (100-2, 350-40), select = False, eliminate = False)
        self.card9 = Card(16, 1, (175-2, 350-40), select = False, eliminate = False)

        self.game_state = Game_State()
        self.next_button = Next_Button(pos=(140,20))
        self.repick_button = Repick_Button(pos=(35,20))
        self.selectall_button = Selectall_Button(pos=(140,20))
        self.startgame_button = Startgame_Button(pos=(140,20))
        self.morecards_button = Morecards_Button(pos=(140,68))
        self.theme_button = Theme_Button(pos=(35,68))

        self.encryptionizer = Encryptionizer()

        self.quizzer = Quizzer_Clicker(self.game_state,self.premise,
                                       [self.card1,self.card2,self.card3,
                                        self.card4,self.card5,self.card6,
                                        self.card7,self.card8,self.card9],
                                       self.next_button, self.selectall_button,
                                       self.morecards_button, self.theme_button,
                                       self.repick_button, self.startgame_button,
                                       self.encryptionizer)

        #self.key = Decryptionizer([self.card1,self.card2,self.card3,
        #                           self.card4,self.card5,self.card6,
        #                           self.card7,self.card8,self.card9])

        #self.start_game = Start_Game(self.key, self.premise, self.key.get_card_list())

        #Testing Advanced State
        self.adv_state = Adv_State_Button(self.game_state, pos = (200, 400)) #For Testing
        self.add_widget(self.adv_state) #For Testing

        #Create Widgets
        self.add_widget(self.premise)
        self.add_widget(self.card1)
        self.add_widget(self.card2)
        self.add_widget(self.card3)
        self.add_widget(self.card4)
        self.add_widget(self.card5)
        self.add_widget(self.card6)
        self.add_widget(self.card7)
        self.add_widget(self.card8)
        self.add_widget(self.card9)
        self.add_widget(self.next_button)
        self.add_widget(self.repick_button)
        self.add_widget(self.selectall_button)
        self.add_widget(self.morecards_button)
        self.add_widget(self.theme_button)
        self.add_widget(self.startgame_button)
        self.add_widget(self.game_state)
        self.add_widget(self.encryptionizer)

        #Animation Update
        Clock.schedule_interval(self.animated_update, .06) #Unused except for testing

        #Initial Draw on Canvas
        self.update()
        self.premise.draw()

        #Blank Rectangle viewport
        self.add_widget(Blank(*PARAMS.blank_rect))

    def update(self):

        #Updates Canvas
        self.card1.draw()
        self.card2.draw()
        self.card3.draw()
        self.card4.draw()
        self.card5.draw()
        self.card6.draw()
        self.card7.draw()
        self.card8.draw()
        self.card9.draw()
        self.repick_button.draw()
        self.morecards_button.draw()
        self.theme_button.draw()
        self.game_state.draw()
        #print(self.quizzer) #for testing

    def on_touch_down(self, click):

        #self.adv_state.select_click(click) #For testing

        if self.game_state.get_started() == False:
            self.quizzer.splash(click)
            self.update()
        elif self.game_state.get_started() == True:
            self.quizzer.single_click_loop(click)
            self.quizzer.click_loop(click)
            self.quizzer.next_click_loop(click)
            self.quizzer.repick_click_loop(click)
            self.quizzer.selectall_click_loop(click)
            self.quizzer.morecards_click_loop(click)
            self.quizzer.theme_click_loop(click)
            self.quizzer.startgame_click_loop(click)
            self.update()
        else:
            pass

    def animated_update(self, dt):
        #self.adv_state.update() #for testing
        #self.adv_state.draw()
        #print("time") #for testing
        self.next_button.draw()
        self.selectall_button.draw()
        self.startgame_button.draw()

        ##pass

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