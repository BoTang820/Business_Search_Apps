import { Component, OnInit } from '@angular/core';
import { BusinessDetailsService } from '../services/business-details.service';
import { BusinessSearchService } from '../services/business-search.service';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css'],
})
export class SearchComponent implements OnInit {
  dirty: any;
  componentToShow: any;

  constructor(
    private businessSearchService: BusinessSearchService,
    private businessDetailsService: BusinessDetailsService
  ) {
    this.businessSearchService.isDirty$.subscribe((data) => {
      this.dirty = data;
    });
    this.businessSearchService.showTable$.subscribe((data) => {
      this.componentToShow = data;
    });
    this.businessDetailsService.showDetails$.subscribe((data) => {
      this.componentToShow = data;
    });
    this.businessDetailsService.showTable$.subscribe((data) => {
      this.componentToShow = data;
    });
  }

  ngOnInit(): void {}
}
