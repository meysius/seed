import { PrismaClient, Prisma } from '@prisma/client';
import { AsyncLocalStorage } from 'async_hooks';

export const prisma = new PrismaClient({
  log: process.env.NODE_ENV === 'production' ? [] : ['query'],
})

class TransactionManager {
  private asyncLocalStorage: AsyncLocalStorage<Prisma.TransactionClient>;

  constructor() {
    this.asyncLocalStorage = new AsyncLocalStorage<Prisma.TransactionClient>();
  }

  async withinTransaction<T>(
    callback: (tx: Prisma.TransactionClient) => Promise<T>
  ): Promise<T> {
    const existingTx = this.asyncLocalStorage.getStore();
    if (existingTx) {
      return callback(existingTx);
    }

    return prisma.$transaction(async (tx) => {
      return this.asyncLocalStorage.run(tx, () => callback(tx));
    });
  }
}

const transactionManager = new TransactionManager();
export const withTransaction = transactionManager.withinTransaction.bind(transactionManager);