import { Request, Response, Router } from 'express';
import OrgsService from '@/domain/orgs/orgs-service';
import { CreateOrganizationRequestSchema, CreateOrganizationResponseSchema } from 'api-types';
import { decorateWithAuth } from '@/utils';

export default class OrganizationController {
  public router: Router;
  private orgsService: OrgsService;

  constructor(orgsService: OrgsService) {
    this.orgsService = orgsService;
    this.router = Router();
    this.router.post('/organizations', decorateWithAuth(this.handlePostOrganizations));
  }

  private handlePostOrganizations = async (req: Request, res: Response, userId: string) => {
    const params = CreateOrganizationRequestSchema.parse(req.body);
    const organization = await this.orgsService.createOrganization(userId, params.name);
    const createOrganizationResponse = CreateOrganizationResponseSchema.parse({ organization });
    res.send(createOrganizationResponse).status(200);
  }
}