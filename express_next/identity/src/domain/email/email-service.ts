import { Transporter } from 'nodemailer';
import { render, Data } from 'ejs';
import path from 'path';
import fs from 'fs/promises';
import { convert } from 'html-to-text';
import JSONTransport from 'nodemailer/lib/json-transport';
import config from '@/config';

export default class EmailService {
  private transporter: Transporter;
  private sentEmails: JSONTransport.SentMessageInfo[] = [];

  constructor(transporter: Transporter) {
    this.transporter = transporter;
  }

  getSentEmails(): JSONTransport.SentMessageInfo[] {
    return this.sentEmails;
  }

  getSentEmailById(id: string): JSONTransport.SentMessageInfo | undefined {
    return this.sentEmails.find(email => email.messageId === id);
  }

  private sendEmail = async (from: string, to: string, subject: string, html: string): Promise<JSONTransport.SentMessageInfo> => {
    const text = convert(html);
    const email = await this.transporter.sendMail({ from, to, subject, html, text });
    if (config.NODE_ENV !== 'production') {
      this.sentEmails.push(JSON.parse(email.message));
    }
    return email;
  }

  private readTemplate = async (templateName: string, context: Data): Promise<string> => {
    const layoutTemplate = await fs.readFile(path.join(__dirname, '../../views/emails/layout.ejs'), 'utf-8');
    const bodyTemplate = await fs.readFile(path.join(__dirname, `../../views/emails/${templateName}.ejs`), 'utf-8');
    const bodyContent = render(bodyTemplate, context);
    return render(layoutTemplate, { body: bodyContent });
  }

  async sendAccountConfirmation (to: string, context: { link: string }): Promise<JSONTransport.SentMessageInfo> {
    const from = 'no-reply@awesome-app.com';
    const subject = 'Confirm your account';
    const htmlContent = await this.readTemplate('account-confirmation', context);
    return this.sendEmail(from, to, subject, htmlContent);
  }

  async sendPassReset (to: string, context: { link: string }): Promise<JSONTransport.SentMessageInfo> {
    const from = 'no-reply@awesome-app.com';
    const subject = 'Reset your password';
    const htmlContent = await this.readTemplate('pass-reset', context);
    return this.sendEmail(from, to, subject, htmlContent);
  }
}