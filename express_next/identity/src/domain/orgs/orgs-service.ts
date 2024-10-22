import { Membership, Organization } from '@prisma/client';
import { prisma } from '@/prisma-client';
import EmailService from '@/domain/email/email-service';
import { getUniqueConstraintViolation, ValidationError } from '@/domain/errors';

export default class OrgsService {
  private emailService: EmailService;  // needed for invitation emails

  constructor(emailService: EmailService) {
    this.emailService = emailService;
  }

  public async listUserMemberships(userId: string): Promise<Membership[]> {
    const memberships = await prisma.membership.findMany({
      where: { userId },
      include: { organization: true }
    });
    return memberships;
  }

  public async createOrganization(userId: string, name: string): Promise<Organization> {
    try {
      const organization = await prisma.organization.create({
        data: {
          name,
          memberships: { create: { userId, role: 'OWNER', status: 'ACTIVE' } }
        }
      });
      return organization;
    } catch (error) {
      const constraintViolation = getUniqueConstraintViolation(error);
      if (constraintViolation?.model === 'Organization' && constraintViolation?.field === 'name') {
        throw new ValidationError({ name: 'This name is already taken' });
      }
      throw error;
    }
  }
}