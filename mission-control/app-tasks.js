// Mission Control - Task Management System

let todos = [
  {
    id: 101,
    text: "Sign up for Smartlead ($80/mo) - https://smartlead.ai",
    category: "business",
    priority: "critical",
    status: "todo",
    notes: "Email automation for ClaimHaus outreach. Connect gabriel@claimhaus.com",
    createdAt: Date.now()
  },
  {
    id: 102,
    text: "Sign up for Hunter.io ($49/mo) - https://hunter.io",
    category: "business",
    priority: "critical",
    status: "todo",
    notes: "Email finder for contact enrichment. Install Chrome extension",
    createdAt: Date.now()
  },
  {
    id: 103,
    text: "Deploy ClaimHaus landing page - claimhaus.com",
    category: "business",
    priority: "high",
    status: "todo",
    notes: "Deploy landing-pages/claimhaus.html to Vercel or Netlify (15 min)",
    createdAt: Date.now()
  },
  {
    id: 104,
    text: "Configure email sequence in Smartlead",
    category: "business",
    priority: "high",
    status: "todo",
    notes: "Upload 10 contacts, configure 4-step sequence, schedule for Monday 9 AM",
    createdAt: Date.now()
  },
  {
    id: 105,
    text: "Book 3 ClaimHaus pilot meetings this week",
    category: "business",
    priority: "high",
    status: "todo",
    notes: "Target: Sherman Financial, Encore Capital, Portfolio Recovery Associates",
    createdAt: Date.now()
  },
  {
    id: 106,
    text: "Close first ClaimHaus pilot ($5K)",
    category: "business",
    priority: "high",
    status: "todo",
    notes: "90-day pilot, up to $5M portfolio tokenization",
    createdAt: Date.now()
  },
  {
    id: 1,
    text: "Oil Change - 2005 Land Rover LR3",
    location: "100 Westgate St West Hartford CT 06110",
    category: "vehicle",
    priority: "medium",
    status: "todo",
    createdAt: Date.now()
  },
  {
    id: 2,
    text: "Get Boys Haircuts",
    category: "family",
    priority: "medium",
    status: "todo",
    createdAt: Date.now()
  },
  {
    id: 3,
    text: "Order Zima Board",
    category: "purchase",
    priority: "low",
    status: "todo",
    createdAt: Date.now()
  },
  {
    id: 4,
    text: "Order Mouse",
    category: "purchase",
    priority: "low",
    status: "todo",
    createdAt: Date.now()
  },
  {
    id: 5,
    text: "Send Zack a Paid Invoice",
    category: "business",
    priority: "high",
    status: "todo",
    createdAt: Date.now()
  },
  {
    id: 6,
    text: "Reach out to Label Guy & Order Sample Pack",
    category: "business",
    priority: "medium",
    status: "todo",
    createdAt: Date.now()
  }
];

// Financial Tracking
let financials = {
  bills: [],
  subscriptions: [],
  debt: [],
  propertyTaxes: [],
  domainRenewals: [],
  serverCosts: [],
  corporationFees: [],
  personalCredit: {},
  businessCredit: {} // Gabriel has large doc for this
};

// Patent Portfolio (47 provisional patents)
let patents = [];

// ========== TODO FUNCTIONS ==========

function addTodo(text, category = "general", priority = "medium") {
  const todo = {
    id: Date.now(),
    text: text,
    category: category,
    priority: priority,
    status: "todo",
    createdAt: Date.now()
  };
  todos.push(todo);
  saveTodos();
  renderTodos();
}

function completeTodo(id) {
  const todo = todos.find(t => t.id === id);
  if (todo) {
    todo.status = "completed";
    todo.completedAt = Date.now();
    saveTodos();
    renderTodos();
  }
}

