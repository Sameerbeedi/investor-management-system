import React, { useState } from 'react';
import type { Portfolio, Asset } from '../../types';

interface TransactionFormProps {
  portfolios: Portfolio[];
  assets: Asset[];
  onSubmit: (data: any) => void;
}

export function TransactionForm({ portfolios, assets, onSubmit }: TransactionFormProps) {
  const [formData, setFormData] = useState({
    portfolioId: '',
    assetId: '',
    type: 'Buy',
    date: new Date().toISOString().split('T')[0],
    units: 0,
    pricePerUnit: 0
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit({
      ...formData,
      totalValue: formData.units * formData.pricePerUnit
    });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6 bg-white p-6 rounded-lg shadow-sm">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label className="block text-sm font-medium text-gray-700">Portfolio</label>
          <select
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            value={formData.portfolioId}
            onChange={(e) => setFormData({ ...formData, portfolioId: e.target.value })}
            required
          >
            <option value="">Select Portfolio</option>
            {portfolios.map((portfolio) => (
              <option key={portfolio.id} value={portfolio.id}>{portfolio.name}</option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700">Asset</label>
          <select
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            value={formData.assetId}
            onChange={(e) => setFormData({ ...formData, assetId: e.target.value })}
            required
          >
            <option value="">Select Asset</option>
            {assets.map((asset) => (
              <option key={asset.id} value={asset.id}>{asset.name}</option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700">Transaction Type</label>
          <div className="mt-1 space-x-4">
            <label className="inline-flex items-center">
              <input
                type="radio"
                className="form-radio text-blue-600"
                name="type"
                value="Buy"
                checked={formData.type === 'Buy'}
                onChange={(e) => setFormData({ ...formData, type: e.target.value as 'Buy' | 'Sell' })}
              />
              <span className="ml-2">Buy</span>
            </label>
            <label className="inline-flex items-center">
              <input
                type="radio"
                className="form-radio text-blue-600"
                name="type"
                value="Sell"
                checked={formData.type === 'Sell'}
                onChange={(e) => setFormData({ ...formData, type: e.target.value as 'Buy' | 'Sell' })}
              />
              <span className="ml-2">Sell</span>
            </label>
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700">Date</label>
          <input
            type="date"
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            value={formData.date}
            onChange={(e) => setFormData({ ...formData, date: e.target.value })}
            required
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700">Units</label>
          <input
            type="number"
            min="0"
            step="0.01"
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            value={formData.units}
            onChange={(e) => setFormData({ ...formData, units: parseFloat(e.target.value) })}
            required
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700">Price per Unit</label>
          <input
            type="number"
            min="0"
            step="0.01"
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
            value={formData.pricePerUnit}
            onChange={(e) => setFormData({ ...formData, pricePerUnit: parseFloat(e.target.value) })}
            required
          />
        </div>
      </div>

      <div className="flex justify-end">
        <button
          type="submit"
          className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
        >
          Submit Transaction
        </button>
      </div>
    </form>
  );
}