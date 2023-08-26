import { Injectable } from '@angular/core';

import { HttpClient, HttpParams } from '@angular/common/http';
import { lastValueFrom, Subject } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class BusinessSearchService {
  constructor(private http: HttpClient) {}
  private businessSearchApi =
    'https://hw8-botang.uc.r.appspot.com/api/businessSearch';
  private geoCodeApi = 'https://hw8-botang.uc.r.appspot.com/api/geoCode';
  private autocompleteApi =
    'https://hw8-botang.uc.r.appspot.com/api/autocomplete';
  private businessData: any;

  private businessesArray = new Subject();
  public businessesArray$ = this.businessesArray.asObservable();

  private showTable = new Subject();
  public showTable$ = this.showTable.asObservable();

  private isDirty = new Subject();
  public isDirty$ = this.isDirty.asObservable();

  async getSearchResult(
    keyword: string,
    distance: string,
    category: string,
    location: string,
    autoDetect: boolean,
    currentLoc: string
  ) {
    console.log(
      'keyword: ' + keyword,
      ', distance: ' + distance,
      ', category: ' + category,
      ', location: ' + location,
      ', autoDetect: ' + autoDetect,
      ', currentLoc: ' + currentLoc
    );

    let lat;
    let lng;
    if (autoDetect) {
      lat = currentLoc.split(',')[0];
      lng = currentLoc.split(',')[1];
    } else {
      const response$ = this.getGeoCode(location);
      const tempLocation: any = await lastValueFrom(response$);
      if (tempLocation['status'] != 'ZERO_RESULTS') {
        lat = tempLocation['results'][0]['geometry']['location']['lat'];
        lng = tempLocation['results'][0]['geometry']['location']['lng'];
      } else {
        lat = undefined;
        lng = undefined;
      }
    }

    // console.log(lat, lng);

    if (lat == undefined) {
      this.businessData = [];
    } else {
      let params = new HttpParams()
        .set('term', keyword)
        .set('categories', category)
        .set('latitude', lat)
        .set('longitude', lng)
        .set('radius', distance);

      const businessesResponse$ = this.http.get(this.businessSearchApi, {
        params: params,
      });

      const tempBusiness: any = await lastValueFrom(businessesResponse$);
      this.businessData = tempBusiness['businesses'];
    }
    this.businessesArray.next(this.businessData);
    this.showTable.next('table');
    this.isDirty.next(true);
  }

  loadTable() {
    this.businessesArray.next(this.businessData);
  }

  getIpInfo() {
    const ipinfoApi = 'https://ipinfo.io/json?token=3317efadd4e11f';
    return this.http.get(ipinfoApi);
  }

  getGeoCode(location: string) {
    let params = new HttpParams().set('location', location);
    return this.http.get(this.geoCodeApi, { params: params });
  }

  getAutocomplete(text: string) {
    let params = new HttpParams().set('text', text);
    return this.http.get(this.autocompleteApi, { params: params });
  }

  clearResults() {
    this.isDirty.next(false);
  }
}
