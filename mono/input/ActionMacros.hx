package mono.input;

import haxe.macro.Expr;
import haxe.macro.Context;
using haxe.macro.Tools;

class ActionMacros {
     
     #if macro
     // gets the fields of an enum abstract (Array<ClassField>)
	static function getFields(e:Expr) {
		// ty kevinresol
		return switch Context.follow(Context.getType(e.toString())) {
			case TAbstract(_.get() => {meta: meta, impl: impl}, _) if(meta.has(':enum')):
				impl.get().statics.get()
				.filter(function(s) return s.meta.has(':enum') && s.meta.has(':impl'));
			default:
				Context.error('Only applicable to @:enum abstract', e.pos);
		}
	}
	#end
	
     // counts the fields of an enum abstract
	public static macro function count(e:Expr) {
		return macro $v{getFields(e).length}
	}
     
     // adds the supplied enum abstract's fields to the attached class, as getters to the corresponding Bool value
	public static macro function buildInput(e:Expr):Array<Field> {
          
		var efields = getFields(e);
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
          
		for (en in efields) {
			
			var name = en.name;
			
               // this gets the actual integer value of the abstract
               // maybe this can be compressed some more
			var index:Int = switch (en.expr().expr) {
                    case TCast(_ => { expr : expr }, _):
                         switch (expr) {
                              case TConst(TInt(myInt)):
                                   myInt;
                              default:
                                   Context.error("Error I don't understand", e.pos);
                         }
                    default:
                       Context.error("Error I don't understand", e.pos);
               }
               
               // this is the inline getter function contents, using the previously acquired index
               var myFunc:Function = {
                    args: [],
                    ret: macro:Bool,
                    expr: macro return this.get($v{index})
               };

               // this is the inline getter function definition
               var getter:Field = {
                    name: "get_" + name,
                    access: [Access.APrivate, Access.AInline],
                    kind: FieldType.FFun(myFunc),
                    pos: pos
               };

               // this is the actual property, with (get,never) access
               var prop:Field = {
                    name: name,
                    access: [Access.APublic],
                    kind: FieldType.FProp("get", "never", myFunc.ret),
                    pos: pos
               };

               // add the property and the getter
               fields.push(prop);
               fields.push(getter);
          }

          return fields;
	}
}