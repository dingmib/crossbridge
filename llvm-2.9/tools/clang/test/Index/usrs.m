// RUN: c-index-test -test-load-source-usrs all %s | FileCheck %s

static inline int my_helper(int x, int y) { return x + y; }

enum {
  ABA,
  CADABA
};

enum {
  FOO,
  BAR
};

typedef struct {
  int wa;
  int moo;
} MyStruct;

enum Pizza {
  CHEESE,
  MUSHROOMS
};

@interface Foo {
  id x;
  id y;
}
- (id) godzilla;
+ (id) kingkong;
@property int d1;
@end

@implementation Foo
- (id) godzilla {
  static int a = 0;
  extern int z;
  return 0;
}
+ (id) kingkong {
  int local_var;
  return 0;
}
@synthesize d1;
@end

int z;

static int local_func(int x) { return x; }

@interface CWithExt
- (id) meth1;
@end
@interface CWithExt ()
- (id) meth2;
@end
@interface CWithExt ()
- (id) meth3;
@end
@interface CWithExt (Bar)
- (id) meth4;
@end
@implementation CWithExt
- (id) meth1 { return 0; }
- (id) meth2 { return 0; }
- (id) meth3 { return 0; }
@end
@implementation CWithExt (Bar)
- (id) meth4 { return 0; }
@end

void aux_1(int, int, int);
int test_multi_declaration(void) {
  int foo = 1, bar = 2, baz = 3;
  aux_1(foo, bar, baz);
  return 0;
}

@protocol P1
- (void)method;
@end

