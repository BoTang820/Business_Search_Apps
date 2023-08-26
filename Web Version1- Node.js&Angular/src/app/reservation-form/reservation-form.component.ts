import { formatCurrency } from '@angular/common';
import { ThisReceiver } from '@angular/compiler';
import {
  Component,
  ElementRef,
  Input,
  OnDestroy,
  OnInit,
  ViewChild,
} from '@angular/core';
import { NgForm } from '@angular/forms';
import { Subscription } from 'rxjs';
import { BusinessDetailsService } from '../services/business-details.service';
import { ReservationService } from '../services/reservation.service';

declare function resetForm(): any;

export class Reservation {
  public email!: string;
  public date!: string;
  public time!: string;
}

@Component({
  selector: 'app-reservation-form',
  templateUrl: './reservation-form.component.html',
  styleUrls: ['./reservation-form.component.css'],
})
export class ReservationFormComponent implements OnInit, OnDestroy {
  @ViewChild('reservationForm') reservationForm!: NgForm;

  @ViewChild('closeModal') closeModal!: ElementRef;

  wasValidated: any;

  form = document.getElementById('reservationForm');

  validateFormScript: HTMLScriptElement;

  reservation = new Reservation();

  detailsSubscription: Subscription;

  reservationSubscription: Subscription;

  businessName = 'Dummy Name Here';

  businessId = '';

  constructor(
    private businessDetailsService: BusinessDetailsService,
    private reservationService: ReservationService
  ) {
    this.detailsSubscription =
      this.businessDetailsService.businessDetails$.subscribe((data) => {
        let res: any;
        res = data;
        this.businessName = res.name;
        this.businessId = res.id;
      });
    this.validateFormScript = document.createElement('script');
    this.validateFormScript.src = '../assets/scripts/validateForm.js';

    document.body.appendChild(this.validateFormScript);

    this.reservationSubscription =
      this.reservationService.reservations$.subscribe((data) => {});
  }

  onSubmit() {
    console.log(this.reservationForm);
    console.log(
      this.businessId,
      this.businessName,
      this.reservation.date,
      this.reservation.time,
      this.reservation.email
    );

    if (this.reservationForm.valid) {
      console.log('Form is valid!');

      this.reservationService.makeReservation(
        this.businessId,
        this.businessName,
        this.reservation.date,
        this.reservation.time,
        this.reservation.email
      );
    }

    // this.hideModel();

    // if (this.reservationForm.valid) {
    //   this.reservationForm.reset();
    //   resetForm();
    // this.onClose();
    // }
  }

  makeReservation(
    key: string,
    businessName: string,
    date: string,
    time: string,
    email: string
  ) {}

  onClose() {
    resetForm();
  }

  hideModel() {
    // console.log(this.closeModal.nativeElement);
    // console.log(this.closeModal.nativeElement.click);
    this.closeModal.nativeElement.click();
  }

  ngOnInit(): void {
    console.log(this.form);
  }

  ngOnDestroy(): void {
    this.detailsSubscription.unsubscribe();
    this.reservationSubscription.unsubscribe();
  }
}
