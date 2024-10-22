import { createTransport } from 'nodemailer';

const transporter = createTransport({
  jsonTransport: true,
});

export default transporter;