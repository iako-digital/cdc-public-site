import { Router } from 'express';
import { prisma } from '../lib/prisma';
import { courseCreateSchema, courseUpdateSchema } from '../schemas/courseSchemas';

const router = Router();

router.get('/', async (req, res) => {
  const courses = await prisma.course.findMany({ orderBy: { createdAt: 'desc' } });
  res.json({ data: courses });
});

router.get('/:id', async (req, res) => {
  const course = await prisma.course.findUnique({ where: { id: req.params.id } });
  if (!course) {
    return res.status(404).json({ message: 'Course not found.' });
  }
  res.json({ data: course });
});

router.post('/', async (req, res) => {
  const result = courseCreateSchema.safeParse(req.body);
  if (!result.success) {
    return res.status(400).json({ errors: result.error.errors });
  }

  const course = await prisma.course.create({ data: result.data });
  res.status(201).json({ data: course });
});

router.put('/:id', async (req, res) => {
  const result = courseUpdateSchema.safeParse(req.body);
  if (!result.success) {
    return res.status(400).json({ errors: result.error.errors });
  }

  try {
    const course = await prisma.course.update({ where: { id: req.params.id }, data: result.data });
    res.json({ data: course });
  } catch (err: any) {
    if (err.code === 'P2025') {
      return res.status(404).json({ message: 'Course not found.' });
    }
    throw err;
  }
});

router.delete('/:id', async (req, res) => {
  try {
    await prisma.course.delete({ where: { id: req.params.id } });
    res.status(204).send();
  } catch (err: any) {
    if (err.code === 'P2025') {
      return res.status(404).json({ message: 'Course not found.' });
    }
    throw err;
  }
});

export default router;
