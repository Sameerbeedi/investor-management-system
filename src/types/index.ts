export interface Portfolio {
  id: string;
  name: string;
  totalValue: number;
  assetCount: number;
  riskLevel: 'Low' | 'Medium' | 'High';
}

export interface Asset {
  id: string;
  name: string;
  units: number;
  currentPrice: number;
  purchasePrice: number;
  type: 'Stocks' | 'Bonds' | 'Crypto' | 'Real Estate';
}

export interface Transaction {
  id: string;
  portfolioId: string;
  assetId: string;
  type: 'Buy' | 'Sell';
  date: string;
  units: number;
  pricePerUnit: number;
  totalValue: number;
}