// CHECK: usrs.m c:usrs.m@85@F@my_helper Extent=[3:19 - 3:60]
// CHECK: usrs.m c:usrs.m@95@F@my_helper@x Extent=[3:29 - 3:34]
// CHECK: usrs.m c:usrs.m@102@F@my_helper@y Extent=[3:36 - 3:41]
// CHECK: usrs.m c:usrs.m@128@Ea Extent=[5:1 - 8:2]
// CHECK: usrs.m c:usrs.m@128@Ea@ABA Extent=[6:3 - 6:6]
// CHECK: usrs.m c:usrs.m@128@Ea@CADABA Extent=[7:3 - 7:9]
// CHECK: usrs.m c:usrs.m@155@Ea Extent=[10:1 - 13:2]
// CHECK: usrs.m c:usrs.m@155@Ea@FOO Extent=[11:3 - 11:6]
// CHECK: usrs.m c:usrs.m@155@Ea@BAR Extent=[12:3 - 12:6]
// CHECK: usrs.m c:@SA@MyStruct Extent=[15:9 - 18:2]
// CHECK: usrs.m c:@SA@MyStruct@FI@wa Extent=[16:7 - 16:9]
// CHECK: usrs.m c:@SA@MyStruct@FI@moo Extent=[17:7 - 17:10]
// CHECK: usrs.m c:usrs.m@179@T@MyStruct Extent=[15:1 - 18:11]
// CHECK: usrs.m c:@E@Pizza Extent=[20:1 - 23:2]
// CHECK: usrs.m c:@E@Pizza@CHEESE Extent=[21:3 - 21:9]
// CHECK: usrs.m c:@E@Pizza@MUSHROOMS Extent=[22:3 - 22:12]
// CHECK: usrs.m c:objc(cs)Foo Extent=[25:1 - 32:5]
// CHECK: usrs.m c:objc(cs)Foo@x Extent=[26:6 - 26:7]
// CHECK: usrs.m c:objc(cs)Foo@y Extent=[27:6 - 27:7]
// CHECK: usrs.m c:objc(cs)Foo(im)godzilla Extent=[29:1 - 29:17]
// CHECK: usrs.m c:objc(cs)Foo(cm)kingkong Extent=[30:1 - 30:17]
// CHECK: usrs.m c:objc(cs)Foo(py)d1 Extent=[31:1 - 31:17]
// CHECK: usrs.m c:objc(cs)Foo(im)d1 Extent=[31:15 - 31:17]
// CHECK: usrs.m c:objc(cs)Foo(im)setD1: Extent=[31:15 - 31:17]
// CHECK: usrs.m c:usrs.m@352objc(cs)Foo(im)setD1:@d1 Extent=[31:15 - 31:17]
// CHECK: usrs.m c:objc(cs)Foo Extent=[34:1 - 45:2]
// CHECK: usrs.m c:objc(cs)Foo(im)godzilla Extent=[35:1 - 39:2]
// CHECK: usrs.m c:usrs.m@409objc(cs)Foo(im)godzilla@a Extent=[36:10 - 36:19]
// CHECK: usrs.m c:objc(cs)Foo(im)godzilla@z Extent=[37:10 - 37:15]
// CHECK: usrs.m c:objc(cs)Foo(cm)kingkong Extent=[40:1 - 43:2]
// CHECK: usrs.m c:usrs.m@470objc(cs)Foo(cm)kingkong@local_var Extent=[41:3 - 41:16]
// CHECK: usrs.m c:objc(cs)Foo@d1 Extent=[44:13 - 44:15]
// CHECK: usrs.m c:objc(cs)Foo(py)d1 Extent=[44:1 - 44:15]
// CHECK: usrs.m c:@z Extent=[47:1 - 47:6]
// CHECK: usrs.m c:usrs.m@540@F@local_func Extent=[49:12 - 49:43]
// CHECK: usrs.m c:usrs.m@551@F@local_func@x Extent=[49:23 - 49:28]
// CHECK: usrs.m c:objc(cs)CWithExt Extent=[51:1 - 53:5]
// CHECK: usrs.m c:objc(cs)CWithExt(im)meth1 Extent=[52:1 - 52:14]
// CHECK: usrs.m c:objc(ext)CWithExt@usrs.m@612 Extent=[54:1 - 56:5]
// CHECK: usrs.m c:objc(cs)CWithExt(im)meth2 Extent=[55:1 - 55:14]
// CHECK: usrs.m c:objc(ext)CWithExt@usrs.m@654 Extent=[57:1 - 59:5]
// CHECK: usrs.m c:objc(cs)CWithExt(im)meth3 Extent=[58:1 - 58:14]
// CHECK: usrs.m c:objc(cy)CWithExt@Bar Extent=[60:1 - 62:5]
// CHECK: usrs.m c:objc(cs)CWithExt(im)meth4 Extent=[61:1 - 61:14]
// CHECK: usrs.m c:objc(cs)CWithExt Extent=[63:1 - 67:2]
// CHECK: usrs.m c:objc(cs)CWithExt(im)meth1 Extent=[64:1 - 64:27]
// CHECK: usrs.m c:objc(cs)CWithExt(im)meth2 Extent=[65:1 - 65:27]
// CHECK: usrs.m c:objc(cs)CWithExt(im)meth3 Extent=[66:1 - 66:27]
// CHECK: usrs.m c:objc(cy)CWithExt@Bar Extent=[68:1 - 70:2]
// CHECK: usrs.m c:objc(cs)CWithExt(im)meth4 Extent=[69:1 - 69:27]
// CHECK: usrs.m c:@F@aux_1 Extent=[72:6 - 72:26]
// CHECK: usrs.m c:@F@test_multi_declaration Extent=[73:5 - 77:2]
// CHECK: usrs.m c:usrs.m@980@F@test_multi_declaration@foo Extent=[74:3 - 74:14]
// CHECK: usrs.m c:usrs.m@980@F@test_multi_declaration@bar Extent=[74:16 - 74:23]
// CHECK: usrs.m c:usrs.m@980@F@test_multi_declaration@baz Extent=[74:25 - 74:32]
// CHECK: usrs.m c:objc(pl)P1 Extent=[79:1 - 81:5]
// CHECK: usrs.m c:objc(pl)P1(im)method Extent=[80:1 - 80:16]

