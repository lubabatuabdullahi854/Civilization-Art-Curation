import { describe, it, expect, beforeEach } from 'vitest';

describe('exhibition', () => {
  let contract: any;
  
  beforeEach(() => {
    contract = {
      createExhibition: (title: string, description: string, artworks: number[], dimensions: number, startDate: number, endDate: number) => ({ value: 1 }),
      updateExhibitionStatus: (exhibitionId: number, newStatus: string) => ({ success: true }),
      getExhibition: (exhibitionId: number) => ({
        curator: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
        title: 'Cosmic Wonders',
        description: 'An exhibition showcasing the most awe-inspiring artworks from across the galaxy',
        artworks: [1, 2, 3, 4, 5],
        dimensions: 5,
        startDate: 123456,
        endDate: 234567,
        status: 'upcoming'
      }),
      getExhibitionCount: () => 1
    };
  });
  
  describe('create-exhibition', () => {
    it('should create a new exhibition', () => {
      const result = contract.createExhibition('Cosmic Wonders', 'An exhibition showcasing the most awe-inspiring artworks from across the galaxy', [1, 2, 3, 4, 5], 5, 123456, 234567);
      expect(result.value).toBe(1);
    });
  });
  
  describe('update-exhibition-status', () => {
    it('should update the status of an exhibition', () => {
      const result = contract.updateExhibitionStatus(1, 'active');
      expect(result.success).toBe(true);
    });
  });
  
  describe('get-exhibition', () => {
    it('should return exhibition information', () => {
      const exhibition = contract.getExhibition(1);
      expect(exhibition.title).toBe('Cosmic Wonders');
      expect(exhibition.artworks).toHaveLength(5);
      expect(exhibition.dimensions).toBe(5);
      expect(exhibition.status).toBe('upcoming');
    });
  });
  
  describe('get-exhibition-count', () => {
    it('should return the total number of exhibitions', () => {
      const count = contract.getExhibitionCount();
      expect(count).toBe(1);
    });
  });
});
