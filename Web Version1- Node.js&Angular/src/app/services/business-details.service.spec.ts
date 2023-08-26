import { TestBed } from '@angular/core/testing';

import { BusinessDetailsService } from './business-details.service';

describe('BusinessDetailsService', () => {
  let service: BusinessDetailsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BusinessDetailsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
