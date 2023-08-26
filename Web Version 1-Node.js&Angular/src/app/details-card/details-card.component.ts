import { Component, OnDestroy, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { BusinessDetailsService } from '../services/business-details.service';
import { ReservationService } from '../services/reservation.service';
let map: google.maps.Map;

@Component({
  selector: 'app-details-card',
  templateUrl: './details-card.component.html',
  styleUrls: ['./details-card.component.css'],
})
export class DetailsCardComponent implements OnInit, OnDestroy {
  reviewsSubscription: Subscription;
  detailsSubscription: Subscription;
  reservationSubscription: Subscription;

  name = '';
  address = '';
  category = '';
  phone = '';
  priceRange = '';
  status = '';
  link = '';
  photo0 = '';
  photo1 = '';
  photo2 = '';
  coordinates: any;
  businessId = '';

  isReserved = false;

  showMap = false;

  reviews: any[] = [];

  mapOptions: google.maps.MapOptions = {
    center: { lat: 38.9987208, lng: -77.2538699 },
    zoom: 14,
  };
  marker = {
    position: { lat: 38.9987208, lng: -77.2538699 },
  };

  constructor(
    private businessDetailsService: BusinessDetailsService,
    private reservationService: ReservationService
  ) {
    this.detailsSubscription =
      this.businessDetailsService.businessDetails$.subscribe((data) => {
        // console.log(data);
        let res: any = data;

        this.showMap = false;

        this.name = res.name;
        this.address = res.location.display_address;
        let tempCategory = res.categories;
        const categoryLength = tempCategory.length;
        let resCategory = '';
        if (categoryLength > 0) {
          for (let i = 0; i < categoryLength - 1; i++) {
            if (tempCategory[i].title) {
              resCategory += tempCategory[i].title + ' | ';
            }
          }
          resCategory += tempCategory[categoryLength - 1].title;
        }
        this.category = resCategory;
        this.phone = res.display_phone;
        this.priceRange = res.price;

        if (res.hours != undefined) {
          const isOpen = res.hours[0].is_open_now;
          if (isOpen == true) {
            this.status = 'Open now';
          } else {
            this.status = 'Closed';
          }
        } else {
          this.status = '';
        }

        this.link = res.url;
        let photosUrl = res.photos;
        this.photo0 = photosUrl[0];
        this.photo1 = photosUrl[1];
        this.photo2 = photosUrl[2];

        this.coordinates = res.coordinates;

        this.businessId = res.id;

        this.mapOptions.center!.lat = this.coordinates.latitude;
        this.mapOptions.center!.lng = this.coordinates.longitude;

        this.marker.position.lat = this.coordinates.latitude;
        this.marker.position.lng = this.coordinates.longitude;

        // console.log(this.mapOptions, this.marker);

        this.showMap = true;
      });
    this.reviewsSubscription =
      this.businessDetailsService.businessReviews$.subscribe((data) => {
        let res: any = data;
        this.reviews = res.reviews;
        // console.log('Length: ', this.reviews.length, this.reviews);
      });

    this.reservationSubscription =
      this.reservationService.reservations$.subscribe((data) => {
        this.isReserved = this.reservationService.isReserved(this.businessId);
        console.log(this.isReserved);
      });
  }

  cancelReservation() {
    window.alert('Reservation cancelled!');

    this.reservationService.cancelReservation(this.businessId);
  }

  goBack() {
    this.businessDetailsService.backToTable();
  }

  ngOnInit(): void {
    this.businessDetailsService.loadCard();
    this.isReserved = this.reservationService.isReserved(this.businessId);
  }

  ngOnDestroy(): void {
    this.detailsSubscription.unsubscribe();
    this.reviewsSubscription.unsubscribe();
    this.reservationSubscription.unsubscribe();
  }
}

// console.log(
//   res.name,
//   res.location.display_address,
//   res.categories,
//   res.display_phone,
//   res.price,
//   res.hours[0].is_open_now,
//   res.url,
//   res.photos,
//   res.coordinates.latitude
// );

// console.log(
//   this.name,
//   this.address,
//   this.category,
//   this.phone,
//   this.priceRange,
//   this.status,
//   this.link,
//   this.photo0,
//   this.photo1,
//   this.photo2
// );

// res = {
//   id: 'hC745S5W4HTq606ySmBJNw',
//   alias: 'kazunori-the-original-hand-roll-bar-los-angeles',
//   name: 'KazuNori  | The Original Hand Roll Bar',
//   image_url:
//     'https://s3-media3.fl.yelpcdn.com/bphoto/9D63gCmIesyBQO15NNG9Xw/o.jpg',
//   is_claimed: true,
//   is_closed: false,
//   url: 'https://www.yelp.com/biz/kazunori-the-original-hand-roll-bar-los-angeles?adjust_creative=u-SCICF4SHao8FzGwjWh1Q&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=u-SCICF4SHao8FzGwjWh1Q',
//   phone: '+12134936956',
//   display_phone: '(213) 493-6956',
//   review_count: 3190,
//   categories: [
//     { alias: 'sushi', title: 'Sushi Bars' },
//     { alias: 'japanese', title: 'Japanese' },
//   ],
//   rating: 4.5,
//   location: {
//     address1: '421 S Main St',
//     address2: '',
//     address3: '',
//     city: 'Los Angeles',
//     zip_code: '90013',
//     country: 'US',
//     state: 'CA',
//     display_address: ['421 S Main St', 'Los Angeles, CA 90013'],
//     cross_streets: '',
//   },
//   coordinates: { latitude: 34.0476390576719, longitude: -118.247747561303 },
//   photos: [
//     'https://s3-media3.fl.yelpcdn.com/bphoto/9D63gCmIesyBQO15NNG9Xw/o.jpg',
//     'https://s3-media2.fl.yelpcdn.com/bphoto/olg_kr395I-XxtSIS_vVZg/o.jpg',
//     'https://s3-media3.fl.yelpcdn.com/bphoto/eVKpFz-g2aBR5MubQnnb7w/o.jpg',
//   ],
//   price: '$$',
//   hours: [
//     {
//       open: [
//         { is_overnight: false, start: '1130', end: '2300', day: 0 },
//         { is_overnight: false, start: '1130', end: '2300', day: 1 },
//         { is_overnight: false, start: '1130', end: '2300', day: 2 },
//         { is_overnight: false, start: '1130', end: '2300', day: 3 },
//         { is_overnight: false, start: '1130', end: '0000', day: 4 },
//         { is_overnight: false, start: '1130', end: '0000', day: 5 },
//         { is_overnight: false, start: '1200', end: '2200', day: 6 },
//       ],
//       hours_type: 'REGULAR',
//       is_open_now: true,
//     },
//   ],
//   transactions: ['delivery'],
//   messaging: {
//     url: 'https://www.yelp.com/raq/hC745S5W4HTq606ySmBJNw?adjust_creative=u-SCICF4SHao8FzGwjWh1Q&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=u-SCICF4SHao8FzGwjWh1Q#popup%3Araq',
//     use_case_text: 'Message the Business',
//   },
// };
