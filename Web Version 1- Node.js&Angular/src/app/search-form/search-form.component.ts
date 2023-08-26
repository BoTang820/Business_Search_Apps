import { Component, OnInit, ViewChild } from '@angular/core';
import { FormControl, NgForm } from '@angular/forms';
import { BusinessSearchService } from '../services/business-search.service';
import { lastValueFrom, map } from 'rxjs';

import {
  debounceTime,
  tap,
  switchMap,
  finalize,
  distinctUntilChanged,
  filter,
} from 'rxjs/operators';

@Component({
  selector: 'app-search-form',
  templateUrl: './search-form.component.html',
  styleUrls: ['./search-form.component.css'],
})
export class SearchFormComponent implements OnInit {
  @ViewChild('searchForm') searchForm!: NgForm;

  inputKeywordControl = new FormControl();
  filteredKeywords: any;
  isLoading = false;
  selectedKeyword: any = '';

  constructor(private businessSearchService: BusinessSearchService) {}
  defaultCategory = 'Default';
  currentLoc = '';
  autoDetectEnabled = false;
  businessesArray = [];
  inputLocation = '';

  onSelected() {
    console.log(this.selectedKeyword);
    console.log(this.inputKeywordControl.value);

    this.selectedKeyword = this.selectedKeyword;
  }

  displayWith(value: any) {
    return value?.text;
  }

  ngOnInit(): void {
    this.businessSearchService.getIpInfo().subscribe((data: any) => {
      // console.log(data);
      this.currentLoc = data.loc;
      // console.log(typeof this.currentLoc);
    });
    this.inputKeywordControl.valueChanges
      .pipe(
        filter((res) => {
          return res !== null && res.length >= 1;
        }),
        distinctUntilChanged(),
        debounceTime(1000),
        tap(() => {
          this.filteredKeywords = [];
          this.isLoading = true;
        }),
        switchMap((value) =>
          this.businessSearchService.getAutocomplete(value).pipe(
            finalize(() => {
              this.isLoading = false;
            })
          )
        )
      )
      .subscribe((data: any) => {
        this.filteredKeywords = [];
        for (let element of data) {
          console.log(element.text);
          this.filteredKeywords.push(element.text);
        }
      });
  }

  async onSubmit() {
    this.businessesArray = [];
    const value = this.searchForm.value;

    let keyword = this.inputKeywordControl.value;

    let distanceNumber = 16090;
    if (value.inputDistance !== '') {
      distanceNumber = value.inputDistance * 1609;
    }

    let distance = distanceNumber.toString();

    let category = 'all';
    if (value.inputCategory === 'Arts & Entertainment') {
      category = 'arts';
    } else if (value.inputCategory === 'Health & Medical') {
      category = 'health';
    } else if (value.inputCategory === 'Hotels & Travel') {
      category = 'hotelstravel';
    } else if (value.inputCategory === 'Food') {
      category = 'food';
    } else if (value.inputCategory === 'Professional Services') {
      category = 'professional';
    }

    let location = value.inputLocation || '';

    let autoDetect = this.autoDetectEnabled;

    let currentLoc = this.currentLoc;

    this.businessSearchService.getSearchResult(
      keyword,
      distance,
      category,
      location,
      autoDetect,
      currentLoc
    );

    this.resetForm();
  }

  clearInputLocation() {
    this.inputLocation = '';
  }

  resetForm() {
    this.searchForm.reset({ inputCategory: this.defaultCategory });
    this.inputKeywordControl.reset();
    this.businessSearchService.clearResults();
  }
}
