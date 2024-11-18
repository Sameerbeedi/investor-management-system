import React from 'react';
import { ArrowUpRight, ArrowDownRight, Briefcase } from 'lucide-react';
import type { Portfolio } from '../../types';

interface PortfolioCardProps {
  portfolio: Portfolio;
}

export function PortfolioCard({ portfolio }: PortfolioCardProps) {
  const isPositive = Math.random() > 0.5; // In real app, calculate based on actual data

  return (
    <div className="bg-white rounded-xl shadow-sm p-6 hover:shadow-md transition-shadow">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-3">
          <div className="p-2 bg-blue-50 rounded-lg">
            <Briefcase className="w-6 h-6 text-blue-600" />
          </div>
          <h3 className="font-semibold text-lg">{portfolio.name}</h3>
        </div>
        <span className={`flex items-center gap-1 text-sm ${
          isPositive ? 'text-green-600' : 'text-red-600'
        }`}>
          {isPositive ? <ArrowUpRight className="w-4 h-4" /> : <ArrowDownRight className="w-4 h-4" />}
          {isPositive ? '+2.4%' : '-1.2%'}
        </span>
      </div>
      
      <div className="grid grid-cols-3 gap-4 mt-4">
        <div>
          <p className="text-sm text-gray-500">Total Value</p>
          <p className="font-semibold">${portfolio.totalValue.toLocaleString()}</p>
        </div>
        <div>
          <p className="text-sm text-gray-500">Assets</p>
          <p className="font-semibold">{portfolio.assetCount}</p>
        </div>
        <div>
          <p className="text-sm text-gray-500">Risk Level</p>
          <span className={`inline-block px-2 py-1 text-xs rounded-full ${
            portfolio.riskLevel === 'High' ? 'bg-red-100 text-red-700' :
            portfolio.riskLevel === 'Medium' ? 'bg-yellow-100 text-yellow-700' :
            'bg-green-100 text-green-700'
          }`}>
            {portfolio.riskLevel}
          </span>
        </div>
      </div>
    </div>
  );
}