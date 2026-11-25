const request = require('supertest');
const app = require('../index');

describe('GET /health', () => {
  test('returns status 200', async () => {
    const response = await request(app).get('/health');

    expect(response.status).toBe(200);
  });
});
