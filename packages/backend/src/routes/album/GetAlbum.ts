import type { FastifyReply } from 'fastify';
import { z } from 'zod';
import prisma from '@/structures/database.js';
import type { File, RequestWithUser } from '@/structures/interfaces.js';
import { fileAsUserSchema } from '@/structures/schemas/FileAsUser.js';
import { http4xxErrorSchema } from '@/structures/schemas/HTTP4xxError.js';
import { http5xxErrorSchema } from '@/structures/schemas/HTTP5xxError.js';
import { queryLimitSchema } from '@/structures/schemas/QueryLimit.js';
import { queryPageSchema } from '@/structures/schemas/QueryPage.js';
import { responseMessageSchema } from '@/structures/schemas/ResponseMessage.js';
import { constructFilePublicLink } from '@/utils/File.js';
import { SETTINGS } from '@/structures/settings.js';

const parseSortOrder = (sortOrder: string | null | undefined): { [key: string]: 'asc' | 'desc' } => {
	const defaultOrder = { id: 'desc' as const };
	if (!sortOrder) return defaultOrder;

	const [field, direction] = sortOrder.split(':');
	if (!field || !direction) return defaultOrder;

	const validFields = ['createdAt', 'name', 'size'];
	const validDirections = ['asc', 'desc'];

	if (!validFields.includes(field) || !validDirections.includes(direction)) {
		return defaultOrder;
	}

	return { [field]: direction as 'asc' | 'desc' };
};

export const schema = {
	summary: 'Get album',
	description: 'Gets the content of an album',
	tags: ['Albums'],
	query: z.object({
		page: queryPageSchema,
		limit: queryLimitSchema
	}),
	response: {
		200: z.object({
			message: responseMessageSchema,
			name: z.string().describe('The name of the album.'),
			description: z.string().nullable().describe('The description of the album.'),
			isNsfw: z.boolean().describe('Whether or not the album is nsfw.'),
			sortOrder: z.string().nullable().describe('The sort order for files in this album.'),
			count: z.number().describe('The number of files in the album.'),
			files: z.array(fileAsUserSchema)
		}),
		'4xx': http4xxErrorSchema,
		'5xx': http5xxErrorSchema
	}
};

export const options = {
	url: '/album/:uuid',
	method: 'get',
	middlewares: ['apiKey', 'auth']
};

export const run = async (req: RequestWithUser, res: FastifyReply) => {
	const { uuid } = req.params as { uuid: string };

	// Set up pagination options
	const { page = 1, limit = 50 } = req.query as { limit?: number; page?: number };
	const options = {
		take: limit,
		skip: (page - 1) * limit
	};

	// First get the album to check ownership and get sortOrder
	const albumMeta = await prisma.albums.findFirst({
		where: {
			uuid,
			userId: req.user.id
		},
		select: {
			sortOrder: true
		}
	});

	if (!albumMeta) {
		void res.notFound('The album could not be found');
		return;
	}

	// Determine sort order: album-specific > global default > fallback
	const effectiveSortOrder = albumMeta.sortOrder || SETTINGS.defaultSortOrder || 'createdAt:desc';
	const orderBy = parseSortOrder(effectiveSortOrder);

	// Make sure the uuid exists and it belongs to the user
	const album = await prisma.albums.findFirst({
		where: {
			uuid,
			userId: req.user.id
		},
		select: {
			name: true,
			description: true,
			nsfw: true,
			sortOrder: true,
			files: {
				select: {
					createdAt: true,
					hash: true,
					ip: true,
					name: true,
					original: true,
					size: true,
					type: true,
					uuid: true,
					isS3: true,
					isWatched: true
				},
				orderBy,
				...options
			},
			_count: true
		}
	});

	if (!album) {
		void res.notFound('The album could not be found');
		return;
	}

	// Construct the public links
	const files = [] as File[];
	for (const file of album.files) {
		const modifiedFile = file as unknown as File;
		files.push({
			...modifiedFile,
			...constructFilePublicLink({ req, fileName: modifiedFile.name, isS3: file.isS3, isWatched: file.isWatched })
		});
	}

	return res.send({
		message: 'Successfully retrieved album',
		name: album.name,
		description: album.description,
		files,
		isNsfw: album.nsfw,
		sortOrder: album.sortOrder,
		count: album._count.files
	});
};
