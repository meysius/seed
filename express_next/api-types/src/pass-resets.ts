import { z } from 'zod';

export const CreatePassResetRequestSchema = z.object({
  email: z.string().email(),
});
export const CreatePassResetResponseSchema = z.object({
  success: z.boolean(),
});

export const GetPassResetResponseSchema = z.object({
  passResetToken: z.string(),
  passResetTokenCreatedAt: z.string().datetime(),
});

export const UpdatePassResetRequestSchema = z.object({
  password: z.string(),
});
export const UpdatePassResetResponseSchema = z.object({
  success: z.boolean(),
});

export type CreatePassResetRequest = z.infer<typeof CreatePassResetRequestSchema>;
export type CreatePassResetResponse = z.infer<typeof CreatePassResetResponseSchema>;
export type GetPassResetResponse = z.infer<typeof GetPassResetResponseSchema>;
export type UpdatePassResetRequest = z.infer<typeof UpdatePassResetRequestSchema>;
export type UpdatePassResetResponse = z.infer<typeof UpdatePassResetResponseSchema>;