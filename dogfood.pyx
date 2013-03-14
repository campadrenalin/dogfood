import json as jsonlib

def _food_handler(obj):
    if hasattr(obj, '__food__'):
        item = obj.__encode__()
        item.append('__food__')
        return item
    raise TypeError("Unable to serialise: %r" % obj)

def encode(thing):
    bytes = jsonlib.dumps(thing, default=_food_handler)
    return bytes

def _deflate(thing):
    if hasattr(thing, '__food__'):
        thing_list = thing.__encode__()
        obj_name = thing_list[0]
        obj_args = thing_list[1]
        if len(thing_list) == 3:
            obj_kwargs = thing_list[2]
        else:
            obj_kwargs = None
        for index, arg in enumerate(obj_args):
            obj_args[index] = _deflate(arg)
        obj_kwargs = _deflate(obj_kwargs)
        return [obj_name, obj_args, obj_kwargs, '__food__']

    if type(thing) == dict:
        out_dict = dict(thing)
        for key, val in thing.iteritems():
            del(out_dict[key])
            out_dict[_deflate(key)] = _deflate(val)
        return out_dict

    if type(thing) == list:
        out_list = list(thing)
        for nindex, item in enumerate(thing):
            out_list[nindex] = _deflate(item)
        return out_list

    return thing

def decode(encoded, class_source=None):
    obj = jsonlib.loads(encoded)
    return _inflate(obj, class_source=class_source)

def _is_food(oname, class_source=None):
    class_source = class_source or globals()
    return hasattr(class_source[oname], '__food__')

def _can_be_food(alist):
    return type(alist) == list and len(alist) == 3 and alist[2] == '__food__'

def _inflate(thing, parent=None, class_source=None):
    class_source = class_source or globals()
    if isinstance(thing, list) and thing[-1] == '__food__':
        if thing[0] in filter(lambda x: _is_food(x, class_source), class_source.keys()):
            # Inflate args too
            thing[1] = _inflate(thing[1], parent=thing)
            # kwargs
            if len(thing) == 4 and type(thing[2]) == dict:
                kwargs = _inflate(thing[2], parent=thing)
            else:
                kwargs = {}
            # deref the object and make a new one
            exe = class_source[thing[0]]
            return exe(*thing[1], **kwargs)
        else:
            raise TypeError('%r not in globals' % thing[0])

    elif isinstance(thing, list):
        for nindex, item in enumerate(thing):
            thing[nindex] = _inflate(item, parent=thing)
        return thing
    elif isinstance(thing, dict):
        for key, val in thing.iteritems():
            thing[key] = _inflate(val, parent=thing)
            thing[_inflate(key, parent=thing)] = thing[key]
            if _inflate(key, parent) != key:
                del(thing[key])
        return thing
    else:
        return thing


cdef class Food:

    cdef public __food__
