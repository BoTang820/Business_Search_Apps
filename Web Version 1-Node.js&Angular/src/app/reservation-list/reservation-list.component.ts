import { Component, OnInit } from '@angular/core';
import { Subscribable, Subscription } from 'rxjs';
import { ReservationService } from '../services/reservation.service';

@Component({
  selector: 'app-reservation-list',
  templateUrl: './reservation-list.component.html',
  styleUrls: ['./reservation-list.component.css'],
})
export class ReservationListComponent implements OnInit {
  reservationsArray: any = [];
  reservationSubscription: Subscription;

  constructor(private reservationService: ReservationService) {
    this.reservationSubscription =
      this.reservationService.reservations$.subscribe((data) => {
        this.reservationsArray = data;
        console.log('reservationsArray: ', this.reservationsArray);
      });
  }

  ngOnInit(): void {
    this.reservationService.updateReservationList();
  }

  cancelReservation(key: string) {
    console.log(key);

    window.alert('Reservation cancelled!');

    this.reservationService.cancelReservation(key);
  }
}
