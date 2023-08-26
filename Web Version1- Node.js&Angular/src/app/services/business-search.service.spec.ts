import { TestBed } from '@angular/core/testing';

import { BusinessSearchService } from './business-search.service';

describe('BusinessSearchService', () => {
  let service: BusinessSearchService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BusinessSearchService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
