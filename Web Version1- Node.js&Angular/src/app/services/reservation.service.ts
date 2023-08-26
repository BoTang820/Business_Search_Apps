import { Injectable } from '@angular/core';
import { Subject } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ReservationService {
  private reservations = new Subject();
  public reservations$ = this.reservations.asObservable();

  ls = localStorage;

  constructor() {}

  makeReservation(
    key: string,
    businessName: string,
    date: string,
    time: string,
    email: string
  ) {
    let newReservation = {
      businessName: businessName,
      date: date,
      time: time,
      email: email,
      key: key,
    };
    this.ls.setItem(key, JSON.stringify(newReservation));
    this.updateReservationList();
  }

  cancelReservation(key: string) {
    this.ls.removeItem(key);
    this.updateReservationList();
  }

  updateReservationList() {
    var values = [],
      keys = Object.keys(localStorage),
      i = keys.length;

    while (i--) {
      values.push(JSON.parse(localStorage.getItem(keys[i])!));
    }
    console.log(values);
    this.reservations.next(values);
  }

  isReserved(key: string) {
    return this.ls.getItem(key) != null;
  }
}
