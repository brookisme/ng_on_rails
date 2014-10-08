describe('Foo', function() {
  it('does something', function() {
    expect(1 + 1).toBe(2);
  });

  it('does fail', function() {
    expect(1 + 1).toBe(5);
  });
});

describe('Bar', function() {
  it('does fail', function() {
    expect(1 + 1).toBe(3);
  });
});