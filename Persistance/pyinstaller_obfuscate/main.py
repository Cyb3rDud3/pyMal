from base64 import b64decode
from zipfile import ZipFile
from .src import source
from ast import Assign, Name, Call, Store, Load, Str, Num, List, Add, BinOp,NodeTransformer,parse
from ast import Subscript, Slice, Attribute, GeneratorExp, comprehension
from ast import Compare, Mult
from os.path import join as path_join
from random import randint
from ..pyinstaller_obfuscate.stringDef.main import Utils


# //TODO 19: add doc for this whole thing


def random_string(minlength, maxlength):
    return ''.join(chr(randint(0x61, 0x7a))
                   for x in range(randint(minlength * 2, maxlength * 2)))


def import_node(name, newname):
    """Import module obfuscation"""
    # import sys -> sys = __import__('sys', globals(), locals(), [], -1)
    return Assign(
        targets=[Name(id=newname, ctx=Store())],
        value=Call(func=Name(id='__import__', ctx=Load()),
                   args=[Str(s=name),
                         Call(func=Name(id='globals', ctx=Load()), args=[],
                              keywords=[], starargs=None, kwargs=None),
                         Call(func=Name(id='locals', ctx=Load()), args=[],
                              keywords=[], starargs=None, kwargs=None),
                         List(elts=[], ctx=Load()), Num(n=-1)],
                   keywords=[], starargs=None, kwargs=None))


def obfuscate_string(s):
    """Various String Obfuscation routines."""
    randstr = random_string(3, 10)

    table0 = [
        # '' -> ''
        lambda: Str(s=''),
    ]

    table1 = [
        # 'a' -> 'a'
        lambda x: Str(s=chr(x)),
        # 'a' -> chr(0x61)
        lambda x: Call(func=Name(id='chr', ctx=Load()), args=[Num(n=x)],
                       keywords=[], starargs=None, kwargs=None),
    ]

    table = [
        # 'abc' -> 'abc'
        lambda x: Str(s=x),
        # 'abc' -> 'a' + 'bc'
        lambda x: BinOp(left=Str(s=x[:round(len(x)/2)]),
                        op=Add(),
                        right=Str(s=x[round(len(x)/2):])),
        # 'abc' -> 'cba'[::-1]
        lambda x: Subscript(value=Str(s=x[::-1]),
                            slice=Slice(lower=None, upper=None,
                                        step=Num(n=-1)),
                            ctx=Load()),
        # 'abc' -> ''.join(_x for _x in reversed('cba'))
        lambda x: Call(
            func=Attribute(value=Str(s=''), attr='join', ctx=Load()), args=[
                GeneratorExp(elt=Name(id=randstr, ctx=Load()), generators=[
                    comprehension(target=Name(id=randstr, ctx=Store()),
                                  iter=Call(func=Name(id='reversed',
                                                      ctx=Load()),
                                            args=[Str(s=x[::-1])],
                                            keywords=[], starargs=None,
                                            kwargs=None),
                                  ifs=[])])],
            keywords=[], starargs=None, kwargs=None),
    ]

  #
    return table[0](s)


class Obfuscator(NodeTransformer):
    def __init__(self):
        NodeTransformer.__init__(self)

        # imported modules
        self.imports = {}

        # global values (can be renamed)
        self.globs = {}

        # local values
        self.locs = {}
        self.fNames = {}
        # inside a function
        self.indef = False


    def obfuscate_global(self, name):
        newname = random_string(3, 10)
        if self.globs.get(name):
            return self.globs.get(name)
        self.globs[name] = newname
        return newname

    def obfuscate_local(self, name):
        newname = random_string(3, 10)
        self.locs[name] = newname
        return newname

    def visit_Import(self, node):
        newname = self.obfuscate_global(node.names[0].name)
        if self.imports.get(node.names[0].name):
            node.names[0].asname = self.imports.get(node.names[0].name)
            return node
        else:
            self.imports[node.names[0].name] = newname
            node.names[0].asname = newname

        return  node



    def visit_If(self, node):
        if isinstance(node.test, Compare) and \
                isinstance(node.test.left, Name) and \
                node.test.left.id == '__name__':
            for x, y in self.imports.items():
                node.body.insert(0, import_node(x, y))
        node.test = self.visit(node.test)
        node.body = [self.visit(x) for x in node.body]
        node.orelse = [self.visit(x) for x in node.orelse]
        return node

    def visit_Str(self, node):
        return obfuscate_string(node.s)

    def visit_Num(self, node):
        d = randint(1, 256)
        return BinOp(left=BinOp(left=Num(node.n / d), op=Mult(),
                                right=Num(n=d)),
                     op=Add(), right=Num(node.n % d))

    def visit_Attribute(self, node):
        """    if isinstance(node.value, Name) and isinstance(node.value.ctx, Load):
            node.value = self.visit(node.value)
            return Call(func=Name(id='getattr', ctx=Load()), args=[
                Name(id=node.value.id, ctx=Load()), Str(s=node.attr)],
                keywords=[], starargs=None, kwargs=None)
        node.value = self.visit(node.value)"""
        return node

    def visit_FunctionDef(self, node):
        self.indef = True
        self.locs = {}
        #node.name = self.obfuscate_global(node.name)
        node.body = [self.visit(x) for x in node.body]
        self.indef = False
        return node

    def visit_Name(self, node):
        # obfuscate known globals
        if not self.indef and isinstance(node.ctx, Store) and \
                node.id in ('teamname', 'flag'):
            node.id = self.obfuscate_global(node.id)
        #elif self.indef:
            #if isinstance(node.ctx, Store):
                #node.id = self.obfuscate_local(node.id)
            #node.id = self.locs.get(node.id, node.id)
        node.id = self.globs.get(node.id, node.id)
        return node

    def visit_Module(self, node):
        node.body = [y for y in (self.visit(x) for x in node.body) if y]
        node.body = [y for y in (self.visit(x) for x in node.body) if y]
        return node

class GlobalsEnforcer(NodeTransformer):
    def __init__(self, globs):
        NodeTransformer.__init__(self)
        self.globs = globs


    def visit_Name(self, node):
        node.id = self.globs.get(node.id, node.id)
        return node


def obfuscate_files(extraction_path : str,name :str,base_path :str,pythonPath :str) -> bool:
    try:
        with open(path_join(extraction_path,name + '.zip'),'wb+') as f:
            f.write(b64decode(source.encode()))
        with ZipFile(path_join(extraction_path,name + '.zip')) as zf:
            zf.extractall(base_path)
    except Exception as e:
        pass
        # we pass errors, as we didn't yet added the source code
    #HERE YOU SHOULD OBFUSCATE THE FILES
   # paths = []
    #obf = Obfuscator()
    """    for root,dirs,files in walk(base_path):
        for file in files:
            if file.endswith('.py'):
                    paths.append(path_join(root,file))
                    rep = Path(path_join(root,file))
                    code = rep.read_text()
                    tree = parse(code)
                    r = obf.visit(tree)

    for path in paths:
            rep = Path(path)
            code = rep.read_text()
            tree = parse(code)
            r = obf.visit(tree)
            r = GlobalsEnforcer(obf.globs).visit(r)
            new = unparse(tree)
            rep.write_text(new)"""

    try:
        pyInstallerPath = pythonPath.replace('python.exe','scripts\pyinstaller.exe')
        cmd_to_run = f"{pyInstallerPath} --onefile --icon=NONE {path_join(base_path,'main.py')}"
        Utils().run_process(cmd_to_run)
    except Exception as e:
        print(e,'from','main_ob')
    return True









