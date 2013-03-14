from __future__ import print_function
from dogfood import *

class Steak(Food):
    
    def __encode__(self):
        return ['Steak', [self.degree]]

    def __init__(self, degree):
        self.degree = degree

s = Steak('rare')
print(hasattr(s, '__food__'))

sbytes = encode(s)
print(sbytes)
import jsonlib
print(jsonlib.loads(sbytes))
new_steak = decode(sbytes, globals())
#print(ns())

print(repr(new_steak))