function renderTodos() {
  const container = document.getElementById('todo-list');
  if (!container) return;

  const activeTodos = todos.filter(t => t.status === "todo");
  const completedTodos = todos.filter(t => t.status === "completed");

  const priorityColors = {
    high: '#ff4444',
    medium: '#ffcc00',
    low: '#00ff88'
  };

  container.innerHTML = `
    <div class="todo-section">
      <h3>📋 Active Tasks (${activeTodos.length})</h3>
      ${activeTodos.map(t => `
        <div class="todo-item" style="border-left: 3px solid ${priorityColors[t.priority]}">
          <input type="checkbox" onchange="completeTodo(${t.id})">
          <span class="todo-text">${t.text}</span>
          <span class="todo-category">${t.category}</span>
          ${t.location ? `<span class="todo-location">📍 ${t.location}</span>` : ''}
        </div>
      `).join('')}
    </div>

    <div class="todo-section completed">
      <h3>✅ Completed (${completedTodos.length})</h3>
      ${completedTodos.slice(0, 10).map(t => `
        <div class="todo-item completed">
          <span class="todo-text">${t.text}</span>
        </div>
      `).join('')}
    </div>
  `;
}

function saveTodos() {
  localStorage.setItem('missionControlTodos', JSON.stringify(todos));
}

function loadTodos() {
  const saved = localStorage.getItem('missionControlTodos');
  if (saved) {
    todos = JSON.parse(saved);
  }
  renderTodos();
}

// ========== FINANCIAL TRACKING ==========

function addBill(name, amount, dueDate, category = "general") {
  const bill = {
    id: Date.now(),
    name: name,
    amount: amount,
    dueDate: dueDate,
    category: category,
    status: "pending",
    createdAt: Date.now()
  };
  financials.bills.push(bill);
  saveFinancials();
  renderBills();
}

function renderBills() {
  const container = document.getElementById('bills-list');
  if (!container) return;

  container.innerHTML = `
    <div class="financial-section">
      <h3>💳 Bills & Subscriptions</h3>
      ${financials.bills.length === 0 ? '<p class="empty">No bills tracked yet</p>' : ''}
      ${financials.bills.map(b => `
        <div class="bill-item">
          <span class="bill-name">${b.name}</span>
          <span class="bill-amount">$${b.amount}</span>
          <span class="bill-due">${new Date(b.dueDate).toLocaleDateString()}</span>
        </div>
      `).join('')}
    </div>
  `;
}

function saveFinancials() {
  localStorage.setItem('missionControlFinancials', JSON.stringify(financials));
}

function loadFinancials() {
  const saved = localStorage.getItem('missionControlFinancials');
  if (saved) {
    financials = JSON.parse(saved);
  }
  renderBills();
}

// ========== PATENT TRACKING ==========

function addPatent(title, patentNumber, filedDate, status = "provisional") {
  const patent = {
    id: Date.now(),
    title: title,
    patentNumber: patentNumber,
    filedDate: filedDate,
    status: status, // provisional, pending, granted, expired
    fees: [],
    notes: "",
    createdAt: Date.now()
  };
  patents.push(patent);
  savePatents();
  renderPatents();
}

function renderPatents() {
  const container = document.getElementById('patents-list');
  if (!container) return;

  const statusColors = {
    provisional: '#ffcc00',
    pending: '#00d4ff',
    granted: '#00ff88',
    expired: '#ff4444'
  };

  container.innerHTML = `
    <div class="patent-section">
      <h3>🔬 Patent Portfolio (${patents.length}/47)</h3>
      ${patents.length === 0 ? '<p class="empty">No patents tracked yet. Import from your records.</p>' : ''}
      ${patents.map(p => `
        <div class="patent-item" style="border-left: 3px solid ${statusColors[p.status]}">
          <span class="patent-title">${p.title}</span>
          <span class="patent-number">${p.patentNumber || 'Pending'}</span>
          <span class="patent-status">${p.status}</span>
          <span class="patent-date">Filed: ${new Date(p.filedDate).toLocaleDateString()}</span>
        </div>
      `).join('')}
    </div>
  `;
}

function savePatents() {
  localStorage.setItem('missionControlPatents', JSON.stringify(patents));
}

function loadPatents() {
  const saved = localStorage.getItem('missionControlPatents');
  if (saved) {
    patents = JSON.parse(saved);
  }
  renderPatents();
}

// Initialize on load
document.addEventListener('DOMContentLoaded', () => {
  loadTodos();
  loadFinancials();
  loadPatents();
});

// Export for HTML buttons
window.addTodo = addTodo;
window.completeTodo = completeTodo;
window.addBill = addBill;
window.addPatent = addPatent;
