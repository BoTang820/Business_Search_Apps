import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { lastValueFrom, Subject } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class BusinessDetailsService {
  constructor(private http: HttpClient) {}
  private businessDetailsApi =
    'https://hw8-botang.uc.r.appspot.com/api/businessDetails';
  private businessReviewsApi =
    'https://hw8-botang.uc.r.appspot.com/api/businessReviews';

  private businessDetails = new Subject();
  public businessDetails$ = this.businessDetails.asObservable();

  private businessReviews = new Subject();
  public businessReviews$ = this.businessReviews.asObservable();

  private showTable = new Subject();
  public showTable$ = this.showTable.asObservable();

  private showDetails = new Subject();
  public showDetails$ = this.showDetails.asObservable();

  reviews: any;
  details: any;

  async getDetails(id: string) {
    const response$ = this.http.get(this.businessDetailsApi + '?id=' + id);
    this.details = await lastValueFrom(response$);
    console.log(this.details);

    this.businessDetails.next(this.details);
    this.showDetails.next('card');
  }

  async getReviews(id: string) {
    const response$ = this.http.get(this.businessReviewsApi + '?id=' + id);
    this.reviews = await lastValueFrom(response$);
    console.log(this.reviews);
    this.businessReviews.next(this.reviews);
  }

  async loadCard() {
    this.businessDetails.next(this.details);
    if (this.reviews != undefined) {
      console.log(this.reviews);
      this.businessReviews.next(this.reviews);
    }
  }

  backToTable() {
    this.showTable.next('table');
  }
}
