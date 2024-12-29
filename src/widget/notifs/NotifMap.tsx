// Copied from https://github.com/Aylur/astal/tree/main/examples

import { Gtk } from "astal/gtk3";
import Notifd from "gi://AstalNotifd";
import { NotifWidget } from "./NotifWidget";
import { type Subscribable } from "astal/binding";
import { Variable, timeout } from "astal";

const NOTIF_TRANSITION_DURATION = 300;

export const WIDTH = 300;

export class NotifMap implements Subscribable {
  private map: Map<number, Gtk.Widget> = new Map();
  private var: Variable<Array<Gtk.Widget>> = Variable([]);

  private notify() {
    this.var.set([...this.map.values()].reverse());
  }

  constructor(notifCentre = false) {
    const notifd = Notifd.get_default();

    // :(
    if (notifCentre) {
      notifd.get_notifications().map((n) => {
        this.set(
          n.id,
          NotifWidget({
            notif: n,
            transition: NOTIF_TRANSITION_DURATION,
            setup: () => {},
          }),
        );
      });
    }

    notifd.connect("notified", (_, id) => {
      if (notifd.get_dont_disturb()) {
        return;
      }
      const notif = notifd.get_notification(id)!;

      const expire =
        notif.get_expire_timeout() > 0
          ? notif.get_expire_timeout() * 1000
          : 3000;

      // Deserves a nobel prize
      const setup = notifCentre
        ? () => {}
        : () =>
            timeout(expire, () => {
              this.delete(id);
            });

      this.set(
        id,
        NotifWidget({
          notif: notif,
          transition: NOTIF_TRANSITION_DURATION,
          setup: setup,
        }),
      );
    });

    notifd.connect("resolved", (_, id) => {
      this.delete(id);
    });
  }

  private set(key: number, value: Gtk.Widget) {
    // in case of replacecment destroy previous widget
    this.map.get(key)?.destroy();
    this.map.set(key, value);
    this.notify();
  }

  private delete(key: number) {
    const notif = this.map.get(key);

    if (notif == null) return;

    const revealerWrapper = notif as Gtk.Revealer;

    revealerWrapper.revealChild = false;

    timeout(NOTIF_TRANSITION_DURATION, () => {
      notif.destroy();
      this.map.delete(key);
      this.notify();
    });
  }

  get() {
    return this.var.get();
  }

  subscribe(callback: (list: Array<Gtk.Widget>) => void) {
    return this.var.subscribe(callback);
  }
}
