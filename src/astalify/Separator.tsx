import GObject from "gi://GObject";
import { Gtk, astalify, type ConstructProps } from "astal/gtk3";

// subclass, register, define constructor props
export default class Separator extends astalify(Gtk.Separator) {
  static {
    GObject.registerClass(this);
  }

  constructor(
    props: ConstructProps<Separator, Gtk.Separator.ConstructorProps>,
  ) {
    super(props as any);
  }
}
