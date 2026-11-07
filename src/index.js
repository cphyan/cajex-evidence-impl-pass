// A fixture for code scanning: plain code with nothing for a scanner to find. Never run.
'use strict';

function total(prices) {
  return prices.reduce((sum, p) => sum + Number(p), 0);
}

module.exports = { total };
