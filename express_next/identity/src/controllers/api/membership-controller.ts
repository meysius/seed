import { Request, Response, Router } from 'express';
import OrgsService from '@/domain/orgs/orgs-service';
import { ListUserMembershipsResponseSchema } from 'api-types';
import { decorateWithAuth } from '@/utils';

export default class MembershipController {
  public router: Router;
  private orgsService: OrgsService;

  constructor(orgsService: OrgsService) {
    this.orgsService = orgsService;
    this.router = Router();
    this.router.get('/memberships', decorateWithAuth(this.handleGetMemberships));
  }

  private handleGetMemberships = async (req: Request, res: Response, userId: string) => {
    const memberships = await this.orgsService.listUserMemberships(userId);
    const listUserMembershipsResponse = ListUserMembershipsResponseSchema.parse({ memberships });
    res.send(listUserMembershipsResponse).status(200);
  }
}