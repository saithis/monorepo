import { test, expect } from '@playwright/test';

test.describe('API Tests', () => {
  test('should return weather forecast data', async ({ request }) => {
    const response = await request.get('/WeatherForecast');
    
    expect(response.ok()).toBeTruthy();
    
    const data = await response.json();
    expect(Array.isArray(data)).toBeTruthy();
    expect(data.length).toBeGreaterThan(0);
    
    const firstItem = data[0];
    expect(firstItem).toHaveProperty('date');
    expect(firstItem).toHaveProperty('temperatureC');
    expect(firstItem).toHaveProperty('temperatureF');
    expect(firstItem).toHaveProperty('summary');
  });

  test('should return 404 for non-existent endpoint', async ({ request }) => {
    const response = await request.get('/NonExistent');
    expect(response.status()).toBe(404);
  });
});
