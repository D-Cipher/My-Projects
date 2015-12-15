#Mind Match Premise Dictionary

def p_lookup(p_code):
    dict_premise = {"p-custom": "[Custom premise]",
         "p-def": "Guess which card I picked:",
         "p-justsay": "I'm just sayin'...",
         "p-holdply": "Hold on playa...",
         "p-findneed": "Something I can never find when I need it:",
         "p-toast": "Something I put on my toast:",
         "p-fdreams": "A place I go to follow my dreams:",
         "p-dowknd": "Something I do on weekends:",
         "p-likewknd": "Something I would like to do on weekends:",
         "p-dofake": "People who do this are so fake:",
         "p-moreof": "Besides money, I would like more of this:",
         "p-danger": "This thing is so dangerous:",
         "p-smdick": "Guys with small dicks also have this:",
         "p-canceldate": "A good reason for cancelling a date:",
         "p-packvac": "Something I always pack for a vacation:",
         "p-strangtouch": "Strangest thing that I have ever touched:",
         "p-clownshave": "Something that only clowns have:",
         "p-notallowown": "People should not be allowed to own this:",
         "p-notallowdo": "People should not be allowed to do this:",
         "p-notallowtosay": "Men shouldn't be allow to say this word:",
         "p-favbodypart": "My favorite body part:",
         "p-annoyseveone": "I always do this, and it annoys everyone:",
         "p-alsogoodat": "Besides being awesome, I'm also good at this:",
         "p-eatbreakfast": "Something I eat for breakfast:",
         "p-cantanswerdoor": "Reason why I can't answer the door when I'm home:",
         "p-cantanswerphone": "Reason why I can't answer the phone:",
         "p-cantlivewo": "I can't live without this:",
         "p-addicted": "I am addicted to this:",
         "p-neverever": "Never have I ever...",
         "p-hateppllike": "I hate people that like this:",
         "p-hatepplhave": "I hate people that have this:",
         "p-wishhad": "Something that I wish I had:",
         "p-parentswarned": "Something that my parents warned me not to do:",
         "p-lookforolder": "Something I look forward to when I get older:",
         "p-makesmile": "Something that makes me smile:",
         "p-wierdown": "Something wierd that I own:",
         "p-celebsleep": "A celeberty that I would sleep with:",
         "p-spectalent": "A special talent that I have:",
         "p-placeangry": "Place where I go when I am angry:",
         "p-hardtolearn": "Something that was really hard for me to learn:"
         }
    return dict_premise[p_code]
    
if __name__ == '__main__':
    print('"Module": Only printed if directly executed.')

#Test
#print(p_lookup("p-hardtolearn"))