// RUN: c-index-test -test-load-source all %s | FileCheck -check-prefix=CHECK-source %s
// CHECK-source: usrs.m:3:19: FunctionDecl=my_helper:3:19 (Definition) Extent=[3:19 - 3:60]
// CHECK-source: usrs.m:3:33: ParmDecl=x:3:33 (Definition) Extent=[3:29 - 3:34]
// CHECK-source: usrs.m:3:40: ParmDecl=y:3:40 (Definition) Extent=[3:36 - 3:41]
// CHECK-source: usrs.m:3:43: UnexposedStmt= Extent=[3:43 - 3:60]
// CHECK-source: usrs.m:3:45: UnexposedStmt= Extent=[3:45 - 3:57]
// CHECK-source: usrs.m:3:52: UnexposedExpr= Extent=[3:52 - 3:57]
// CHECK-source: usrs.m:3:52: DeclRefExpr=x:3:33 Extent=[3:52 - 3:53]
// CHECK-source: usrs.m:3:56: DeclRefExpr=y:3:40 Extent=[3:56 - 3:57]
// CHECK-source: usrs.m:5:1: EnumDecl=:5:1 (Definition) Extent=[5:1 - 8:2]
// CHECK-source: usrs.m:6:3: EnumConstantDecl=ABA:6:3 (Definition) Extent=[6:3 - 6:6]
// CHECK-source: usrs.m:7:3: EnumConstantDecl=CADABA:7:3 (Definition) Extent=[7:3 - 7:9]
// CHECK-source: usrs.m:10:1: EnumDecl=:10:1 (Definition) Extent=[10:1 - 13:2]
// CHECK-source: usrs.m:11:3: EnumConstantDecl=FOO:11:3 (Definition) Extent=[11:3 - 11:6]
// CHECK-source: usrs.m:12:3: EnumConstantDecl=BAR:12:3 (Definition) Extent=[12:3 - 12:6]
// CHECK-source: usrs.m:15:9: StructDecl=:15:9 (Definition) Extent=[15:9 - 18:2]
// CHECK-source: usrs.m:16:7: FieldDecl=wa:16:7 (Definition) Extent=[16:7 - 16:9]
// CHECK-source: usrs.m:17:7: FieldDecl=moo:17:7 (Definition) Extent=[17:7 - 17:10]
// CHECK-source: usrs.m:18:3: TypedefDecl=MyStruct:18:3 (Definition) Extent=[15:1 - 18:11]
// CHECK-source: usrs.m:15:9: TypeRef=MyStruct:15:9 Extent=[15:9 - 15:15]
// CHECK-source: usrs.m:20:6: EnumDecl=Pizza:20:6 (Definition) Extent=[20:1 - 23:2]
// CHECK-source: usrs.m:21:3: EnumConstantDecl=CHEESE:21:3 (Definition) Extent=[21:3 - 21:9]
// CHECK-source: usrs.m:22:3: EnumConstantDecl=MUSHROOMS:22:3 (Definition) Extent=[22:3 - 22:12]
// CHECK-source: usrs.m:25:12: ObjCInterfaceDecl=Foo:25:12 Extent=[25:1 - 32:5]
// CHECK-source: usrs.m:26:6: ObjCIvarDecl=x:26:6 (Definition) Extent=[26:6 - 26:7]
// CHECK-source: usrs.m:26:3: TypeRef=id:0:0 Extent=[26:3 - 26:5]
// CHECK-source: usrs.m:27:6: ObjCIvarDecl=y:27:6 (Definition) Extent=[27:6 - 27:7]
// CHECK-source: usrs.m:27:3: TypeRef=id:0:0 Extent=[27:3 - 27:5]
// CHECK-source: usrs.m:29:1: ObjCInstanceMethodDecl=godzilla:29:1 Extent=[29:1 - 29:17]
// CHECK-source: usrs.m:29:4: TypeRef=id:0:0 Extent=[29:4 - 29:6]
// CHECK-source: usrs.m:30:1: ObjCClassMethodDecl=kingkong:30:1 Extent=[30:1 - 30:17]
// CHECK-source: usrs.m:30:4: TypeRef=id:0:0 Extent=[30:4 - 30:6]
// CHECK-source: usrs.m:31:15: ObjCPropertyDecl=d1:31:15 Extent=[31:1 - 31:17]
// CHECK-source: usrs.m:31:15: ObjCInstanceMethodDecl=d1:31:15 Extent=[31:15 - 31:17]
// CHECK-source: usrs.m:31:15: ObjCInstanceMethodDecl=setD1::31:15 Extent=[31:15 - 31:17]
// CHECK-source: usrs.m:31:15: ParmDecl=d1:31:15 (Definition) Extent=[31:15 - 31:17]
// CHECK-source: usrs.m:34:1: ObjCImplementationDecl=Foo:34:1 (Definition) Extent=[34:1 - 45:2]
// CHECK-source: usrs.m:35:1: ObjCInstanceMethodDecl=godzilla:35:1 (Definition) [Overrides @29:1] Extent=[35:1 - 39:2]
// CHECK-source: usrs.m:35:4: TypeRef=id:0:0 Extent=[35:4 - 35:6]
// CHECK-source: usrs.m:35:17: UnexposedStmt= Extent=[35:17 - 39:2]
// CHECK-source: usrs.m:36:3: UnexposedStmt= Extent=[36:3 - 36:20]
// CHECK-source: usrs.m:36:14: VarDecl=a:36:14 (Definition) Extent=[36:10 - 36:19]
// CHECK-source: usrs.m:36:18: UnexposedExpr= Extent=[36:18 - 36:19]
// CHECK-source: usrs.m:37:3: UnexposedStmt= Extent=[37:3 - 37:16]
// CHECK-source: usrs.m:37:14: VarDecl=z:37:14 Extent=[37:10 - 37:15]
// CHECK-source: usrs.m:38:3: UnexposedStmt= Extent=[38:3 - 38:11]
// CHECK-source: usrs.m:38:10: UnexposedExpr= Extent=[38:10 - 38:11]
// CHECK-source: usrs.m:38:10: UnexposedExpr= Extent=[38:10 - 38:11]
// CHECK-source: usrs.m:40:1: ObjCClassMethodDecl=kingkong:40:1 (Definition) [Overrides @30:1] Extent=[40:1 - 43:2]
// CHECK-source: usrs.m:40:4: TypeRef=id:0:0 Extent=[40:4 - 40:6]
// CHECK-source: usrs.m:40:17: UnexposedStmt= Extent=[40:17 - 43:2]
// CHECK-source: usrs.m:41:3: UnexposedStmt= Extent=[41:3 - 41:17]
// CHECK-source: usrs.m:41:7: VarDecl=local_var:41:7 (Definition) Extent=[41:3 - 41:16]
// CHECK-source: usrs.m:42:3: UnexposedStmt= Extent=[42:3 - 42:11]
// CHECK-source: usrs.m:42:10: UnexposedExpr= Extent=[42:10 - 42:11]
// CHECK-source: usrs.m:42:10: UnexposedExpr= Extent=[42:10 - 42:11]
// CHECK-source: usrs.m:44:13: ObjCIvarDecl=d1:44:13 (Definition) Extent=[44:13 - 44:15]
// CHECK-source: usrs.m:44:13: UnexposedDecl=d1:31:15 (Definition) Extent=[44:1 - 44:15]
// CHECK-source: usrs.m:47:5: VarDecl=z:47:5 Extent=[47:1 - 47:6]
// CHECK-source: usrs.m:49:12: FunctionDecl=local_func:49:12 (Definition) Extent=[49:12 - 49:43]
// CHECK-source: usrs.m:49:27: ParmDecl=x:49:27 (Definition) Extent=[49:23 - 49:28]
// CHECK-source: usrs.m:49:30: UnexposedStmt= Extent=[49:30 - 49:43]
// CHECK-source: usrs.m:49:32: UnexposedStmt= Extent=[49:32 - 49:40]
// CHECK-source: usrs.m:49:39: DeclRefExpr=x:49:27 Extent=[49:39 - 49:40]
// CHECK-source: usrs.m:51:12: ObjCInterfaceDecl=CWithExt:51:12 Extent=[51:1 - 53:5]
// CHECK-source: usrs.m:52:1: ObjCInstanceMethodDecl=meth1:52:1 Extent=[52:1 - 52:14]
// CHECK-source: usrs.m:52:4: TypeRef=id:0:0 Extent=[52:4 - 52:6]
// CHECK-source: usrs.m:54:12: ObjCCategoryDecl=:54:12 Extent=[54:1 - 56:5]
// CHECK-source: usrs.m:54:12: ObjCClassRef=CWithExt:51:12 Extent=[54:12 - 54:20]
// CHECK-source: usrs.m:55:1: ObjCInstanceMethodDecl=meth2:55:1 Extent=[55:1 - 55:14]
// CHECK-source: usrs.m:55:4: TypeRef=id:0:0 Extent=[55:4 - 55:6]
// CHECK-source: usrs.m:57:12: ObjCCategoryDecl=:57:12 Extent=[57:1 - 59:5]
// CHECK-source: usrs.m:57:12: ObjCClassRef=CWithExt:51:12 Extent=[57:12 - 57:20]
// CHECK-source: usrs.m:58:1: ObjCInstanceMethodDecl=meth3:58:1 Extent=[58:1 - 58:14]
// CHECK-source: usrs.m:58:4: TypeRef=id:0:0 Extent=[58:4 - 58:6]
// CHECK-source: usrs.m:60:12: ObjCCategoryDecl=Bar:60:12 Extent=[60:1 - 62:5]
// CHECK-source: usrs.m:60:12: ObjCClassRef=CWithExt:51:12 Extent=[60:12 - 60:20]
// CHECK-source: usrs.m:61:1: ObjCInstanceMethodDecl=meth4:61:1 Extent=[61:1 - 61:14]
// CHECK-source: usrs.m:61:4: TypeRef=id:0:0 Extent=[61:4 - 61:6]
// CHECK-source: usrs.m:63:1: ObjCImplementationDecl=CWithExt:63:1 (Definition) Extent=[63:1 - 67:2]
// CHECK-source: usrs.m:64:1: ObjCInstanceMethodDecl=meth1:64:1 (Definition) [Overrides @52:1] Extent=[64:1 - 64:27]
// CHECK-source: usrs.m:64:4: TypeRef=id:0:0 Extent=[64:4 - 64:6]
// CHECK-source: usrs.m:64:14: UnexposedStmt= Extent=[64:14 - 64:27]
// CHECK-source: usrs.m:64:16: UnexposedStmt= Extent=[64:16 - 64:24]
// CHECK-source: usrs.m:64:23: UnexposedExpr= Extent=[64:23 - 64:24]
// CHECK-source: usrs.m:64:23: UnexposedExpr= Extent=[64:23 - 64:24]
// CHECK-source: usrs.m:65:1: ObjCInstanceMethodDecl=meth2:65:1 (Definition) [Overrides @55:1] Extent=[65:1 - 65:27]
// CHECK-source: usrs.m:65:4: TypeRef=id:0:0 Extent=[65:4 - 65:6]
// CHECK-source: usrs.m:65:14: UnexposedStmt= Extent=[65:14 - 65:27]
// CHECK-source: usrs.m:65:16: UnexposedStmt= Extent=[65:16 - 65:24]
// CHECK-source: usrs.m:65:23: UnexposedExpr= Extent=[65:23 - 65:24]
// CHECK-source: usrs.m:65:23: UnexposedExpr= Extent=[65:23 - 65:24]
// CHECK-source: usrs.m:66:1: ObjCInstanceMethodDecl=meth3:66:1 (Definition) [Overrides @58:1] Extent=[66:1 - 66:27]
// CHECK-source: usrs.m:66:4: TypeRef=id:0:0 Extent=[66:4 - 66:6]
// CHECK-source: usrs.m:66:14: UnexposedStmt= Extent=[66:14 - 66:27]
// CHECK-source: usrs.m:66:16: UnexposedStmt= Extent=[66:16 - 66:24]
// CHECK-source: usrs.m:66:23: UnexposedExpr= Extent=[66:23 - 66:24]
// CHECK-source: usrs.m:66:23: UnexposedExpr= Extent=[66:23 - 66:24]
// CHECK-source: usrs.m:68:1: ObjCCategoryImplDecl=Bar:68:1 (Definition) Extent=[68:1 - 70:2]
// CHECK-source: usrs.m:68:1: ObjCClassRef=CWithExt:51:12 Extent=[68:1 - 68:2]
// CHECK-source: usrs.m:69:1: ObjCInstanceMethodDecl=meth4:69:1 (Definition) [Overrides @61:1] Extent=[69:1 - 69:27]
// CHECK-source: usrs.m:69:4: TypeRef=id:0:0 Extent=[69:4 - 69:6]
// CHECK-source: usrs.m:69:14: UnexposedStmt= Extent=[69:14 - 69:27]
// CHECK-source: usrs.m:69:16: UnexposedStmt= Extent=[69:16 - 69:24]
// CHECK-source: usrs.m:69:23: UnexposedExpr= Extent=[69:23 - 69:24]
// CHECK-source: usrs.m:69:23: UnexposedExpr= Extent=[69:23 - 69:24]
// CHECK-source: usrs.m:72:6: FunctionDecl=aux_1:72:6 Extent=[72:6 - 72:26]
// CHECK-source: usrs.m:72:15: ParmDecl=:72:15 (Definition) Extent=[72:12 - 72:16]
// CHECK-source: usrs.m:72:20: ParmDecl=:72:20 (Definition) Extent=[72:17 - 72:21]
// CHECK-source: usrs.m:72:25: ParmDecl=:72:25 (Definition) Extent=[72:22 - 72:26]
// CHECK-source: usrs.m:73:5: FunctionDecl=test_multi_declaration:73:5 (Definition) Extent=[73:5 - 77:2]
// CHECK-source: usrs.m:73:34: UnexposedStmt= Extent=[73:34 - 77:2]
// CHECK-source: usrs.m:74:3: UnexposedStmt= Extent=[74:3 - 74:33]
// CHECK-source: usrs.m:74:7: VarDecl=foo:74:7 (Definition) Extent=[74:3 - 74:14]
// CHECK-source: usrs.m:74:13: UnexposedExpr= Extent=[74:13 - 74:14]
// CHECK-source: usrs.m:74:16: VarDecl=bar:74:16 Extent=[74:16 - 74:23]
// CHECK-source: usrs.m:74:22: UnexposedExpr= Extent=[74:22 - 74:23]
// CHECK-source: usrs.m:74:25: VarDecl=baz:74:25 Extent=[74:25 - 74:32]
// CHECK-source: usrs.m:74:31: UnexposedExpr= Extent=[74:31 - 74:32]
// CHECK-source: usrs.m:75:3: CallExpr=aux_1:72:6 Extent=[75:3 - 75:23]
// CHECK-source: usrs.m:75:3: UnexposedExpr=aux_1:72:6 Extent=[75:3 - 75:8]
// CHECK-source: usrs.m:75:3: DeclRefExpr=aux_1:72:6 Extent=[75:3 - 75:8]
// CHECK-source: usrs.m:75:9: DeclRefExpr=foo:74:7 Extent=[75:9 - 75:12]
// CHECK-source: usrs.m:75:14: DeclRefExpr=bar:74:16 Extent=[75:14 - 75:17]
// CHECK-source: usrs.m:75:19: DeclRefExpr=baz:74:25 Extent=[75:19 - 75:22]
// CHECK-source: usrs.m:76:3: UnexposedStmt= Extent=[76:3 - 76:11]
// CHECK-source: usrs.m:76:10: UnexposedExpr= Extent=[76:10 - 76:11]
// CHECK-source: usrs.m:79:1: ObjCProtocolDecl=P1:79:1 (Definition) Extent=[79:1 - 81:5]
// CHECK-source: usrs.m:80:1: ObjCInstanceMethodDecl=method:80:1 Extent=[80:1 - 80:16]
