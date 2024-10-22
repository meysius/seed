import { Request, Response, Router } from 'express';
import EmailService from '@/domain/email/email-service';
import config from '@/config';

export default class EmailPreviewController {
  public router: Router;
  private emailService: EmailService;

  constructor(emailService: EmailService) {
    this.emailService = emailService;
    this.router = Router();

    if (config.NODE_ENV === 'development') {
      this.router.get('/email-previews', this.handleListEmails);
      this.router.get('/email-previews/:id', this.handleViewEmail);
    }
  }

  private handleListEmails = (req: Request, res: Response) => {
    const emails = this.emailService.getSentEmails();
    res.render('email-previews/index', { emails });
  }

  private handleViewEmail = (req: Request, res: Response) => {
    const email = this.emailService.getSentEmailById(req.params.id as string);
    if (!email) {
      return res.status(404).send('Email not found');
    }
    res.render('email-previews/show', { email });
  }
}