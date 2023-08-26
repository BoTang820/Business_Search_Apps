import { Component, OnDestroy, OnInit } from '@angular/core';
import { config, Subscription } from 'rxjs';
import { BusinessDetailsService } from '../services/business-details.service';
import { BusinessSearchService } from '../services/business-search.service';

@Component({
  selector: 'app-result-table',
  templateUrl: './result-table.component.html',
  styleUrls: ['./result-table.component.css'],
})
export class ResultTableComponent implements OnInit, OnDestroy {
  businessesArray: any = [];
  searchSubscription$: Subscription;

  constructor(
    private businessSearchService: BusinessSearchService,
    private businessDetailsService: BusinessDetailsService
  ) {
    this.searchSubscription$ =
      this.businessSearchService.businessesArray$.subscribe((data) => {
        console.log(data);
        this.businessesArray = data;
        this.businessesArray = this.businessesArray.slice(1, 11);
      });
  }

  getDetails(id: string) {
    this.businessDetailsService.getReviews(id);
    this.businessDetailsService.getDetails(id);
  }

  ngOnInit(): void {
    this.businessSearchService.loadTable();
  }

  ngOnDestroy(): void {
    this.searchSubscription$.unsubscribe();
  }
}
