import React, { useState } from 'react';
import { LayoutDashboard, History, PlusCircle } from 'lucide-react';
import { PortfolioCard } from './components/dashboard/PortfolioCard';
import { AssetTable } from './components/dashboard/AssetTable';
import { TransactionForm } from './components/transactions/TransactionForm';
import type { Portfolio, Asset, Transaction } from './types';

// Mock data - In a real app, this would come from an API
const mockPortfolios: Portfolio[] = [
  { id: '1', name: 'Growth Portfolio', totalValue: 250000, assetCount: 8, riskLevel: 'High' },
  { id: '2', name: 'Income Portfolio', totalValue: 150000, assetCount: 5, riskLevel: 'Low' },
  { id: '3', name: 'Balanced Portfolio', totalValue: 180000, assetCount: 6, riskLevel: 'Medium' },
];

const mockAssets: Asset[] = [
  { id: '1', name: 'Tesla Inc.', units: 100, currentPrice: 250.50, purchasePrice: 200.75, type: 'Stocks' },
  { id: '2', name: 'Bitcoin', units: 2.5, currentPrice: 45000, purchasePrice: 40000, type: 'Crypto' },
  { id: '3', name: 'US Treasury Bonds', units: 50, currentPrice: 980, purchasePrice: 1000, type: 'Bonds' },
];

function App() {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'transactions'>('dashboard');
  const [showNotification, setShowNotification] = useState(false);
  const [notificationMessage, setNotificationMessage] = useState('');

  const handleTransaction = (transaction: Transaction) => {
    // In a real app, this would make an API call
    console.log('New transaction:', transaction);
    setNotificationMessage('Transaction added successfully');
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Navigation */}
      <nav className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex">
              <div className="flex-shrink-0 flex items-center">
                <LayoutDashboard className="w-8 h-8 text-blue-600" />
                <span className="ml-2 text-xl font-bold text-gray-900">Investment Dashboard</span>
              </div>
            </div>
          </div>
        </div>
      </nav>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Tabs */}
        <div className="flex space-x-4 mb-8">
          <button
            onClick={() => setActiveTab('dashboard')}
            className={`flex items-center px-4 py-2 rounded-lg ${
              activeTab === 'dashboard'
                ? 'bg-blue-600 text-white'
                : 'bg-white text-gray-600 hover:bg-gray-50'
            }`}
          >
            <LayoutDashboard className="w-5 h-5 mr-2" />
            Dashboard
          </button>
          <button
            onClick={() => setActiveTab('transactions')}
            className={`flex items-center px-4 py-2 rounded-lg ${
              activeTab === 'transactions'
                ? 'bg-blue-600 text-white'
                : 'bg-white text-gray-600 hover:bg-gray-50'
            }`}
          >
            <History className="w-5 h-5 mr-2" />
            New Transaction
          </button>
        </div>

        {/* Notification */}
        {showNotification && (
          <div className="fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg">
            {notificationMessage}
          </div>
        )}

        {activeTab === 'dashboard' ? (
          <>
            {/* Portfolios Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
              {mockPortfolios.map((portfolio) => (
                <PortfolioCard key={portfolio.id} portfolio={portfolio} />
              ))}
            </div>

            {/* Assets Table */}
            <div className="bg-white rounded-lg shadow-sm overflow-hidden">
              <div className="px-6 py-4 border-b border-gray-200">
                <h2 className="text-lg font-semibold text-gray-900">Assets Overview</h2>
              </div>
              <AssetTable assets={mockAssets} />
            </div>
          </>
        ) : (
          <div className="bg-white rounded-lg shadow-sm">
            <div className="px-6 py-4 border-b border-gray-200">
              <h2 className="text-lg font-semibold text-gray-900">New Transaction</h2>
            </div>
            <TransactionForm
              portfolios={mockPortfolios}
              assets={mockAssets}
              onSubmit={handleTransaction}
            />
          </div>
        )}
      </main>
    </div>
  );
}

export default App;