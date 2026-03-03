// Storage Units Tracking

let storageUnits = [
  {
    id: 1,
    location: "Las Vegas, NV",
    unitNumber: "Unit 1",
    facility: "",
    size: "",
    monthlyFee: 0,
    contents: "",
    startDate: null,
    nextPayment: null,
    status: "active"
  },
  {
    id: 2,
    location: "Las Vegas, NV",
    unitNumber: "Unit 2",
    facility: "",
    size: "",
    monthlyFee: 0,
    contents: "",
    startDate: null,
    nextPayment: null,
    status: "active"
  },
  {
    id: 3,
    location: "Las Vegas, NV",
    unitNumber: "Unit 3",
    facility: "",
    size: "",
    monthlyFee: 0,
    contents: "",
    startDate: null,
    nextPayment: null,
    status: "active"
  },
  {
    id: 4,
    location: "Minnesota",
    unitNumber: "Unit 1",
    facility: "",
    size: "",
    monthlyFee: 0,
    contents: "",
    startDate: null,
    nextPayment: null,
    status: "active"
  },
  {
    id: 5,
    location: "Minnesota",
    unitNumber: "Unit 2",
    facility: "",
    size: "",
    monthlyFee: 0,
    contents: "",
    startDate: null,
    nextPayment: null,
    status: "active"
  },
  {
    id: 6,
    location: "Florida",
    unitNumber: "Unit 1",
    facility: "",
    size: "",
    monthlyFee: 0,
    contents: "",
    startDate: null,
    nextPayment: null,
    status: "active"
  }
];

function renderStorageUnits() {
  const container = document.getElementById('storage-units-list');
  if (!container) return;

  const byLocation = {
    'Las Vegas, NV': storageUnits.filter(u => u.location === 'Las Vegas, NV'),
    'Minnesota': storageUnits.filter(u => u.location === 'Minnesota'),
    'Florida': storageUnits.filter(u => u.location === 'Florida')
  };

  const totalMonthly = storageUnits.reduce((sum, u) => sum + (u.monthlyFee || 0), 0);

  container.innerHTML = `
    <div class="storage-stats">
      <div class="storage-stat">
        <h4>Total Units</h4>
        <p class="stat-value">${storageUnits.length}</p>
      </div>
      <div class="storage-stat">
        <h4>Monthly Cost</h4>
        <p class="stat-value">$${totalMonthly}</p>
      </div>
      <div class="storage-stat">
        <h4>Annual Cost</h4>
        <p class="stat-value">$${totalMonthly * 12}</p>
      </div>
    </div>

    ${Object.entries(byLocation).map(([location, units]) => `
      <div class="storage-location">
        <h3>📍 ${location} (${units.length} units)</h3>
        ${units.map(u => `
          <div class="storage-unit-card">
            <div class="storage-header">
              <h4>${u.unitNumber}</h4>
              <span class="storage-status ${u.status}">${u.status}</span>
            </div>
            <div class="storage-details">
              <p><strong>Facility:</strong> ${u.facility || 'Not specified'}</p>
              <p><strong>Size:</strong> ${u.size || 'Not specified'}</p>
              <p><strong>Monthly:</strong> $${u.monthlyFee || 0}</p>
              <p><strong>Next Payment:</strong> ${u.nextPayment ? new Date(u.nextPayment).toLocaleDateString() : 'Not set'}</p>
            </div>
            <div class="storage-contents">
              <strong>Contents:</strong>
              <p>${u.contents || 'Not documented'}</p>
            </div>
            <button class="btn-small" onclick="editStorageUnit(${u.id})">Edit</button>
          </div>
        `).join('')}
      </div>
    `).join('')}
  `;
}

function editStorageUnit(id) {
  const unit = storageUnits.find(u => u.id === id);
  if (!unit) return;

  const facility = prompt('Facility name:', unit.facility);
  if (facility !== null) unit.facility = facility;

  const size = prompt('Unit size (e.g., 10x10):', unit.size);
  if (size !== null) unit.size = size;

  const fee = prompt('Monthly fee:', unit.monthlyFee);
  if (fee !== null) unit.monthlyFee = parseFloat(fee) || 0;

  const contents = prompt('Contents:', unit.contents);
  if (contents !== null) unit.contents = contents;

  saveStorageUnits();
  renderStorageUnits();
}

function saveStorageUnits() {
  localStorage.setItem('missionControlStorageUnits', JSON.stringify(storageUnits));
}

function loadStorageUnits() {
  const saved = localStorage.getItem('missionControlStorageUnits');
  if (saved) {
    storageUnits = JSON.parse(saved);
  }
  renderStorageUnits();
}

// Bank Signup Bonus Tracker
let bankOffers = [];

function addBankOffer(bankName, offerAmount, requirements, expirationDate) {
  const offer = {
    id: Date.now(),
    bankName: bankName,
    offerAmount: offerAmount,
    requirements: requirements,
    expirationDate: expirationDate,
    status: 'available',
    appliedDate: null,
    completedDate: null,
    notes: ''
  };
  bankOffers.push(offer);
  saveBankOffers();
  renderBankOffers();
}

function renderBankOffers() {
  const container = document.getElementById('bank-offers-list');
  if (!container) return;

  const totalPotential = bankOffers
    .filter(o => o.status === 'available')
    .reduce((sum, o) => sum + o.offerAmount, 0);

  const totalEarned = bankOffers
    .filter(o => o.status === 'completed')
    .reduce((sum, o) => sum + o.offerAmount, 0);

  container.innerHTML = `
    <div class="bank-stats">
      <div class="bank-stat">
        <h4>Available Bonuses</h4>
        <p class="stat-value">$${totalPotential}</p>
      </div>
      <div class="bank-stat">
        <h4>Earned</h4>
        <p class="stat-value">$${totalEarned}</p>
      </div>
      <div class="bank-stat">
        <h4>Active Offers</h4>
        <p class="stat-value">${bankOffers.filter(o => o.status === 'available').length}</p>
      </div>
    </div>

    <div class="bank-offers-grid">
      ${bankOffers.filter(o => o.status === 'available').map(o => `
        <div class="bank-offer-card">
          <h4>${o.bankName}</h4>
          <p class="offer-amount">$${o.offerAmount}</p>
          <p class="offer-requirements">${o.requirements}</p>
          <p class="offer-expiration">Expires: ${o.expirationDate}</p>
          <button class="btn-small" onclick="markOfferApplied(${o.id})">Applied</button>
        </div>
      `).join('')}
    </div>
  `;
}

function saveBankOffers() {
  localStorage.setItem('missionControlBankOffers', JSON.stringify(bankOffers));
}

function loadBankOffers() {
  const saved = localStorage.getItem('missionControlBankOffers');
  if (saved) {
    bankOffers = JSON.parse(saved);
  }
  renderBankOffers();
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
  loadStorageUnits();
  loadBankOffers();
});

window.editStorageUnit = editStorageUnit;
window.addBankOffer = addBankOffer;
